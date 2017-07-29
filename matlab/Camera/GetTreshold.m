function [ tresh_out ] = GetTreshold( data, w, h )

    % Take 4 mesures of the color and take the highest of those.
    values = [0, 0, 0, 0];
    values(1) = data(floor(h*.25), floor(w/2));
    values(2) = data(floor(h*.33), floor(w/2));
    values(3) = data(floor(h*.66), floor(w/2));
    values(4) = data(floor(h*.75), floor(w/2));
    value = max(values);
    
    % We need take a lower value than that
    m = 0.99; 
    if value < 50
        m = 0.4;
    elseif value < 100
        m = 0.75;
    elseif value < 200
        m = 0.85;
    end
    
    tresh_out = data > floor(value*m);
    
end

