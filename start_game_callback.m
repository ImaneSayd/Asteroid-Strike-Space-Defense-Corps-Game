function start_game_callback(~, ~)
    global GSTATE;

    GSTATE.isRunning = true;
    GSTATE.score = 0;
    GSTATE.lives = 3;
    GSTATE.level = 1;
    set(GSTATE.score_text, 'String', '0');
    set(GSTATE.lives_text, 'String', '3');

    GSTATE.bullets = [];
    GSTATE.asteroids = asteroids_generator(GSTATE.level, ...
        GSTATE.difficulty_menu.Value);

    gameplay_engine();  % Starts the game loop
end
