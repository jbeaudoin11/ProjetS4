function [old_positions_out] = AddPosition(old_positions, pos)
    N = length(old_positions);
    
    if N == 7 
        old_positions_out = [pos; old_positions(1:end-1,:)]; 
    else
        old_positions_out = [pos; old_positions];
    end 
end

