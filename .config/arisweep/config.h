#pragma once

// Delay between pressing a movement key and cursor movement
#define MOUSEKEY_DELAY 10 

// Time between cursor movements in milliseconds
#define MOUSEKEY_INTERVAL 20

// Step size
#define MOUSEKEY_MOVE_DELTA	8

// Maximum cursor speed at which acceleration stops
#define MOUSEKEY_MAX_SPEED	8

// Time until max speed is reached
#define MOUSEKEY_TIME_TO_MAX 30

// Delay between pressing a wheel key and wheel movement
#define MOUSEKEY_WHEEL_DELAY 10	

// Time between wheel movements
#define MOUSEKEY_WHEEL_INTERVAL	80	

// Wheel movement step size
#define MOUSEKEY_WHEEL_DELTA 1	

// Maximum number of scroll steps per scroll action
#define MOUSEKEY_WHEEL_MAX_SPEED 3	

// Time until maximum scroll speed is reached
#define MOUSEKEY_WHEEL_TIME_TO_MAX	40	

#define TAPPING_TERM 175
#define CHORDAL_HOLD
