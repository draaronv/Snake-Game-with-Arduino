unsigned char Re_buf3[11], counter = 0;
unsigned char sign = 0;
float a3[3], w3[3], angle3[3], T;
  int skey = 0;
  int wkey = 0;
  int dkey = 0;
  int akey = 0;
void setup() {
  Serial3.begin(115200);// Start Serial
  Serial.begin(115200);
  Serial3.write(0xFF);// Start calibration
  Serial3.write(0xAA);// Start calibration
  Serial3.write(0x65);// Start calibration
}
void loop()
{
  if (sign)
  {
    sign = 0;
    int i = 0;
    if (Re_buf3[0] == 0x55)
    {
      if (Re_buf3 [1] == 0x51)
      {
        a3[0] = (short(Re_buf3 [3] << 8 | Re_buf3 [2])) / 32768.0 * 16;
        a3[1] = (short(Re_buf3 [5] << 8 | Re_buf3 [4])) / 32768.0 * 16;
        if (a3[1] < -0.80 )
        {
          skey = 1;
        }

        if (a3[1] > 0.80 )
        {
          wkey = 1;
        }

        if (a3[0] < -0.80 )
        {
          dkey = 1;
        }

        if (a3[0] > 0.80)
        {
          akey = 1;
        }
        Serial.print(skey);//Send Lval
        Serial.print(',');
        Serial.print(wkey);//Send Lval
        Serial.print(',');
        Serial.print(dkey);//Send Lval
        Serial.print(',');
        Serial.print(akey);//Send Lval
        Serial.println(',');
        skey = 0;
        wkey = 0;
        dkey = 0;
        akey = 0;
        delay(10);
      }
    }
  }
}
void serialEvent3()
{
  while (Serial3.available())
  {
    Re_buf3[counter] = (unsigned char)Serial3.read();
    if (counter == 0 && Re_buf3[0] != 0x55) return;
    counter++;
    if (counter == 11)
    {
      counter = 0;
      sign = 1;
    }
  }
}
