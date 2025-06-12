function close_game_callback(~, ~)
    global GSTATE;

    if GSTATE.score > GSTATE.best
        best = GSTATE.score;
        save('info.mat', 'best');
    end

    delete(GSTATE.fig);
end
