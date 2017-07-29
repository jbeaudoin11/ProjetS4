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
    
    radiuses = [rt1, rt2, rb1, rb2];
    centers = [ct1; ct2; cb1; cb2];
    
    %% Verify the values
    validated_circles = [false, false, false, false];
    
    % Test if the radius is bigger than the image or smaller than half
    % the image
    for i=1:4
		r = radiuses(i);
        validated_circles(i) = (r <= w/2 && r <= h/2) && (r > w/4 && r > h/4);
    end
    
    % Compare compenents with each others
    diffs_radiuses = zeros(4);
    diffs_centers_x = zeros(4);
    diffs_centers_y = zeros(4);
    for i=1:4
        for j=i:4
            d = abs(radiuses(i) - radiuses(j));
            diffs_radiuses(i, j) = d;
            diffs_radiuses(j, i) = d;
            
            d = abs(centers(i, 1) - centers(j, 1));
            diffs_centers_x(i, j) = d;
            diffs_centers_x(j, i) = d;
            
            d = abs(centers(i, 2) - centers(j, 2));
            diffs_centers_y(i, j) = d;
            diffs_centers_y(j, i) = d;
        end
    end
    
    % Test find if there is a small diff between atleast 2 radius
    for i=1:4
        if sum(diffs_radiuses(i, :) <= 2) > 1
            if sum(diffs_centers_x(i, :) <= 2) > 1
                if sum(diffs_centers_y(i, :) <= 2) > 1
                    validated_circles(i) = true;
                    continue;
                end
            end
        end
        
        validated_circles(i) = false;
    end
    
    %% Get the mean value for the radius and the center
    c_out = [0, 0];
    r_out = 0;
    validated_cnt = 0;
    for i=1:4
        if validated_circles(i)
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

