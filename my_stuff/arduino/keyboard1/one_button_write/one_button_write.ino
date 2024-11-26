#include "Keyboard.h"
const int buttonPin = 1;
int buttonState = 0;
char t[] = "Hola Chacha paticha!";

int len(char a[]) {
  int j;
  for (j=0;a[j]!=0;j++);
  return j;
}

void setup() {
  digitalWrite(LED_BUILTIN,HIGH);
  Keyboard.begin();
  pinMode(buttonPin, INPUT_PULLDOWN);
  pinMode(LED_BUILTIN, OUTPUT);
  delay(500);
  digitalWrite(LED_BUILTIN,LOW);
}

void loop() {
  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) {
    digitalWrite(LED_BUILTIN,HIGH);
    for (int i=0;i<len(t);i++)
      Keyboard.write(t[i]);
    digitalWrite(LED_BUILTIN,LOW);
  }
}
