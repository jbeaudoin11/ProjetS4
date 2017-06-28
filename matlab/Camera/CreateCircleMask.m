function [ mask_out ] = CreateCircleMask( c, r, w, h )

    mask_out = zeros(h, w);
    
    yT = max(1, c(2) - r);
    yB = min(h, c(2) + r);    

    for y = yT:yB
        dy = c(2) - y;
        dx = floor(sqrt(r^2 - dy^2));
        
        xL = max(1, c(1) - dx);
        xR = min(w, c(1) + dx);
        
        for x = xL:xR
            mask_out(y, x) = 1;
        end
    end
    
    mask_out = mask_out >= 1; % Logical version
end

