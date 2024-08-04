import processing.serial.*;

Serial port; // Serial port object

int leftBoundaryX, leftBoundaryY; // Position of the left boundary
int rightBoundaryX, rightBoundaryY; // Position of the right boundary
int boundarySize = 200; // Size of the boundary circle
int leftStickX, leftStickY; // Position of the left stick
int rightStickX, rightStickY; // Position of the right stick
int stickSize = 30; // Size of the sticks
int stickRadius = stickSize / 2; // Radius of the sticks

void setup() {
  size(600, 400);
  leftBoundaryX = width / 4;
  leftBoundaryY = height / 2;
  rightBoundaryX = width * 3 / 4;
  rightBoundaryY = height / 2;
  leftStickX = leftBoundaryX;
  leftStickY = leftBoundaryY;
  rightStickX = rightBoundaryX;
  rightStickY = rightBoundaryY;

  // Initialize serial communication
  port = new Serial(this, Serial.list()[0], 115200);
}

void draw() {
  background(255);
  
  // Draw left boundary
  noFill();
  stroke(0);
  ellipse(leftBoundaryX, leftBoundaryY, boundarySize, boundarySize);
  
  // Draw right boundary
  ellipse(rightBoundaryX, rightBoundaryY, boundarySize, boundarySize);
  
  // Draw X and Y axis lines for left boundary
  stroke(150);
  line(leftBoundaryX, leftBoundaryY - boundarySize / 2, leftBoundaryX, leftBoundaryY + boundarySize / 2); // Y axis
  line(leftBoundaryX - boundarySize / 2, leftBoundaryY, leftBoundaryX + boundarySize / 2, leftBoundaryY); // X axis
  
  // Draw X and Y axis lines for right boundary
  line(rightBoundaryX, rightBoundaryY - boundarySize / 2, rightBoundaryX, rightBoundaryY + boundarySize / 2); // Y axis
  line(rightBoundaryX - boundarySize / 2, rightBoundaryY, rightBoundaryX + boundarySize / 2, rightBoundaryY); // X axis
  
  // Draw left stick
  fill(255, 0, 0);
  ellipse(leftStickX, leftStickY, stickSize, stickSize);
  
  // Draw right stick
  fill(0, 0, 255);
  ellipse(rightStickX, rightStickY, stickSize, stickSize);
  
  // Calculate and display values
  int leftXAxis = int(map(leftStickX, leftBoundaryX - boundarySize / 2, leftBoundaryX + boundarySize / 2, -2000, 2000));
  int leftYAxis = int(map(leftStickY, leftBoundaryY - boundarySize / 2, leftBoundaryY + boundarySize / 2, 2000, -2000));
  int rightXAxis = int(map(rightStickX, rightBoundaryX - boundarySize / 2, rightBoundaryX + boundarySize / 2, -2000, 2000));
  int rightYAxis = int(map(rightStickY, rightBoundaryY - boundarySize / 2, rightBoundaryY + boundarySize / 2, 2000, -2000));
  
  // Send values to Arduino in CSV format
  String leftValues = leftXAxis + "," + leftYAxis;
  String rightValues = rightXAxis + "," + rightYAxis;
  String csvData = leftValues + "," + rightValues + "\n";
  port.write(csvData);
  
  // Display values being sent in the console
  println("Joystick values sent: " + csvData);
}

void mouseDragged() {
  // Check if the mouse is dragging the left stick
  if (dist(mouseX, mouseY, leftBoundaryX, leftBoundaryY) < boundarySize / 2 - stickRadius) {
    leftStickX = mouseX;
    leftStickY = mouseY;
  }
  
  // Check if the mouse is dragging the right stick
  if (dist(mouseX, mouseY, rightBoundaryX, rightBoundaryY) < boundarySize / 2 - stickRadius) {
    rightStickX = mouseX;
    rightStickY = mouseY;
  }
}

void mouseReleased() {
  // Reset left stick position
  leftStickX = leftBoundaryX;
  leftStickY = leftBoundaryY;
  
  // Reset right stick position
  rightStickX = rightBoundaryX;
  rightStickY = rightBoundaryY;
}
