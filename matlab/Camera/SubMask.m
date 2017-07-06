function [ res_out ] = SubMask( data, mask, w, h )

    res_out = repmat(data, 1);

    for y = 1:h
        for x = 1:w
            if ~mask(y, x)
                res_out(y, x) = true;
            end
        end
    end
    
end

