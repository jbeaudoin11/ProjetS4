function [ c_out, r_out ] = FindBigCircle( data, w, h )
    % We need to apply the algo 2 times in case the ball was on the edge
    % than the good circle is the one with a bigger radius

    [ct, rt] = FindBigCircleFromTop(data, w, h);
    [cb, rb] = FindBigCircleFromBot(data, w, h);
    
    if rt >= rb
        c_out = ct;
        r_out = rt;
%         disp('top')
    else
        c_out = cb;
        r_out = rb;
%         disp('bot')
    end
end

