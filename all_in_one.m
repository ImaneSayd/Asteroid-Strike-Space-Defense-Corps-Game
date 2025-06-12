function main_script()
    % Asteroid Strike Main
    close all; clc;
    warning('off');

    global GSTATE;
    GSTATE = game_state_initialization();

    create_gui();  % Launching the GUI

    uiwait(GSTATE.fig);  % Waiting for game window to close
end

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

% Initializing variables
best = 0; % (or some initial high score)
SpaceShip.Alpha = 1;  % Initializing SpaceShip struct with an Alpha field
asteroids.Alpha = 1;  % Initializing asteroids struct with an Alpha field
bullets.Alpha = 1;    % Initializing bullet struct
background.Alpha = 1; % Background struct

% Saving the variables to info.mat
save('info.mat','best','SpaceShip','asteroids','bullets','background');

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

function h = create_label(text_str, x, y)
    h = uicontrol('Style', 'text', 'String', text_str, ...
        'Position', [x y 60 30], ...
        'BackgroundColor', [0 0 0], ...
        'ForegroundColor', [1 1 1]);
end

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

function fire_callback(~, ~)
    global GSTATE;

    if GSTATE.isRunning
        x = GSTATE.SpaceShip.x + GSTATE.SpaceShip.width / 2;
        y = GSTATE.SpaceShip.y;
        GSTATE.bullets = [GSTATE.bullets; x, y];
        draw_state();
    end
end

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

function difficulty_callback(src, ~)
    global GSTATE;
    GSTATE.level = src.Value;
end

function close_game_callback(~, ~)
    global GSTATE;

    if GSTATE.score > GSTATE.best
        best = GSTATE.score;
        save('info.mat', 'best');
    end

    delete(GSTATE.fig);
end

function asteroids = asteroids_generator(level, difficulty)
    num_asteroids = 5 + 3 * level;
    base_speed = [2, 5, 8]; % It will be faster for higher difficulty
    asteroids = zeros(num_asteroids, 4);
    labels = {};
    syms t;

    for i = 1:num_asteroids
        x = randi([0, 800]);
        y = randi([50, 150]);
        vy = base_speed(difficulty) + randi([0, 2]);
        switch difficulty
            case 1, vx = 0;
            case 2, vx = 20 * sin(i);  % medium --> more vx
            case 3, vx = 40 * sin(i * pi/4); % hard --> even more vx
        end
        asteroids(i,:) = [x, y, vx, vy];
        labels{end+1} = strcat('Ast#', num2str(i), ['' ...
            ' @('], num2str(x), ',', num2str(y), ')');
        y_traj = y + vy * t;
        x_traj = x + vx * t;
        v_y = diff(y_traj, t);
        v_x = diff(x_traj, t);
        a_y = diff(v_y, t);
        a_x = diff(v_x, t);
        t_hit = solve(y_traj == 100, t);
        disp(['Ast ', num2str(i), ' hits y=100 at t=', char(t_hit)]);
        d_y = int(v_y, t, 0, 10);
        disp(['Ast ', num2str(i), ' moves ', char(d_y), ...
            ' units vertically in 10s.']);
    end

    disp(['Asteroid matrix size: ', mat2str(size(asteroids))]);
    v_poly = poly(asteroids(:,3));
    disp('Poly fit for vx:'); disp(v_poly);

    fig = figure('Visible','on')
    plot3(asteroids(:,1), asteroids(:,2), asteroids(:,3), ...
        'ro', 'MarkerFaceColor','r');
    title('Asteroids: X, Y, VX'); xlabel('X'); ylabel('Y'); zlabel('VX');
    grid on;
    legend('Asteroids (X, Y, VX)', 'Location', 'best');
    file3D = sprintf('Asteroids_3Dplot%d.jpg', level);
    saveas(fig, file3D);
    close(fig);
end

% Simulating the game loop + Controlling asteroids moves
function gameplay_engine()
% Main loop
global GSTATE;

filename = 'game_progress.xlsx';
if exist(filename, 'file')
    delete(filename);
end

progress = [];

while GSTATE.isRunning && GSTATE.lives > 0 && ishandle(GSTATE.fig)
    % Moving asteroids (they bounce back if they hit the edges)
    GSTATE.asteroids=update_asteroids(GSTATE.asteroids, ...
        GSTATE.resolution(1));

    % Moving bullets
    if ~isempty(GSTATE.bullets)
        GSTATE.bullets(:,2) = GSTATE.bullets(:,2) - 10;
    end

    % Collisions detection
    [GSTATE.asteroids, GSTATE.bullets, hits] = collisions_detection( ...
        GSTATE.asteroids, GSTATE.bullets);
    GSTATE.score = GSTATE.score + hits;
    set(GSTATE.score_text, 'String', num2str(GSTATE.score));

    if isempty(progress) || progress(end,2) ~= GSTATE.score
    progress = [progress; GSTATE.level, GSTATE.score];
end

    % Checking if asteroids reach the bottom
    if any(GSTATE.asteroids(:,2) > 600)
        GSTATE.lives = GSTATE.lives - 1;
        set(GSTATE.lives_text, 'String', num2str(GSTATE.lives));
        % Remove asteroids that reached the bottom
        GSTATE.asteroids = GSTATE.asteroids(GSTATE.asteroids(:,2)<=600,:);

        if GSTATE.lives == 0
            break; % Immediately exitting the loop if no lives
        end
    end

    % Respawning asteroids if all of them got destroyed
    if isempty(GSTATE.asteroids)
        GSTATE.level = GSTATE.level + 1;
        GSTATE.asteroids = asteroids_generator(GSTATE.level, ...
            GSTATE.difficulty_menu.Value);
    end

    draw_state();
    pause(0.05);
end

% Save to Excel
xlswrite(filename, progress);

% Plot
figure;
plot(progress(:,1), progress(:,2), '-o', 'LineWidth', 2);
title('Score Progression Over Levels');
xlabel('Level');
ylabel('Score');
legend('Score');
grid on;
saveas(gcf, 'score_progression.jpg');

GSTATE.isRunning = false;
if GSTATE.lives == 0
    msgbox(sprintf('Game Over!\nScore: %d', GSTATE.score), 'Game Over');
end
end

function asteroids = update_asteroids(asteroids, screen_width)
    for i = 1:size(asteroids, 1)
        asteroids(i,1) = asteroids(i,1) + asteroids(i,3);
        asteroids(i,2) = asteroids(i,2) + asteroids(i,4);

        if asteroids(i,1) <= 0 || asteroids(i,1) >= screen_width
            % Asteroids bounce when they touch the edges
            asteroids(i,3) = -asteroids(i,3); 
            asteroids(i,1) = max(min(asteroids(i,1), screen_width), 0);
        end
    end
end

function[asteroids, bullets, hits]=collisions_detection(asteroids,bullets)
    % Detecting collisions between bullets and asteroids
    hits = 0;
    remove_asteroids = [];
    remove_bullets = [];

    for i = 1:size(bullets,1)
        for j = 1:size(asteroids,1)
            dx = abs(bullets(i,1) - asteroids(j,1));
            dy = abs(bullets(i,2) - asteroids(j,2));

            if dx < 20 && dy < 20
                remove_asteroids = [remove_asteroids; j];
                remove_bullets = [remove_bullets; i];
                hits = hits + 1;
                break;
            end
        end
    end

    asteroids(unique(remove_asteroids),:) = [];
    bullets(unique(remove_bullets),:) = [];
end

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
