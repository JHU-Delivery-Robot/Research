function [] = trench_pot()
    filename = "anim.gif";
    h = figure;
    for a = -10:0.2:10
        % constants
        c = 1;
        b = 0;
        
        % actual algo
        [X,Y] = meshgrid(-20:0.5:20,-20:0.5:20);
        if(a < 0)
            % maximum occurs at the y maxima and x maxima or vice versa
            Zmax = (max(max(Y)) - max(max(X))*a+b).^2;
        else
            % maximum occurs at the y maxima and x minima or vice versa
            Zmax = (max(max(Y)) - min(min(X))*a+b).^2;
        end
        % line in plane
        y_0 = a*X(1,:) + b;
        Z = c*(Y-y_0).^2/Zmax;
    
        % plotting
        max(max(Z))
        hold off;
        surf(X, Y, Z);
        hold on;
        plot3(X(1,:), y_0, zeros(size(X(1, :), 2)));
        title(sprintf("Base y= mx+b; m = %f", a));
        hold off;
        ylim([-20,20]);
        pause(0.5);
        % Capture the plot as an image 
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        % Write to the GIF File 
        if a == -10 
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
        else 
            imwrite(imind,cm,filename,'gif','WriteMode','append'); 
        end 
    end
end
