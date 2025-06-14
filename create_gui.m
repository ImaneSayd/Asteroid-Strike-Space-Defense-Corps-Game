function create_gui()
    global GSTATE;

    GSTATE.fig = figure('Name', 'Asteroid Strike: Space Defense Corps', ...
        'NumberTitle', 'off', ...
        'MenuBar', 'none', ...
        'Color', [0 0 0], ...
        'Position', [300 100 GSTATE.resolution], ...
        'KeyPressFcn', @key_press_callback, ...
        'CloseRequestFcn', @close_game_callback);

    GSTATE.ax = axes('Parent', GSTATE.fig, ...
        'Units', 'pixels', ...
        'Position', [50 50 700 500], ...
        'XLim', [0 GSTATE.resolution(1)], ...
        'YLim', [0 GSTATE.resolution(2)], ...
        'YDir', 'reverse', ...
        'Color', [0 0 0], ...
        'XTick', [], 'YTick', []);
    title('Asteroid Strike: Space Defense Corps');
    xlabel('X'); ylabel('Y'); grid on;

    % Buttons
    uicontrol('Style', 'pushbutton', 'String', 'Start', ...
        'Position', [50 570 80 30], 'Callback', @start_game_callback);
    uicontrol('Style', 'pushbutton', 'String', 'Fire', ...
        'Position', [150 570 80 30], 'Callback', @fire_callback);
    uicontrol('Style', 'pushbutton', 'String', 'Quit', ...
        'Position', [250 570 80 30], 'Callback', @close_game_callback);

    % Score and status text
    create_label('Score:', 400, 570);
    GSTATE.score_text = create_label('0', 460, 570);

    create_label('Best:', 540, 570);
    GSTATE.best_text = create_label(num2str(GSTATE.best), 600, 570);

    create_label('Lives:', 680, 570);
    GSTATE.lives_text = create_label(num2str(GSTATE.lives), 740, 570);

    % Difficulty
    create_label('Difficulty:', 50, 20);
    GSTATE.difficulty_menu = uicontrol('Style', 'popupmenu', ...
        'String', {'Easy', 'Medium', 'Hard'}, ...
        'Position', [140 20 100 20], 'Callback', @difficulty_callback);

    draw_state();  % Draw first frame
end

