function [] = circ_pot()
    grid = 50;
    % define a line of points with x spacing 7 along y = x+1
    % redefine this to test different lidar data!
    Z = zeros(grid*2+1,grid*2+1);
    x_pts = -20:7:20;
    y_pts = x_pts+1;
    % define extra x-y pairs like so
    x_pts = [x_pts 30 20];
    y_pts = [y_pts 35 -30];
    % calculate potentials
    for i = 1:size(x_pts, 2)
        Z = blit_pot(Z, size(Z), [x_pts(i)+grid+1,y_pts(i)+grid+1], 4, 10);
    end
    % plotting
    [x,y] = meshgrid(-grid:grid, -grid:grid);
    surf(x,y,Z);
    % comment this line 
    axis square;
    % uncomment to force top down view
    %view(2);
end

% Blit in ciclcular potentials around the coordiante center.
% Normalized/clamped to have 1 correspond to the maximum potential
% @param Z potential array
% @param z_size coordinate pair containing the size of each axis of z
% @param center coordinate pair of the center
% @param r_center radius of max potential around the center
% @param r_max maximum radius of the area of effect of this potential
function [Z] = blit_pot(Z, z_size, center, r_center, r_max)
    MAX_POT = 1;
    % matlab arrays start at 1 and indexed using (). VERY STUPID
    % this turns out to be actually pretty good for cache... except for all
    % the extra accesses
    for y = (center(2)-r_max):(center(2)+r_max)
       % bounds check
       if(y > z_size(2) || y < 0)
           continue;
       end
       for x = (center(1)-r_max):(center(1)+r_max)
           % bounds check
           if(x > z_size(1) || x < 0)
               continue;
           end
           % sqrt is expensive so we compare r^2 against the square of
           % the distance
           dist_2 = (x-center(1))^2 + (y-center(2))^2;
           if(dist_2 <= r_max^2)
               % if within radius of object, set to max potential val
               if(dist_2 <= r_center^2)
                   Z(y, x) = MAX_POT;
               else
                   % we only do the square root when we have to
                   % ceil function chosen to prevent div/0 error and to
                   % prevent the potential from being ever larger than 1
                   % we start at 1/2 so we can use 1 for the max pot
                   % +1 here so we clamp off the the potential at zero to 1
                   pot = 1/ceil(dist_2-r_center^2+1);
                   Z(y, x) = pot + Z(y, x);
                   % clamp value to max potential val
                   if(Z(y, x) > MAX_POT)
                       Z(y, x) = MAX_POT;
                   end
               end
           end
       end
    end
end