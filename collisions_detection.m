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








