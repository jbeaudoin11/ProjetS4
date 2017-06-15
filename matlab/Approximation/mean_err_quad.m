function [ out ] = mean_err_quad( data_x, data_y, eq )
    N = size(data_x, 1);
    y_ = mean(data_y);
    
    out = (1/N * sum((eq(data_x) - y_).^2));
end

