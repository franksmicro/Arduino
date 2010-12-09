#include <Xtea.h>

unsigned long key[4] = {0x01020304,0x05060708,0x090a0b0c,0x0d0e0f00};
Xtea x(key);

void setup()
{
  Serial.begin(9600);
  unsigned long v[2] = {0x74657374,0x54455354};
  x.encrypt(v);
  Serial.print("After encrypt: ");
  Serial.print(v[0],HEX);
  Serial.print(" ");
  Serial.println(v[1],HEX);
  x.decrypt(v);
  Serial.print("After decrypt: ");
  Serial.print(v[0],HEX);
  Serial.print(" ");
  Serial.println(v[1],HEX); 
}

void loop()
{
}


