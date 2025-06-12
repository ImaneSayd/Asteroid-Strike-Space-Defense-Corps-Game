% Initializing variables
best = 0; % (or some initial high score)
SpaceShip.Alpha = 1;  % Initializing SpaceShip struct with an Alpha field
asteroids.Alpha = 1;  % Initializing asteroids struct with an Alpha field
bullets.Alpha = 1;    % Initializing bullet struct
background.Alpha = 1; % Background struct

% Saving the variables to info.mat
save('info.mat','best','SpaceShip','asteroids','bullets','background');