clc, clear, close, figure;

%% F
load('Fs.mat')

data_y = Fs;
data_x = z_pos;
to_x = z_pos(end);


n = size(data_x, 1);

% subplot(1, 1, 1)
% plot(data_x, [data_y, avg])
scatter(data_x, data_y)
hold on
f = fit(data_x, data_y, 'poly3')
fplot(f, [0, to_x])
hold off
% legend('poly4', 'exp1', 'exp2', 'Location', 'southeast')




