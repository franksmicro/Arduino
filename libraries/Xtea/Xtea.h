/*
  Xtea.h - Crypto library
  Written by Frank Kienast in November, 2010
*/
#ifndef Xtea_h
#define Xtea_h

#if defined(ARDUINO) && ARDUINO >= 100
  #include "Arduino.h"
#else
  #include "WProgram.h"
#endif

class Xtea
{
  public:
    Xtea(unsigned long key[4]);
    void encrypt(unsigned long data[2]);
    void decrypt(unsigned long data[2]);
  private:
    unsigned long _key[4];
};

#endif

