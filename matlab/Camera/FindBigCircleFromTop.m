function [ c_out, r_out ] = FindBigCircleFromTop( data, w, h, y)
    %% X
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

    %% Y
    x = xR;
    
    yT = y;
    yB = h;
        
    % Bot part
    for i = h:-1:floor(h/2)
        if data(i, x)
           yB = i;  
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

