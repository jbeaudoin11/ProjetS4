function [ speed_x, speed_y ] = GetBallSpeed( old_positions )
    N = size(old_positions,1);    
    h = 1/30*34;
        
    if N == 1
        speed_x = 0;
        speed_y = 0;
    elseif N == 2
        speed_x = (-1*old_positions(2,1)+1*old_positions(1,1))/h;
        speed_y = (-1*old_positions(2,2)+1*old_positions(1,2))/h;
    elseif N == 3
        speed_x = (1*old_positions(3,1)-4*old_positions(2,1)+3*old_positions(1,1))/(2*h);
        speed_y = (1*old_positions(3,2)-4*old_positions(2,2)+3*old_positions(1,2))/(2*h);
    elseif N == 4
        speed_x = (-2*old_positions(4,1)+9*old_positions(3,1)-18*old_positions(2,1)+11*old_positions(1,1))/(6*h);
        speed_y = (-2*old_positions(4,2)+9*old_positions(3,2)-18*old_positions(2,2)+11*old_positions(1,2))/(6*h);
    elseif N == 5
        speed_x = (3*old_positions(5,1)-16*old_positions(4,1)+36*old_positions(3,1)-48*old_positions(2,1)+25*old_positions(1,1))/(12*h);
        speed_y = (3*old_positions(5,2)-16*old_positions(4,2)+36*old_positions(3,2)-48*old_positions(2,2)+25*old_positions(1,2))/(12*h);
    elseif N == 6
        speed_x = (-12*old_positions(6,1)+75*old_positions(5,1)-200*old_positions(4,1)+300*old_positions(3,1)-300*old_positions(2,1)+137*old_positions(1,1))/(60*h);
        speed_y = (-12*old_positions(6,2)+75*old_positions(5,2)-200*old_positions(4,2)+300*old_positions(3,2)-300*old_positions(2,2)+137*old_positions(1,2))/(60*h);
    elseif N == 7
        speed_x = (10*old_positions(7,1)-72*old_positions(6,1)+225*old_positions(5,1)-400*old_positions(4,1)+450*old_positions(3,1)-360*old_positions(2,1)+147*old_positions(1,1))/(60*h);
        speed_y = (10*old_positions(7,2)-72*old_positions(6,2)+225*old_positions(5,2)-400*old_positions(4,2)+450*old_positions(3,2)-360*old_positions(2,2)+147*old_positions(1,2))/(60*h);   
    end
end

