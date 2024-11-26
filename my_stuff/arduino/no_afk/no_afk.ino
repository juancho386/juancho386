#include <Keyboard.h>

const int buttonPin = 1;
int buttonState = 0;
char keys[5] = "awsd";
int btnOnOff = 0;

void on_off() {
  if (btnOnOff == 0) {
    btnOnOff = 1;
    digitalWrite(LED_BUILTIN, HIGH);
  } else {
    btnOnOff = 0;
    digitalWrite(LED_BUILTIN, LOW);
  }
  delay(500);
}

void setup() {
  digitalWrite(LED_BUILTIN, HIGH);
  Keyboard.begin();
  randomSeed(analogRead(0));
  pinMode(buttonPin, INPUT_PULLDOWN);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
}

void loop() {
  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH)
    on_off();
  if (btnOnOff == 1) {
    Keyboard.print(keys[random(4)]);
    delay(random(100, 2000));
  }
}
