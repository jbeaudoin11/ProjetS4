clc, clear, close, figure, warning off;

load('Fs.mat')

%% Fs(z)

data_y = Fs;
data_x = z_pos;
to_x = data_x(end);

[f, gof] = fit(data_x, data_y, 'rat03', 'Upper', [-1 Inf Inf Inf], 'Lower', [-1 -Inf -Inf -Inf]);

scatter(data_x, data_y)
hold on
fplot(f, [0, to_x])
hold off
xlabel('z')
ylabel('Fs')

disp(f)
disp(' ')
disp(gof)




