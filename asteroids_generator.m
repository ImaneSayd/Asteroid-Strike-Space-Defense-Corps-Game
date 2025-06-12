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
