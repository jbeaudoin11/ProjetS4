function [ c_out, r_out ] = FindBigCircleFromBot( data, w, h, y )
    %% Try to find the distance in X of the circle at a heigth of y
    xL = 1;
    xR = w;
    
    % Left part
    for i = 1:floor(w/2)
        if data(y, i)
        	xL = i;  
            break;
        end
    end
    
    % Right part
    for i = w:-1:floor(w/2)
        if data(y, i)
           xR = i;
           break;
        end
    end

    %% Try to find the Y distance of the circle where we found the previous right X
    x = xR;
    
    yT = 1;
    yB = y;
    
    % Top part
    for i = 1:floor(h/2)
        if data(i, x)
           yT = i;  
           break;
        end
    end
    
    %% Calculate the center of the circle
    dx = floor((xR-xL)/2);
    dy = floor((yB-yT)/2);    
    c_out = [xL + dx, yT + dy];

    %% Calculate and do a basic validation of radius
    if dx <= 0 || dy <= 0
        r_out = -1;
    else
        r_out = floor(sqrt(double(dx^2 + dy^2)));
    end
end

