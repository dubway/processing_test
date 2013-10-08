//Just adding this line of code here!


//--------------------------------------------------------- Serial
import processing.serial.*;
Serial myPort;        // The serial port
int xPos = 1;         // horizontal positirron of the graph

//--------------------------------------------------------- Physics
PVector pos;     // ship's position
PVector speed;   // ship's speed
PVector accel;   // ship's acceleration
float angle;

PShape boat;     //SVG


int cols = 2;
int rows = 100;
float[][] trail = new float[cols][rows];

void setup() {
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');

  size(1280, 720);
  noStroke();
  boat = loadShape("boat001.svg");

  pos = new PVector(width/2, height/2, 0);
  speed = new PVector();
  accel = new PVector();

  // just to clear my array
  for (int i = 0; i<rows; i++) {
    trail[0][i] = 0;
    trail[1][i] = 0;
  }
}

void draw() {
  // check for input
  background(150, 230, 255);


  speed.add(accel);
  pos.add(speed);

  drawBoat();
  update();

  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    float inByte = float(inString); 
    
    //println(inByte);

    if (inByte != 0.0) {
      accelerate(0.5);
      //println("ok");
    }
  }

}

void keyPressed() {

  if (key == 'l') {
    angle-=0.1;
  }
  if (key == 'r') {
    angle+=0.1;
  }
}

void drawBoat() {
  
   //Draw my trail
  for (int i = 0; i<rows-1; i++) {
    trail[0][i] = trail[0][i+1];
    trail[1][i] = trail[1][i+1];


    fill(255, 255, 255, 50);
    ellipse(trail[0][i]+random(0, 4), trail[1][i]-random(0, 4), 2, 2);

    fill(255, 255, 255, 50);
    ellipse(trail[0][i]-random(7, 11), trail[1][i]+random(7, 11), 2, 2);

    fill(255, 255, 255, 50);
    ellipse(trail[0][i]+random(7, 11), trail[1][i]-random(7, 11), 2, 2);

    fill(255, 255, 255, 50);
    ellipse(trail[0][i]-5, trail[1][i]-random(7, 11), 2, 2);
  }

  trail[0][rows-1] = pos.x + accel.x;
  trail[1][rows-1] = pos.y + accel.y;

  //Draw my boat
  pushMatrix();

  translate(pos.x, pos.y);
  rotate(angle);
  shape(boat, -25, -53, 50, 40);

  popMatrix();
  
}

void update() {
  accel.set(0, 0, 0);
  if (speed.mag() != 0) {
    speed.mult(0.99);
  }
}

void accelerate(float a) {
  float totalAccel = a;
  accel.x = totalAccel * sin(angle);
  accel.y = -totalAccel * cos(angle);
}

