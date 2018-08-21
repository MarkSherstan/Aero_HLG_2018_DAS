//////////////////////////////////////////
// Initializing 
//////////////////////////////////////////

import processing.video.*;                            // Library for video processing
import processing.serial.*;                           // Library for arduino fetching

PImage img;                                           // Setting up image for later
String val;                                           // Data received from serial port

Capture video;                                        // Create object from capture class
Serial myPort;                                        // Create object from Serial class

boolean firstContact = false;                         // Connection with the Arduino
boolean recording = false;                            // Recording on/off toggle (use r or R)
boolean dropping = false;                             // Dropping toggle (space bar)
boolean toggle = true;                                // Toggle data on screen 

float altitude;
float dropTime;
float distance;
float airSpeed = 6;

float gyroPitch;                                      // In accordance to http://www.machinedesign.com/sites/machinedesign.com/files/pry-promo.gif
float gyroRoll;                                       // In accordance to http://www.machinedesign.com/sites/machinedesign.com/files/pry-promo.gif
float xIMU;                                           // X IMU correction  
float yIMU;                                           // Y IMU correction

float xCorrection;                                    // Total x correction due to IMU and altitude, speed, etc...
float yCorrection;                                    // Total y correction due to IMU and altitude, speed, etc...

int round = 0;                                        // Round number for comp [1 2 3 4 5 or 0 - testing]
int scale = 5;                                        // One pixel equals "scale" meters... 
  
int dd = day();
int mmm = month();
int yyyy = year();

//////////////////////////////////////////
// Set up - Executes once 
//////////////////////////////////////////

void setup() {
  //printArray(Capture.list());                       // Use this to see list of available cameras
  //printArray(Serial.list());                        // Use this to see list of available serial ports
  
  size(640,480);                                      // Change this to match resolution (uncomment above - line 44) 
 
  String portName = Serial.list()[1];                 // Ensure port matches arduino (uncomment above - line 45)
  myPort = new Serial(this, portName, 9600);          // Ensure baud matches arduino code (9600 normally)
  
  video = new Capture(this,Capture.list()[1]);        // Ensure video port is the right one (uncomment above - line 44)
  video.start();  
  
  img = loadImage("AeroLogo.png");                    // Load Aero logo for placing later 
    
  myPort.bufferUntil('\n');                           // Buffer data to get connection with arduino 
}

//////////////////////////////////////////
// Draw - Loops
//////////////////////////////////////////

void draw() {
  background(0);                                      // Set background to black   
    
  image(video,0,0);                                   // Retrieve video 
  filter(GRAY);                                       // Filter video to grayscale for easier visualization
  
  dateAndRound();                                     // Post date and round number in top right
  
  // Randomized data
  airSpeed = random(13.5,14.5);                       // Get these from a transducer
  altitude = random(30,34);                           // Get these from a transducer
  gyroRoll = 0;                                       // Get these from a transducer
  gyroPitch = 0;                                      // Get these from a transducer
  
  // Calcs                                             
  dropTime = sqrt((2*altitude)/9.81);
  distance = dropTime * airSpeed;
  xCorrection = (cos(gyroRoll))*scale;
  yCorrection = (cos(gyroPitch) + distance)*scale;
    
  // Displaying of values to top left of screen (toggle with t or T) 
  if (toggle == true) {
  textSize(13);                                       // Post and format serial values to screen
  text("Arduino voltage (V): "+val,10,20); 
  text("Altitude (m): "+String.format("%.2f",altitude),10,40);              // Needs to be feet for competition
  text("Air speed (m/s): "+String.format("%.2f",airSpeed),10,60);
  text("Horizontal drop distance (m): "+String.format("%.2f",distance),10,80);  
  fill(150,250,50);  
  }
    
  crossHair();                                        // Generate crosshairs for targetting 
   
  image(img, width-50, height-50, 40, 40);            // Place Aero logo in bottom right hand corner 
  
  if (dropping == false) {   
    pushStyle(); 
    textAlign(CENTER);
    fill(255,255,255);
    text("payload armed",width/2,height-20);
    popStyle();
  } else {
    pushStyle(); 
    textAlign(CENTER);
    fill(255,255,255);
    text("payload released",width/2,height-20);
    popStyle();
  }
     
  recordToggle();                                        // toggle recording with r or R key
}

//////////////////////////////////////////
// Functions
//////////////////////////////////////////

void captureEvent(Capture video) {                      // Most effcient way to get frames for video
  video.read();
}
       
               
void keyPressed() {                                     // Keyboard toggle recording (r or R) and drop payload (space bar) and (t or T) for on screen data
  if (key == 'r' || key == 'R') {
    recording = !recording;
  }
  if (key == ' ') {
  
    fill(255,255,255);
    stroke(255);
    rect(width/2 - 70,height - 30,140,20);
     
    pushStyle(); 
    textAlign(CENTER);
    fill(0);
    text("payload released",width/2,height-15);
    popStyle();
       
  saveFrame("Drop.png");
  dropping = !dropping;
  }
  if (key == 't' || key == 'T') {
    toggle = !toggle;
  }
}


void crossHair() {                                      // Generates crosshair for targeting
  stroke(150,250,50);   
  strokeWeight(3);
  
  line(width/2+10+xCorrection,height/2+10-yCorrection,width/2+30+xCorrection,height/2+30-yCorrection);
  line(width/2-10+xCorrection,height/2+10-yCorrection,width/2-30+xCorrection,height/2+30-yCorrection);
  
  line(width/2+10+xCorrection,height/2-10-yCorrection,width/2+30+xCorrection,height/2-30-yCorrection);
  line(width/2-10+xCorrection,height/2-10-yCorrection,width/2-30+xCorrection,height/2-30-yCorrection);
  
  ellipse(width/2+xCorrection,height/2-yCorrection,3,3);
}


void recordToggle() {                                  // Toggle recording on/off 
  if (recording) {                                     
    saveFrame("output/flight_###.jpg");                // .jpg appears to be best quality for file size 
    pushStyle();                                       // Create red recording dot it bottom left
    fill(255, 0, 0);
    strokeWeight(0);
    ellipse(20, height-20, 10, 10); 
    popStyle();
  } else {                                             // Not recording, white dot in bottom left 
    pushStyle(); 
    fill(255, 255, 255);
    strokeWeight(0);
    ellipse(20, height-20, 10, 10); 
    popStyle(); 
  }
}


void dateAndRound() {
    pushStyle(); 
    textAlign(RIGHT);
    fill(255,255,255);
    text(dd+"/"+mmm+"/"+yyyy,width-20,20);
    text("Round: "+round,width-20,40);
    popStyle();
}

void serialEvent(Serial myPort) {                        // Connection with Arduino 

val = myPort.readStringUntil('\n');                      // Read values 

if (val != null) {                                       // Check and format data/values
  val = trim(val);
  println(val);

  if (firstContact == false) {                           // Check for A (are we connected?)
    if (val.equals("A")) {
      myPort.clear();
      firstContact = true;                               // Start sending data, connection is made (1 for 1 exchange)
      myPort.write("A");
      println("contact");
    }
  }
  
  else {                                                 // Once connected, do this 
    println(val);
    
    if (dropping == true) {                              // Send 1 back to arduino (servo activated) and take screen shot when dropping
      myPort.write('1');        
      println("1");
      dropping = !dropping;                              // Change to false so we dont access this "if" statment again
    }

    myPort.write("A");                                   // Send A to get more data (1 for 1 exchange)
    }
  }
}
