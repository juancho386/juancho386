#include <mpg123.h>
#include <alsa/asoundlib.h>
#include <iostream>
#include <fstream>
#include <string>
#include <thread>
#include <atomic>
#include <vector>
#include <algorithm>

class MP3Player {
public:
	MP3Player(const std::string& path);
	~MP3Player();

	void play();
	void stop();
	void pause();
	void rewind();
	void fastForward();
	void next();
	void prev();
	void run();
	void showInfo();

private:
	void loadFile(const std::string& path);
	void playbackLoop();

	std::atomic<bool> isPlaying;
	std::atomic<bool> isPaused;
	std::atomic<bool> shouldExit;

	mpg123_handle *mpgHandle;
	snd_pcm_t *pcmHandle;
	std::thread playbackThread;
	std::vector<std::string> playlist;
	int currentTrack;
};

MP3Player::MP3Player(const std::string& path): isPlaying(false), isPaused(false), shouldExit(false), currentTrack(0) {
	mpg123_init();
	mpgHandle = mpg123_new(nullptr, nullptr);
	snd_pcm_open(&pcmHandle, "default", SND_PCM_STREAM_PLAYBACK, 0);
	loadFile(path);
}

MP3Player::~MP3Player() {
	stop();
	if (playbackThread.joinable()) {
		playbackThread.join();
	}
	snd_pcm_close(pcmHandle);
	mpg123_close(mpgHandle);
	mpg123_delete(mpgHandle);
	mpg123_exit();
}

void MP3Player::loadFile(const std::string& path) {
	std::ifstream file(path);
	std::string line;
	while (std::getline(file, line)) {
		playlist.push_back(line);
	}
}

void MP3Player::play() {
	isPlaying = true;
	if (!playbackThread.joinable()) {
		playbackThread = std::thread(&MP3Player::run, this);
	}
}

void MP3Player::run() {
	while (!shouldExit) {
		if (isPlaying && !isPaused) {
			playbackLoop();
		}
	}
}

void MP3Player::playbackLoop() {
	unsigned char *buffer = nullptr;
	size_t buffer_size = 0;
	size_t done = 0;
	off_t trackLength, trackPos;
	double progress = 0.0;

	mpg123_open(mpgHandle, playlist[currentTrack].c_str());

	int channels, encoding;
	long rate;

	mpg123_getformat(mpgHandle, &rate, &channels, &encoding);
	snd_pcm_set_params(pcmHandle, SND_PCM_FORMAT_S16_LE, SND_PCM_ACCESS_RW_INTERLEAVED, channels, rate, 1, 500000);

	buffer_size = mpg123_outblock(mpgHandle); // Obtener el tamaño adecuado del búfer
	buffer = new unsigned char[buffer_size]; // Reservar memoria para el búfer

	while (mpg123_read(mpgHandle, buffer, buffer_size, &done) == MPG123_OK && isPlaying) {
		if (!isPaused) {
			snd_pcm_writei(pcmHandle, buffer, done / (2 * channels)); // Escribir audio
		}

		// Mostrar el porcentaje de progreso
		trackLength = mpg123_length(mpgHandle);
		trackPos = mpg123_tell(mpgHandle);

		if (trackLength > 0) {
			progress = (double(trackPos) / double(trackLength)) * 100.0;
			std::cout << "\rProgreso: " << int(progress) << "%     " << std::flush;
		}
	}

	delete[] buffer; // Liberar memoria
	mpg123_close(mpgHandle);
}

void MP3Player::stop() {
	isPlaying = false;
	shouldExit = true;
}

void MP3Player::pause() {
	isPaused = !isPaused;
	if (!isPaused)
		showInfo();
}

void MP3Player::rewind() {
	off_t currentPos = mpg123_tell(mpgHandle);
	currentPos = std::max(off_t(0), currentPos - 5 * 44100); // Rebobinar 5 segundos (44100 muestras por segundo)
	mpg123_seek(mpgHandle, currentPos, SEEK_SET);
}

void MP3Player::fastForward() {
	off_t currentPos = mpg123_tell(mpgHandle);
	off_t trackLength = mpg123_length(mpgHandle);
	currentPos = std::min(trackLength, currentPos + 5 * 44100); // Avanzar 5 segundos
	mpg123_seek(mpgHandle, currentPos, SEEK_SET);
}

void MP3Player::next() {
	currentTrack = (currentTrack + 1) % playlist.size();
	mpg123_open(mpgHandle, playlist[currentTrack].c_str());
	showInfo();
	mpg123_seek(mpgHandle, 0, SEEK_SET);  // Iniciar desde el principio de la nueva pista
}

void MP3Player::prev() {
	currentTrack = (currentTrack - 1 + playlist.size()) % playlist.size();
	mpg123_open(mpgHandle, playlist[currentTrack].c_str());
	showInfo();
	mpg123_seek(mpgHandle, 0, SEEK_SET);  // Iniciar desde el principio de la nueva pista
}

void MP3Player::showInfo() {
	std::cout << "\n" << playlist[currentTrack].c_str() << "\n";
}

int main(int argc, char *argv[]) {
	if (argc != 2) {
		std::cerr << "Uso: " << argv[0] << " <archivo_lista_de_reproduccion>" << std::endl;
		return 1;
	}

	MP3Player player(argv[1]);
	player.play();

	char command;
	while (true) {
		std::cout << "Comando (p: play/pause, s: stop, r: rewind 5s, f: ff 5s, n: next, b: prev, q: quit): \n";
		std::cin >> command;

		if (command == 'p') {
			player.pause();
		} else if (command == 's') {
			player.stop();
			break;
		} else if (command == 'r') {
			player.rewind();
		} else if (command == 'f') {
			player.fastForward();
		} else if (command == 'n') {
			player.next();
		} else if (command == 'b') {
			player.prev();
		} else if (command == 'q') {
			player.stop();
			break;
		}
	}

	return 0;
}

