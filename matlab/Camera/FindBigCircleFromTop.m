function [ c_out, r_out ] = FindBigCircleFromTop( data, w, h )
    %% X
    y = floor(h/4);
    
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
    
    %% Center
    dx = floor((xR-xL)/2);
    dy = floor((yB-yT)/2);
    c_out = [xL + dx, yT + dy];

    %% Radius
    r_out = floor(sqrt(double(dx^2 + dy^2)));
end

