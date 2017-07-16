function [ c_out, r_out ] = FindBigCircle( data, w, h )
    % We need to apply the algo 2 times in case the ball was on the edge
    % than the good circle is the one with a bigger radius

    % To be sure that we dont pick up bad result we need to find more than
    % one result and compare them together
    
    %% Find the circle
    
    % 1/5
    [ct1, rt1] = FindBigCircleFromTop(data, w, h, floor(h*0.2));
    % 2/5
    [ct2, rt2] = FindBigCircleFromTop(data, w, h, floor(h*0.4));
    
    % 3/5
    [cb1, rb1] = FindBigCircleFromBot(data, w, h, floor(h*0.6));
    % 4/5
    [cb2, rb2] = FindBigCircleFromBot(data, w, h, floor(h*0.8));
    
%     radiuses = [rt1, rt2, rb1, rb2];
%     radiuses = [209, 208, 207, 206];
    radiuses = [209, 208, 207, 208+2];
    centers = [ct1; ct2; cb1; cb2];
    
    %% Verify the values
    validated_radius = [false, false, false, false];
    
    % Test if the radius is bigger than the image or smaller than half
    % the image
    for i=1:4
        validated_radius(i) = (radiuses(i) < w || radiuses(i) < h) || (radiuses(i) > w/2 || radiuses(i) > h/2);
    end
    
    % Compare radiuses with each others
    diffs = zeros(4);
    for i=1:4
        for j=i:4
            d = abs(radiuses(i) - radiuses(j));
            diffs(i, j) = d;
            diffs(j, i) = d;
        end
    end
    
    % Test find if there is a small diff between atleast 2 radius
    for i=1:4
        validated_radius(i) = sum(diffs(i, :) <= 2) > 1; 
    end
    
    %% Get the mean value for the radius and the center
    c_out = [0, 0];
    r_out = 0;
    validated_cnt = 0;
    for i=1:4
        if validated_radius(i)
            r_out = r_out + radiuses(i);
            c_out = c_out + centers(i, :);
            validated_cnt = validated_cnt + 1;
        end
    end
    
    % If there is no good value the radius is -1
    if validated_cnt == 0
        r_out = -1;
    else
        c_out = floor(c_out/validated_cnt);
        r_out = floor(r_out/validated_cnt);
    end
    
end

