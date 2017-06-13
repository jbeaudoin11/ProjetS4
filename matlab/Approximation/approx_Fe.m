clc, clear, close, figure, warning off;


%% Fe(z, i)
load('Fe_attraction.mat')

%% 1
data_x = z_m1A;
data_y = Fe_m1A;
to_x = data_x(end);
ik = -1;

[f, gof] = fit(data_x, data_y, 'rat03', 'Upper', [-15 Inf Inf Inf], 'Lower', [-15 -Inf -Inf -Inf]);

cv = coeffvalues( f );
bE1_1 = cv(1)/ik - abs(ik);
s_1 = @(x, ik) (ik*abs(ik) + bE1_1*ik)/(x^3 + cv(2)*x^2 + cv(3)*x + cv(4));

rsquared(data_x, data_y, @(x) s_1(x, ik))

subplot(2, 1, 1)
scatter(data_x, data_y)
hold on
fplot(@(x) s_1(x, -1), [0, to_x])

hold off
xlabel('z_{m1A}')
ylabel('Fe_{m1A}')

% disp(f)
% disp(' ')
% disp(gof)

%% 2
data_x = z_m2A;
data_y = Fe_m2A;
to_x = data_x(end);
ik = -2;

rsquared(data_x, data_y, @(x) s_1(x, ik))

subplot(2, 1, 2)
scatter(data_x, data_y)
hold on
fplot(@(x) s_1(x, -2), [0, to_x])
hold off
xlabel('z_{m2A}')
ylabel('Fe_{m2A}')

% disp(f)
% disp(' ')
% disp(gof)