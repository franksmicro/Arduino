/*
  RFIDSend
  
  This program sends arbitrary RFID codes (normal manchester
  coding).  Pin 5 should be connected to base of NPN transistor
  through 5k resistor, with 125kHz parallel LC circuit connected
  between base and emitter of transistor.
  
  Written by Frank Kienast in October, 2010
  
*/
  
int outPin = 5;

//Going to use variables for these vs defines.  Later might 
//want to read these dynamically from code.
byte manfId = 0x01;
unsigned long uniqueId = 0x02030405;

byte bits[64];
int bitIndex = 0;

void setup()
{
  int i;
  
  pinMode(outPin, OUTPUT);
  
  //Calculate all the bits that have to be sent
  //First 9 bits always 1
  for(i = 0; i < 9; i++)
    bits[i] = 1;  
  bits[9] =  (manfId >> 7) & 1;
  bits[10] = (manfId >> 6) & 1;
  bits[11] = (manfId >> 5) & 1;
  bits[12] = (manfId >> 4) & 1;
  bits[13] = bits[9] ^ bits[10] ^ bits[11] ^ bits[12];
  bits[14] = (manfId >> 3) & 1;
  bits[15] = (manfId >> 2) & 1;
  bits[16] = (manfId >> 1) & 1;
  bits[17] = (manfId >> 0) & 1;
  bits[18] = bits[14] ^ bits[15] ^ bits[16] ^ bits[17];
  bits[19] = (uniqueId >> 31) & 1;
  bits[20] = (uniqueId >> 30) & 1;
  bits[21] = (uniqueId >> 29) & 1;
  bits[22] = (uniqueId >> 28) & 1;
  bits[23] = bits[19] ^ bits[20] ^ bits[21] ^ bits[22];
  bits[24] = (uniqueId >> 27) & 1;
  bits[25] = (uniqueId >> 26) & 1;
  bits[26] = (uniqueId >> 25) & 1;
  bits[27] = (uniqueId >> 24) & 1;
  bits[28] = bits[24] ^ bits[25] ^ bits[26] ^ bits[27];
  bits[29] = (uniqueId >> 23) & 1;
  bits[30] = (uniqueId >> 22) & 1;
  bits[31] = (uniqueId >> 21) & 1;
  bits[32] = (uniqueId >> 20) & 1;
  bits[33] = bits[29] ^ bits[30] ^ bits[31] ^ bits[32];
  bits[34] = (uniqueId >> 19) & 1;
  bits[35] = (uniqueId >> 18) & 1;
  bits[36] = (uniqueId >> 17) & 1;
  bits[37] = (uniqueId >> 16) & 1;
  bits[38] = bits[34] ^ bits[35] ^ bits[36] ^ bits[37];
  bits[39] = (uniqueId >> 15) & 1;
  bits[40] = (uniqueId >> 14) & 1;
  bits[41] = (uniqueId >> 13) & 1;
  bits[42] = (uniqueId >> 12) & 1;
  bits[43] = bits[39] ^ bits[40] ^ bits[41] ^ bits[42];
  bits[44] = (uniqueId >> 11) & 1;
  bits[45] = (uniqueId >> 10) & 1;
  bits[46] = (uniqueId >> 9) & 1;
  bits[47] = (uniqueId >> 8) & 1;
  bits[48] = bits[44] ^ bits[45] ^ bits[46] ^ bits[47];
  bits[49] = (uniqueId >> 7) & 1;
  bits[50] = (uniqueId >> 6) & 1;
  bits[51] = (uniqueId >> 5) & 1;
  bits[52] = (uniqueId >> 4) & 1;
  bits[53] = bits[49] ^ bits[50] ^ bits[51] ^ bits[52];
  bits[54] = (uniqueId >> 3) & 1;
  bits[55] = (uniqueId >> 2) & 1;
  bits[56] = (uniqueId >> 1) & 1;
  bits[57] = (uniqueId >> 0) & 1;
  bits[58] = bits[54] ^ bits[55] ^ bits[56] ^ bits[57];
  bits[59] = bits[9]  ^ bits[14] ^ bits[19] ^ bits[24] ^ bits[29] ^ bits[34] ^ bits[39] ^ bits[44] ^ bits[49] ^ bits[54];
  bits[60] = bits[10] ^ bits[15] ^ bits[20] ^ bits[25] ^ bits[30] ^ bits[35] ^ bits[40] ^ bits[45] ^ bits[50] ^ bits[55];
  bits[61] = bits[11] ^ bits[16] ^ bits[21] ^ bits[26] ^ bits[31] ^ bits[36] ^ bits[41] ^ bits[46] ^ bits[51] ^ bits[56];
  bits[62] = bits[12] ^ bits[17] ^ bits[22] ^ bits[27] ^ bits[32] ^ bits[37] ^ bits[42] ^ bits[47] ^ bits[52] ^ bits[57];
  bits[63] = 0;
  
}

void loop()
{
  int timerBit, currentBit, outVal;
  
  timerBit = waitTimerChange();
  if(timerBit == 0)
    bitIndex++;
  if(bitIndex > 63)
    bitIndex -= 64;
  currentBit = bits[bitIndex];
  outVal = timerBit ^ currentBit;
  if(outVal == 1)
    digitalWrite(outPin,LOW);
  else
    digitalWrite(outPin,HIGH);
  
}

byte waitTimerChange()
{
  //Bit 8 will change every 256 us
  
  unsigned long timer = micros();
  byte oldval, newval;
  oldval = (timer >> 8) & 1;
  do
  {
    timer = micros();
    newval = (timer >> 8) & 1;
  }
  while(newval == oldval);
  
  return newval;
}
    


