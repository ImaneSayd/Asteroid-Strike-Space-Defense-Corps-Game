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