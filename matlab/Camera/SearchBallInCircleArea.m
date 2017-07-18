function [ p_out, p1_out ] = SearchBallInCircleArea( data, c, r, w, h, cell_size, ball_region_size )
    yT = c(2) - r;
    yB = c(2) + r;
    
    p_out = [-1, -1];
    p1_out = [-1, -1];
    
    %% Find from top left
    found = false;

    for y = yT:cell_size:yB
        dy = c(2) - y;
        dx = floor(sqrt(r^2 - dy^2));
        
        xL = max(1, c(1) - dx);
        xR = min(w, c(1) + dx);
        
        for x = xL:cell_size:xR
            if ~data(y, x)
                % TODO search if nb of neighbors > ?
                p1_out = [x-15, y-10]; % random numbers
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
    
    %% Center of geometries
    yT = max([c(2) - r, p1_out(2)]);
    yB = min([c(2) + r, p1_out(2) + ball_region_size]);
    nb_p_x = 0;
    nb_p_y = 0;
    m_x = 0;
    m_y = 0;
    
    for y = yT:yB
        dy = c(2) - y;
        dx = floor(sqrt(r^2 - dy^2));
        
        [xL, iL] = max([c(1) - dx, p1_out(1)]);
        [xR, iR] = min([c(1) + dx, p1_out(1) + ball_region_size]); 
        
        % Find the first black pixel from the left
        if iL == 2
            found = false;
            for x = xL:xR
                if ~data(y, x)
                    xL = x;
                    found = true;
                    break
                end
            end
            
            if ~found
                continue;
            end
        end
        
        % Find the first black pixel from the right
        if iR == 2
            found = false;
            for x = xR:-1:xL
                if ~data(y, x)
                    xR = x;
                    found = true;
                    break
                end
            end
            
            if ~found
                continue;
            end
        end
        
        nb_p = (xR - xL) + 1;
        if nb_p == 1
            continue
        end
        
        nb_p_x = nb_p_x + nb_p;
        m_x = m_x + sum(xL:xR);
        
        nb_p_y = nb_p_y + nb_p;
        m_y = m_y + nb_p * y;
        
    end
    
    if nb_p_x == 0
        return;
    end
    
    p_out = [floor(m_x/nb_p_x), floor(m_y/nb_p_y)];
    
end

