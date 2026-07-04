%% FigS10_slow_trend_superimposition_diagram.m
% Reproduces Figure S10.
%
% The script shows population size n_t as a function of the time-varying
% reproductive rate lambda_t for a slow environmental trend in the logistic
% map:
%
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% The trend starts at lambda_start = 1.001 and ends at lambda_end = 3.9605.
% The population is initiated at the stable equilibrium corresponding to
% lambda_start. The trend lasts T = 20000 generations, followed by 500
% generations at constant lambda_end.
%
% The abundance trajectory is superimposed on the classical
% constant-environment bifurcation diagram, and the moving equilibrium
% n_hat(lambda_t) = 1 - 1/lambda_t is shown in red.

clear; clc; close all;

%% Bifurcation diagram
lambda_grid = 0:0.0001:4;
n0_bif = 0.1;
T_bif = 10000;
T_keep = 200;

n_bif = zeros(length(lambda_grid), T_bif + 1);
n_bif(:,1) = n0_bif;

for i_lambda = 1:length(lambda_grid)
    lambda = lambda_grid(i_lambda);

    for t = 1:T_bif
        n_bif(i_lambda,t+1) = lambda * n_bif(i_lambda,t) * ...
            (1 - n_bif(i_lambda,t));
    end
end

n_bif_plot = n_bif(:,end-T_keep:end);

%% Environmental trend
lambda_start = 1.001;
lambda_end = 3.9605;

Ttrend = 20000;
post_trend_duration = 500;

r = (lambda_end - lambda_start) / Ttrend;

n0 = 1 - 1 / lambda_start;
lambda_trend = lambda_start:r:lambda_end;
lambda_t = [lambda_trend, lambda_end * ones(1, post_trend_duration)];

n = zeros(1, Ttrend + post_trend_duration + 1);
n(1) = n0;

for t = 1:Ttrend
    n(t+1) = lambda_trend(t) * n(t) * (1 - n(t));
end

for t = Ttrend+1:Ttrend+post_trend_duration
    n(t+1) = lambda_end * n(t) * (1 - n(t));
end

%% Figure S10
figure
set(gcf, 'units', 'normalized', 'outerposition', [0.2 0.2 0.6 0.6])

p_bif = plot(lambda_grid(:), n_bif_plot(:,1), 'k.', 'LineWidth', 2);
hold on

plot(lambda_grid(2:end), n_bif_plot(2:end,:), ...
    'k.', 'LineWidth', 2, 'HandleVisibility', 'off')
hold on

p_eq = plot(lambda_t, 1 - 1 ./ lambda_t, 'r.', 'LineWidth', 1);
hold on

p_traj = plot(lambda_t, n, 'b.', 'LineWidth', 2);

xlabel('$\lambda_t$', 'Interpreter', 'latex')
ylabel('$n_t$', 'Interpreter', 'latex')

legend([p_bif p_traj p_eq], ...
       'bifurcation diagram', ...
       '$n(\lambda_t)$', ...
       '$\hat{n}$', ...
       'Location', 'NorthWest', ...
       'Interpreter', 'latex', ...
       'FontSize', 8)

ax = gca;
ax.FontSize = 13;
