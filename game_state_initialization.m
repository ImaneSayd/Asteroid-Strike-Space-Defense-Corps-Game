function GSTATE = game_state_initialization()

    GSTATE = struct();
    GSTATE.resolution = [800, 600];
    GSTATE.score = 0;
    GSTATE.best = 0;
    GSTATE.lives = 3;
    GSTATE.level = 1;
    GSTATE.isRunning = false;
    GSTATE.asteroids = [];
    GSTATE.bullets = [];
    GSTATE.SpaceShip = struct('x', 400, 'y', 550, 'width', 50, 'height', 20);

    % Loading high score if available
    if isfile('info.mat')
        try
            s = load('info.mat', 'best','background', 'bullets', 'asteroids', 'SpaceShip');
            if isfield(s, 'best')
                GSTATE.best = s.best;
            end
        catch
            GSTATE.best = 0;
        end
    end
end