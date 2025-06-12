function key_press_callback(~, event)
    global GSTATE;

    if ~GSTATE.isRunning
        return;
    end

    switch event.Key
        case 'leftarrow'
            GSTATE.SpaceShip.x = max(GSTATE.SpaceShip.x - 20, 0);
        case 'rightarrow'
            GSTATE.SpaceShip.x = min(GSTATE.SpaceShip.x + 20, ...
                GSTATE.resolution(1) - GSTATE.SpaceShip.width);
        case 'space'
            fire_callback();
    end

    draw_state();
end
