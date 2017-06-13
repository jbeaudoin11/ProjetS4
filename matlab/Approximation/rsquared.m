function [ out ] = rsquared( data_x, data_y, eq )

    N = size(data_x, 2);
    y_ = 1/N*sum(data_y);
    
    top =  sum((arrayfun(@(x) eq(x), data_x) - y_).^2);
    bot =  sum((data_y - y_).^2);

    out = top/bot;
    out
%     corr(
end

