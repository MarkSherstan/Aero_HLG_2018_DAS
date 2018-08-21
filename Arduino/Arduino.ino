// Test data for DAS (LED and Servo and some Analog Voltage values (can easily be a transducer))

#include <Servo.h>

Servo myservo;                               // create servo object 

char val;                                    // Data received from the serial port
int ledPin = 13;                             // LED pin will be 13
boolean ledState = LOW;                      // Toggle LED

void setup() {
  pinMode(ledPin, OUTPUT);                   // Set pin as OUTPUT
  myservo.attach(9);                         // Servo connected to pin 9
  myservo.write(0);                          // Initialize servo position to zero
  Serial.begin(9600);                        // Baud rate of 9600 - Make sure to match with Processing code
  establishContact();                        // send a byte to establish contact until responce received
}


void loop(){
  if (Serial.available() > 0) {               // If data is available
    val = Serial.read();                      // Store data in val (if available)

    if(val == '1') {                          // If val is == 1
       ledState = HIGH;                       // Toggle the LED
       digitalWrite(ledPin, ledState);        

       myservo.write(180);                    // Move servo 180 degrees
    }
  } 
  
    else {                                    // This is where the altitude or other transducers would go (A0 for now)
    int sensorValue = analogRead(A0);
    float voltage = sensorValue * (5.0 / 1023.0);
    Serial.println(voltage);
    }
}


void establishContact() {                      // Syncing arduino and processing together - establish connection 
  while (Serial.available() <= 0) {            // Need data in serial 
  Serial.println("A");                         // send "A", communication with processing 
  delay(300);                                  // Pause so we dont overload
  }
}

