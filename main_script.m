function main_script()
    % Asteroid Strike Main
    close all; clc;
    warning('off');

    global GSTATE;
    GSTATE = game_state_initialization();

    create_gui();  % Launching the GUI

    uiwait(GSTATE.fig);  % Waiting for game window to close
end