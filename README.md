# Aero_HLG_2018_DAS

Wrote program for advanced class requirements for the SAE Aero Design 2018 competition (https://www.saeaerodesign.com). Goal was to record FPV flight while displaying various flight information and accurately drop a payload(s). The Processing video library did not support our FPV camera so program was not used at competition but works otherwise with different cameras (can still use a little cleaning up).

## Use

*Recording on/off toggle (use r or R)
*Information toggle on/off screen (t or T)
*Dropping toggle, activate servo and take screenshot (space bar)


## Prerequisites

Add "video library" in Processing

```
Sketch --> Import Library --> Add Library --> Video (from The Processing Foundation)
```

Ensure camera and serial port are correct by using commands to display available options

```
printArray(Capture.list());                       // Use this to see list of available cameras
printArray(Serial.list());                        // Use this to see list of available serial ports
```

And update the array here (currently set to 1)

```
String portName = Serial.list()[1]; 
video = new Capture(this,Capture.list()[1]);
```

Lastly, ensure folder have all required files and folders (AeroLogo.png and /output folder - clear if required)


## Installing

Upload sketch to arduino run .pde file 



## Built With

* [Processing](https://processing.org/download/) - Visual processing of data
* [Arduino IDE](https://www.arduino.cc/en/Main/Software) - Data acquisition



## Authors

* **Mark Sherstan** - *Initial work* - [MarkSherstan](https://github.com/MarkSherstan)


## Acknowledgments

The Coding Train
