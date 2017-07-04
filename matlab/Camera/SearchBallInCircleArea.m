function [ p_out, p1_out ] = SearchBallInCircleArea( data, c, r, w, h, cell_size, ball_region_size )
    yT = max(1, c(2) - r);
    yB = min(h, c(2) + r);
    
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
                p1_out = [x, y] - 10;
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
    yT = p1_out(2);
    yB = min([h, c(2) + r, p1_out(2) + ball_region_size]);
    nb_p_x = 0;
    nb_p_y = 0;
    m_x = 0;
    m_y = 0;
    
    for y = yT:yB
        dy = c(2) - y;
        dx = floor(sqrt(r^2 - dy^2));
        
        xL = p1_out(1);
        xR = min([w, c(1) + dx, p1_out(1) + ball_region_size]);
        
        nb_p_y = nb_p_y + 1;
        m_y = m_y + y;
        
        % left
        for x = xL:xR
            if ~data(y, x)
                nb_p_x = nb_p_x + 1;
                m_x = m_x + x;
                break
            end
        end
        
        % right
        for x = xR:-1:xL
            if ~data(y, x)
                nb_p_x = nb_p_x + 1;
                m_x = m_x + x;
                break
            end
        end
    end
    
    p_out = [floor(m_x/nb_p_x), floor(m_y/nb_p_y)];
    
end

