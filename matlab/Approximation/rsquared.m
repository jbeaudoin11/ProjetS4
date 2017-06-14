function [ out ] = rsquared( data_x, data_y, eq )
    y_ = mean(data_y);
    
    top =  sum((eq(data_x) - y_).^2);
    bot =  sum((data_y - y_).^2);

    out = top/bot;
end

