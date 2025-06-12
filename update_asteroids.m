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
