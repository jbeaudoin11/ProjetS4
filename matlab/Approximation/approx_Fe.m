clc, clear, close, figure, warning off;

%{
    TODO
    
    Comment définir b_E1 vu qu'il dépend de i_k ?

%}


%% Fe(z, i)
load('Fe_attraction.mat')

%% 1
data_x = z_m1A;
data_y = Fe_m1A;
to_x = data_x(end);

ik = -1;

[f, gof] = fit(data_x, data_y, 'rat03', 'Upper', [-13 Inf Inf Inf], 'Lower', [-15 -Inf -Inf -Inf]);
s = sym( formula( f ) );
cn = coeffnames( f );
cv = coeffvalues( f );
for i = 2:length( cv )
    s = subs( s, cn{i}, cv(i) );
end

syms i_k b_E1
num = i_k*abs(i_k) + b_E1*i_k;

val = solve(num == cv(1), b_E1);
bE1_1 = eval(subs(val, 'i_k', ik));


s = @(x, ik) (ik*abs(ik) + bE1_1*ik)/(x^3 + cv(2)*x^2 + cv(3)*x + cv(4));

s = subs(s, 'p1', num);
s_1 = subs(s, 'b_E1', b_E1_1); % function 1

subplot(2, 1, 1)
scatter(data_x, data_y)
hold on
% fplot(f, [0, to_x])
ezplot(vpa(subs(s_1, 'i_k', -1)), [0, to_x])

hold off
xlabel('z_{m1A}')
ylabel('Fe_{m1A}')

disp(f)
disp(' ')
disp(gof)

vpa(gof.rsquare)

%% 2
data_x = z_m2A;
data_y = Fe_m2A;
to_x = data_x(end);

[f, gof] = fit(data_x, data_y, 'rat03', 'Upper', [0 Inf Inf Inf], 'Lower', [-1 -Inf -Inf -Inf]);
s = sym( formula( f ) );
cn = coeffnames( f );
cv = coeffvalues( f );
for i = 1:length( cv )
    s = subs( s, cn{i}, cv(i) );
end

subplot(2, 1, 2)
scatter(data_x, data_y)
hold on
% fplot(f, [0, to_x])
% ezplot(s, [0, to_x])
subs(s_1, 'i_k', -2)
ezplot(vpa(subs(s_1, 'i_k', -2)), [0, to_x])
hold off
xlabel('z_{m2A}')
ylabel('Fe_{m2A}')

disp(f)
disp(' ')
disp(gof)