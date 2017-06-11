clc, clear, close, figure, warning off;

%% Fe
load('Fe_attraction.mat')

%% 1
data_x = z_m1A;
data_y = Fe_m1A;
to_x = data_x(end);

[f, gof, output] = fit(data_x, data_y, 'rat03', 'Upper', [-1 Inf Inf Inf], 'Lower', [-1 -Inf -Inf -Inf]);

subplot(2, 1, 1)
scatter(data_x, data_y)
hold on
fplot(f, [0, to_x])
hold off
xlabel('z_{m1A}')
ylabel('Fe_{m1A}')

disp(f)
disp(' ')
% disp(gof)

%% 2
data_x = z_m2A;
data_y = Fe_m2A;
to_x = data_x(end);

[f, gof, output] = fit(data_x, data_y, 'rat03', 'Upper', [-1 Inf Inf Inf], 'Lower', [-1 -Inf -Inf -Inf]);

subplot(2, 1, 2)
scatter(data_x, data_y)
hold on
fplot(f, [0, to_x])
hold off
xlabel('z_{m2A}')
ylabel('Fe_{m2A}')

disp(f)
disp(' ')
% disp(gof)