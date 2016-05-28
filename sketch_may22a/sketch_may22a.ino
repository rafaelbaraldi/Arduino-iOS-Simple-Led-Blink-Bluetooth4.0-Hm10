/****************************************/
#define ledPin 13  // //pin 13 built-in LED light
int val;
void setup()
{
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
}
void loop()
{
  if(Serial.available()) //
  {
    val = Serial.read();
    if(val =='A')  //if comes a 'A',LED on control board will blink
    {
      digitalWrite(ledPin, HIGH);
      Serial.println("ligado");  //print on Serial debugging assistant on computer
    }
    else if(val == 'B'){
      digitalWrite(ledPin, LOW);
      Serial.println("desligado");  //print on Serial debugging assistant on computer
    }
  }
}
/****************************************/
