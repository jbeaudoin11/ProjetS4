clc, clear, close all;

distcomp.feature( 'LocalUseMpiexec', false ); % Pour run le code en parallel (parfor)

%% Fe(z, i)
load('Fe_attraction.mat')


%% Const
data_x_1 = z_m1A;
data_y_1 = Fe_m1A;
to_x_1 = data_x_1(end);
ik_1 = -1;

data_x_2 = z_m2A;
data_y_2 = Fe_m2A;
to_x_2 = data_x_2(end);
ik_2 = -2;

eq_base = @(x, ik, coeffs, b_E1) (ik*abs(ik) + b_E1*ik)./(x.^3 + coeffs(2).*x.^2 + coeffs(3).*x + coeffs(4));

% try 1
% start_point = -10000;
% end_point = -15000;
% step = -10;

% try 2
start_point = -1;
end_point = -30;
step = -1;

% try 1
% start_point = -10000;
% end_point = -15000;
% step = -10;


% Setup
points = start_point:step:end_point;
N = size(points, 2);

coeffs = cell(N, 1);
bE1s = zeros(N, 1);
corr = zeros(N, 1);

%% Find the best b_E1
parfor n = 1:N
    warning off
    b = points(n);
    
    [f, gof] = fit(data_x_1, data_y_1, 'rat03', 'Upper', [b Inf Inf Inf], 'Lower', [b -Inf -Inf -Inf]);
    coeffs_found = coeffvalues( f );
    coeffs{n} = coeffs_found;

    bE1 = coeffs_found(1)/ik_1 - abs(ik_1);
    bE1s(n) = bE1;
    eq = @(x, ik) eq_base(x, ik, coeffs_found, bE1);

    ems_1 = mean_err_quad(data_x_1, data_y_1, @(x) eq(x, ik_1));
    ems_2 = mean_err_quad(data_x_2, data_y_2, @(x) eq(x, ik_2));
    
    corr(n, 1) = ems_2 + ems_1;
end

[v, i] = min(corr)

%% Plot

figure

% First
subplot(2, 3, 1)
plot(data_x_1, data_y_1)
hold on
fplot(@(x) eq_base(x, ik_1, coeffs{1}, bE1s(1)), [0, to_x_1])
hold off
title(['b = ', num2str(bE1s(1))])

subplot(2, 3, 4)
plot(data_x_2, data_y_2)
hold on
fplot(@(x) eq_base(x, ik_2, coeffs{1}, bE1s(1)), [0, to_x_2])
hold off

% Best
subplot(2, 3, 2)
plot(data_x_1, data_y_1)
hold on
fplot(@(x) eq_base(x, ik_1, coeffs{i}, bE1s(i)), [0, to_x_1])
hold off
title(['b = ', num2str(bE1s(i))])

subplot(2, 3, 5)
plot(data_x_2, data_y_2)
hold on
fplot(@(x) eq_base(x, ik_2, coeffs{i}, bE1s(i)), [0, to_x_2])
hold off

% Last
subplot(2, 3, 3)
plot(data_x_1, data_y_1)
hold on
fplot(@(x) eq_base(x, ik_1, coeffs{end}, bE1s(end)), [0, to_x_1])
hold off
title(['b = ', num2str(bE1s(end))])

subplot(2, 3, 6)
plot(data_x_2, data_y_2)
hold on
fplot(@(x) eq_base(x, ik_2, coeffs{end}, bE1s(end)), [0, to_x_2])
hold off
