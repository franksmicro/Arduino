/*
  Keeloq.h - Crypto library
  Written by Frank Kienast in November, 2010
*/
#ifndef Keeloq_h
#define Keeloq_h

#include "WProgram.h"

class Keeloq
{
  public:
    Keeloq(unsigned long keyHigh, unsigned long keyLow);
    unsigned long encrypt(unsigned long data);
    unsigned long decrypt(unsigned long data);
  private:
    unsigned long _keyHigh;
	unsigned long _keyLow;
};

#endif

