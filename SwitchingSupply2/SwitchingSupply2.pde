#include <LiquidCrystal.h>

/*
  SwitchingSupply - Switching power supply using Arduino.
  
  Written by Frank Kienast in November, 2010
*/

#define ANALOG1V 920

LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

int inPin = A4;
int outPin = 5;

int pwmVal = 0;
unsigned long loopcnt = 0;

void setup()
{
  analogReference(INTERNAL);
  pinMode(inPin,INPUT);
  pinMode(outPin,OUTPUT);
  setPwmFrequency(5,1); //Fast as possible
  lcd.begin(16, 2);
  delay(1000);
  lcd.clear();
  lcd.print("Starting...");
  delay(1000);
}

void loop()
{
  int voltage = analogRead(inPin);
  if(voltage < ANALOG1V)
    pwmVal++;
  else if(voltage > ANALOG1V)
    pwmVal--;
  if(pwmVal > 125) pwmVal = 125;
  if(pwmVal < 0) pwmVal = 0;

  analogWrite(outPin,pwmVal);
  if((loopcnt % 5000) == 0)
  {
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("VRef=");
    lcd.print((double) voltage / (double) ANALOG1V,3);
    lcd.print("V");
    lcd.setCursor(0,1);
    lcd.print("PWM=");
    lcd.print(100.0 * ((double)pwmVal / (double)256),1);
    lcd.print("%");
  }
  loopcnt++;
}
  
  /**
 * Divides a given PWM pin frequency by a divisor.
 * 
 * The resulting frequency is equal to the base frequency divided by
 * the given divisor:
 *   - Base frequencies:
 *      o The base frequency for pins 3, 9, 10, and 11 is 31250 Hz.
 *      o The base frequency for pins 5 and 6 is 62500 Hz.
 *   - Divisors:
 *      o The divisors available on pins 5, 6, 9 and 10 are: 1, 8, 64,
 *        256, and 1024.
 *      o The divisors available on pins 3 and 11 are: 1, 8, 32, 64,
 *        128, 256, and 1024.
 * 
 * PWM frequencies are tied together in pairs of pins. If one in a
 * pair is changed, the other is also changed to match:
 *   - Pins 5 and 6 are paired.
 *   - Pins 9 and 10 are paired.
 *   - Pins 3 and 11 are paired.
 * 
 * Note that this function will have side effects on anything else
 * that uses timers:
 *   - Changes on pins 3, 5, 6, or 11 may cause the delay() and
 *     millis() functions to stop working. Other timing-related
 *     functions may also be affected.
 *   - Changes on pins 9 or 10 will cause the Servo library to function
 *     incorrectly.
 * 
 * Thanks to macegr of the Arduino forums for his documentation of the
 * PWM frequency divisors. His post can be viewed at:
 *   http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1235060559/0#4
 */
void setPwmFrequency(int pin, int divisor) {
  byte mode;
  if(pin == 5 || pin == 6 || pin == 9 || pin == 10) {
    switch(divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 64: mode = 0x03; break;
      case 256: mode = 0x04; break;
      case 1024: mode = 0x05; break;
      default: return;
    }
    if(pin == 5 || pin == 6) {
      TCCR0B = TCCR0B & 0b11111000 | mode;
    } else {
      TCCR1B = TCCR1B & 0b11111000 | mode;
    }
  } else if(pin == 3 || pin == 11) {
    switch(divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 32: mode = 0x03; break;
      case 64: mode = 0x04; break;
      case 128: mode = 0x05; break;
      case 256: mode = 0x06; break;
      case 1024: mode = 0x7; break;
      default: return;
    }
    TCCR2B = TCCR2B & 0b11111000 | mode;
  }
}

  
