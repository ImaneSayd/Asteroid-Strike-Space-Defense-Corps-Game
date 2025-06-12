function draw_state()
    global GSTATE;
    if ~ishandle(GSTATE.ax)
        return;
    end
    axes(GSTATE.ax);
    cla;
    hold on;

    % Drawing SpaceShip
    rectangle('Position', [GSTATE.SpaceShip.x, GSTATE.SpaceShip.y, ...
        GSTATE.SpaceShip.width, GSTATE.SpaceShip.height], ...
        'FaceColor', 'cyan');

    % Drawing asteroids
    if ~isempty(GSTATE.asteroids)
        scatter(GSTATE.asteroids(:,1), GSTATE.asteroids(:,2), 50, ...
            'red', 'filled');
    end

    % Drawing bullets
    if ~isempty(GSTATE.bullets)
        scatter(GSTATE.bullets(:,1), GSTATE.bullets(:,2), 20, ...
            'yellow', 'filled');
    end

    hold off;
end