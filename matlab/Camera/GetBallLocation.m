function [ pos_ball_out ] = GetBallLocation( img, w, h, radius_threshold, cell_size, ball_region_size )
    % Preprocessing
    data = img(:,:,2); % Use the green layer 
    data = GetTreshold(data, w, h); % threshold version
    
    % Plate area
    [c, r] = FindBigCircle(data, w, h);
    r = r - radius_threshold;
    
    if r <= 0
        pos_ball_out = [-1, -1];
        return
    end
    
    % Search the ball
    [pos_ball_out] = SearchBallInCircleArea(data, c, r, cell_size, ball_region_size);
end

