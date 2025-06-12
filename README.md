# Asteroid-Strike-Space-Defense-Corps-Game

# GROUP MEMBERS AND THEIR CONTRIBUTIONS :

• Imane Sayd: Core and Logic of the Game


• Rim Jemmari: GUI of the Game


## Explanation of the Problem
The objective is to develop an interactive MATLAB-based game, user-friendly Asteroid Strike Game, where the player control a defense spaceship to intercept and destroy incoming asteroids using bullets. Inspired by the popular space invaders game, it incorporates varying difficulty levels, real-time GUI interactions, and tracks player performance across the levels.


## Definitions of the Variables Used in the Problem

### GSTATE Structure Variables
•  GSTATE: a global structure encapsulating the game's current state, including score, lives, level, asteroids, bullets, and GUI components.
•  GSTATE.resolution: a 1 by 2 vector that specifies the width and height of the game window in pixels (default is [800, [600]]).
•  GSTATE.score: current score of the player which increases whenever asteroids are hit.
•  GSTATE.best: the highest achieved score in the previous levels which is loaded from a file called info.mat.
•  GSTATE.lives: default is 3 and the game ends when it reaches 0.
•  GSTATE.level: current level of the game which increases whenever the player clears out every asteroid of the session.
•  GSTATE.isRunning: a boolean flag that indicates if the game is active currently (true), or stopped/paused (false).
•  GSTATE.asteroids: an N by 4 matrix where each row represents an asteroid with 4 columns: 
	Column 1: x position
	Column 2: y position
	Column 3: vx (velocity in the x-direction)
	Column 4: vy (velocity in the y-direction)
•  GSTATE.bullets: an M by 2 matrix where each row represents a bullet with columns for x and y positions.
•  GSTATE.SpaceShip: a structure describing the player’s SpaceShip with the following fields:
	x: x position
	y: y position
	width: the width of the SpaceShip
	height: the height of the SpaceShip 


### Other Variables/Parameters
•  best: a variable that holds the highest score which is saved to or loaded from info.mat.
•  SapceShip.Alpha, asteroids.Alpha, bullets.Alpha, background.Alpha:  Alpha (transparency) values for graphical elements, that is set to 1 (which means fully opaque) in the initialization part.
•  base_speed: an array representing the base vertical speed of the asteroids depending on the difficulty chosen (Easy, Medium, Hard).
•  difficulty: an integer indicating the selected difficulty level (1: Easy, 2: Medium, 3: Hard) which affects the asteroid speed and movement.
•  num_asteroids: number of asteroids generated per level, it is calculated based on this formula: 5+3*level.
•  vx, vy: horizontal and vertical velocities assigned to each asteroid (is determined by a combination of difficulty and randomization)
•  progress: a matrix to track the player’s progress with each row containing [level, score] for each update of the game.


### GUI and Display Variables
•  GSTATE.fig: a handle to the main game window (figure).
•  GSTATE.ax: a handle to the axes used for drawing game elements.
•  GSTATE.score_text, GSTATE.best_text, GSTATE.lives_text: handles to text labels displaying score, best score and lives in the GUI. 
•  GSTATE.difficulty_menu: a handle to the dropdown menu for difficulty selection (Easy, Medium, Hard).


## Descriptions of the Tasks that Need to be Performed to Solve the Problem
•  Game State Initialization: Setting up initial game parameters (score, best score, level and game status) - defining the position and size of the player’s SpaceShip - load any saved high scores – initializing arrays for asteroids and bullets.
•  Creating GUI: building the main game window and axes for drawing – adding buttons for starting, firing and quitting the game – displaying current score, best score and lives as labels – providing a dropdown menu for selecting the difficulty – ensuring that all the GUI elements are positioned and styled appropriately.
•  Generating Asteroids: calculating the number of asteroids based on the level – randomly assigning positions and velocities to each asteroid – adjusting the asteroids’ speed and movement according to the chosen difficulty.
•  Handling User Input: capturing keyboard inputs to move the spaceship and firing bullets.
•  Executing the Game Loop: moving asteroids and bullets according to their velocities – detecting and handling collisions between bullets and asteroids – updating the score and removing the destroyed asteroids and bullets – checking if any asteroids have reached the bottom of the screen which will result in reducing the player’s lives – advancing to the next level when all asteroids are cleared – pausing briefly between the updates to control the game speed. 
•  Detecting Collisions: for each bullet, checking if it is within a certain distance of any asteroid – if a collision is detected, both the bullet and asteroid must be removed and the score must increment.
•  Data Logging: tracking and recording game progress and saving it to an Excel file for analysis.
•  Handling Game Over: showing a message box with the final score – saving the score if it is new high one – cleaning up and closing the game window.


## The Calculations Required to Solve Each Task of the Problem
•  Asteroid Generation: each asteroid’s initial position (x,y) is randomly generated within specified ranges – each asteroid is assigned vertical (vy) and horizontal (vx) velocities based on the difficulty selection – the future position of each asteroid is determined using linear motion equations.
•  Asteroid Movement: updating the position of each asteroid, at each time step, using its velocity. If an asteroid reaches the screen edge, its horizontal velocity is reversed (bouncing).
•  Bullets Movement: moving bullets upward by decreasing their y-coordinate at a fixed rate every loop iteration.
•  Collisions Detection: For each bullet and asteroid pair, the horizontal (dx) and vertical (dy) distances are calculated. If both dx and dy are less than a certain threshold (20 units), a collision is detected and both objects are removed.
• Score Update: incrementing score upon successful asteroid destruction.
• Level Advancement: increasing the level when all asteroids are destroyed, then new asteroids are generated.
•  Lives Management: Decreasing lives if an asteroid reaches the bottom of the screen.
•  End Game : the game ends when the player’s lives reach 0.


## Some of the Equations Used to Solve the Problem
•  Asteroid Position Update:
•	xnew = xold + vx 
•	ynew = yold + vy
•  Bullet Position Update:
•	ybullet,new = ybullet,old − vbullet         (where vbullet is the fixed speed of the bullet)
•  Asteroid Bounce:
•	Horizontally: if xnew <= 0 or xnew >= screen_width, vx = -vx
•  Collision Detection:
•	If dx < dthreshold and dy < dthreshold, collison occures 
 (where dx = abs(xbullet – xatseroid) and dy = abs(ybullet – yasteroid)) 
•  Asteroid Trajectory:
•	Linear: x(t) = x0 + vx * t ; y(t) = y0 + vy * t


## Structure Chart of the Program
![image](https://github.com/user-attachments/assets/df15205c-2d58-4be6-aade-6b61b36412e7)


## Flow Chart of the Program
![image](https://github.com/user-attachments/assets/a1083bd2-fb0c-4899-9b20-bceb99727551)


## How the GUI and the Related Matlab Codes Work
The GUI was developed in Matlab to visually control and interact with the game using buttons and keyboard inputs. It includes Start, Fire, and Quit buttons, as well as dropdowns and display labels for score, lives, and difficulty. When the Start button is clicked, the game initializes and asteroids begin to fall. Players can fire bullets using the Fire button or Spacebar and move the spaceship left or right with the arrow keys. Each component of the GUI is linked to a separate .m function that manages its behavior. The GUI updates in real time using draw_state.m, and all elements are kept interactive and responsive using callbacks.


## Figures Produced when Running the Matlab Files (Example Demonstration)
![image](https://github.com/user-attachments/assets/28922b88-5078-4367-af96-54046b6b2b7e)


![image](https://github.com/user-attachments/assets/3a64a0b4-370e-4f77-afc9-ce0f4ad5e088)


![image](https://github.com/user-attachments/assets/4febb8aa-6331-417d-8ef2-c83c146b0717)


![image](https://github.com/user-attachments/assets/4dfa7ddb-43d6-4e6c-a1ae-92e7c44b6fa9)


















