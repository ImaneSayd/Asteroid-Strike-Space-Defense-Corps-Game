function fire_callback(~, ~)
    global GSTATE;

    if GSTATE.isRunning
        x = GSTATE.SpaceShip.x + GSTATE.SpaceShip.width / 2;
        y = GSTATE.SpaceShip.y;
        GSTATE.bullets = [GSTATE.bullets; x, y];
        draw_state();
    end
end
