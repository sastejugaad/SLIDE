#include <AccelStepper.h>
#include <MultiStepper.h>

// Define the number of steps per revolution for your stepper motors
#define STEPS_PER_REVOLUTION 3200 // 200 steps/rev * 16 (1/16th microstepping)

// Define the pins for each stepper motor
#define MOTOR1_STEP_PIN 2
#define MOTOR1_DIR_PIN 5
#define MOTOR2_STEP_PIN 3
#define MOTOR2_DIR_PIN 6
#define MOTOR3_STEP_PIN 4
#define MOTOR3_DIR_PIN 7
#define MOTOR4_STEP_PIN 12
#define MOTOR4_DIR_PIN 13

// Define the maximum speed and acceleration for the stepper motors
#define MAX_SPEED 2000
#define ACCELERATION 500

// Create instances of AccelStepper for each motor
AccelStepper stepperX(AccelStepper::DRIVER, MOTOR1_STEP_PIN, MOTOR1_DIR_PIN);
AccelStepper stepperY(AccelStepper::DRIVER, MOTOR2_STEP_PIN, MOTOR2_DIR_PIN);
AccelStepper stepperZ(AccelStepper::DRIVER, MOTOR3_STEP_PIN, MOTOR3_DIR_PIN);
AccelStepper stepperA(AccelStepper::DRIVER, MOTOR4_STEP_PIN, MOTOR4_DIR_PIN);

void setup() {
  // Set up the serial connection for communication with the PC
  Serial.begin(115200);

  // Set up each stepper motor with max speed and acceleration
  stepperX.setMaxSpeed(MAX_SPEED);
  stepperX.setAcceleration(ACCELERATION);

  stepperY.setMaxSpeed(MAX_SPEED);
  stepperY.setAcceleration(ACCELERATION);

  stepperZ.setMaxSpeed(MAX_SPEED);
  stepperZ.setAcceleration(ACCELERATION);

  stepperA.setMaxSpeed(MAX_SPEED);
  stepperA.setAcceleration(ACCELERATION);
}

void loop() {
  // Check if data is available on the serial port
  if (Serial.available() > 0) {
    // Read the CSV values
    String input = Serial.readStringUntil('\n');
    int values[4];
    int i = 0;
    char *ptr = strtok((char *)input.c_str(), ",");
    while (ptr != NULL) {
      values[i++] = atoi(ptr);
      ptr = strtok(NULL, ",");
    }

    // Control the robot using the joystick values
    int leftX = values[0];
    int leftY = values[1];
    int rightX = values[2];
    int rightY = values[3];

    // Calculate motor speeds based on joystick values
    int motorXSpeed = leftX - rightX;
    int motorYSpeed = leftY - rightX;
    int motorZSpeed = -leftX - rightX;
    int motorASpeed = -leftY - rightX;

    // Set motor speeds
    stepperX.setSpeed(motorXSpeed);
    stepperY.setSpeed(motorYSpeed);
    stepperZ.setSpeed(motorZSpeed);
    stepperA.setSpeed(motorASpeed);
  }

  // Move each motor
  stepperX.runSpeed();
  stepperY.runSpeed();
  stepperZ.runSpeed();
  stepperA.runSpeed();
}
