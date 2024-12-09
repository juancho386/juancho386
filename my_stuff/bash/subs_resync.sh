#!/bin/bash
reqs="ffprobe bc awk grep"

for req in $reqs; do
	which $req >/dev/null
	if [[ "$?" != "0" ]]; then
		echo "$req is not installed"
		exit 1
	fi
done

if [[ ! -f "$1" ]]; then
	echo 'Param required: video file'
	exit 1
fi

fps=$(ffprobe -i $1 -select_streams v -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 2>&1| grep -oE "[0-9]{1,3} fps"|grep -oE "[0-9]+")

if [[ ! -n "$fps" ]]; then
	echo "Video FPS not found. Enter manually?"
	exit 1
	# TODO: manually enter FPS
fi
echo "- Detected $fps FPS"

factor=$(bc -l <<< "scale=7;23.976/$fps")

base=${1::-4}
srt=${base}.srt

if [[ ! -f "$srt" ]]; then
	echo "SRT does not exist. Exiting..."
	exit 1
fi

fixed_srt=${base}_fixed.srt

awk -v factor=$factor '{
  	if ($0 ~ /-->/) {
		split($1, start, ":");
		split($3, end, ":");
		start_ms = (start[1] * 3600 + start[2] * 60 + start[3]) * 1000 * factor;
		end_ms = (end[1] * 3600 + end[2] * 60 + end[3]) * 1000 * factor;
		printf "%02d:%02d:%06.3f --> %02d:%02d:%06.3f\n", \
			int(start_ms / 3600000), int(start_ms / 60000) % 60, start_ms / 1000 % 60, \
			int(end_ms / 3600000), int(end_ms / 60000) % 60, end_ms / 1000 % 60;
	} else {
		print;
	}
}' $srt > $fixed_srt

echo "- $fixed_srt created"

