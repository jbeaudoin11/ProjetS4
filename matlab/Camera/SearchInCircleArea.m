function [ p ] = SearchInCircleArea( data, c, r, w, h )
    yT = max(1, c(2) - r);
    yB = min(h, c(2) + r);
    
    step = 8;
    p = [-1, -1];
    found = false;
    
    %% Find a starting point

    for y = yT:step:yB
        dy = c(2) - y;
        dx = floor(sqrt(r^2 - dy^2));
        
        xL = max(1, c(1) - dx);
        xR = min(w, c(1) + dx);
        
        for x = xL:step:xR
            if ~data(y, x)
                p = [x, y];
                found = true;
                break
            end
        end
        
        if found 
            break
        end
    end
    
    if ~found
        return
    end
    
    %% Find the center of the ball
    
    
    
    
end

