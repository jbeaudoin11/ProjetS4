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

eq_base = @(x, ik, cv, b_E1) (ik*abs(ik) + b_E1*ik)./(x.^3 + cv(2).*x.^2 + cv(3).*x + cv(4));

start_point = -10;
% end_point = -500;
end_point = -100;
step = -10;
points = start_point:step:end_point;
N = size(points, 2);

corr = zeros(N, 1);

%% Find the best b_E1
parfor n = 1:N
    warning off
    b = points(n);
    
    [f, gof] = fit(data_x_1, data_y_1, 'rat03', 'Upper', [b Inf Inf Inf], 'Lower', [b -Inf -Inf -Inf]);
    cv = coeffvalues( f );

    bE1 = cv(1)/ik_1 - abs(ik_1);
    eq = @(x, ik) eq_base(x, ik, cv, bE1);

%     r2_1 = rsquared(data_x_1, data_y_1, @(x) eq(x, ik_1, cv, bE1))
    coefs = corrcoef(eq(data_x_1, ik_1), data_y_1);
    r2_1 = coefs(1, 2);
    
%     r2_2 = rsquared(data_x_2, data_y_2, @(x) eq(x, ik_2, cv, bE1));
    coefs = corrcoef(eq(data_x_2, ik_2), data_y_2);
    r2_2 = coefs(1, 2);
    vpa(r2_2)
    
    corr(n, 1) = r2_1 * r2_2;
    
    if(b == start_point || b == end_point)
        figure

        subplot(2, 1, 1)
        plot(data_x_1, data_y_1)
        hold on
        fplot(@(x) eq(x, ik_1), [0, to_x_1])
        hold off
        title(['b = ', num2str(b)])

        subplot(2, 1, 2)
        plot(data_x_2, data_y_2)
        hold on
        fplot(@(x) eq(x, ik_2), [0, to_x_2])
        hold off
    end
end

[v, i] = max(corr);
i
vpa(v)

%% Final
% 
% subplot(2, 1, 1)
% scatter(data_x, data_y)
% hold on
% fplot(@(x) s_1(x, -1), [0, to_x])
% 
% hold off
% xlabel('z_{m1A}')
% ylabel('Fe_{m1A}')
% rsquared(data_x, data_y, @(x) s_1(x, ik))
% 
% subplot(2, 1, 2)
% scatter(data_x, data_y)
% hold on
% fplot(@(x) s_1(x, -2), [0, to_x])
% hold off
% xlabel('z_{m2A}')
% ylabel('Fe_{m2A}')
