function [ v_out, i_out ] = min_int_with_index( a, b )
    if a < b
        v_out = a;
        i_out = 1;
    else
        v_out = b;
        i_out = 2;
    end
end

