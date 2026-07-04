%% FigS12_nonlinear_trend_superimposition_diagram.m
% Reproduces Figure S12.
%
% The script studies the logistic map under a nonlinear environmental trend:
%
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% The reproductive rate lambda_t starts at lambda_start and increases until
% lambda_end according to the recurrence:
%
%   lambda_{t+1} = (1/lambda_t + h_hat * (lambda_t - 1))^(-1)
%
% After the end of the trend, lambda_t remains constant at lambda_end. The
% figure contains three panels:
%
%   I:   abundance time series and lambda_t over chronological time
%   II:  abundance trajectory superimposed on the bifurcation diagram
%   III: zoom of the superimposition diagram around lambda_t = 3

clear; clc; close all;

%% Bifurcation diagram
lambda_grid = 0:0.001:4;
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

%% Nonlinear environmental trend
h_hat = -0.001;

lambda_start = 1.01;
lambda_end = 3.9605;

post_trend_duration = 200;
n0 = 1 - 1 / lambda_start;

lambda_trend = lambda_start;

while lambda_trend(end) < lambda_end
    lambda_next = (1 / lambda_trend(end) + ...
        h_hat * (lambda_trend(end) - 1))^(-1);
    lambda_trend(end+1) = lambda_next;
end

Ttrend = length(lambda_trend) - 1;

lambda_t = [lambda_trend(1:Ttrend), ...
    lambda_end * ones(1, post_trend_duration)];

n = zeros(1, length(lambda_t));
n(1) = n0;

for t = 1:length(lambda_t)-1
    n(t+1) = lambda_t(t) * n(t) * (1 - n(t));
end

%% Figure S12
figure
set(gcf, 'units', 'normalized', 'outerposition', [0.1 0.25 0.8 0.4])

tiledlayout(1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

%% Panel I: dynamics over chronological time
nexttile

yyaxis left
p_n = plot(n, 'b', 'LineWidth', 2);
ylabel('abundance')
hold on

yyaxis right
p_lambda = plot(lambda_t, 'r', 'LineWidth', 2);
ylabel('$\lambda_t$', 'Interpreter', 'latex')
ylim([0 4])
hold on

p_T = xline(Ttrend, 'c', 'LineWidth', 2);

xlabel('$t$ (generations)', 'Interpreter', 'latex')
xlim([0 Ttrend + post_trend_duration])

legend([p_n p_lambda p_T], ...
       '$n_t$', ...
       '$\lambda_t$ (rhs)', ...
       '$T$ (end of trend)', ...
       'Location', 'NorthWest', ...
       'Interpreter', 'latex', ...
       'FontSize', 8)

%% Panel II: trajectory over lambda_t and bifurcation diagram
nexttile

p_bif = plot(lambda_grid(:), n_bif_plot(:,1), 'k.', 'LineWidth', 1);
hold on

plot(lambda_grid(2:end), n_bif_plot(2:end,:), ...
    'k.', 'LineWidth', 1, 'HandleVisibility', 'off')
hold on

p_traj = plot(lambda_t, n, 'b', 'LineWidth', 2);

xlabel('$\lambda_t$', 'Interpreter', 'latex')
ylabel('abundance')

legend([p_bif p_traj], ...
       'bifurcation diagram', ...
       '$n_t$ as a function of $\lambda_t$', ...
       'Location', 'NorthWest', ...
       'Interpreter', 'latex', ...
       'FontSize', 8)

%% Panel III: zoom around lambda_t = 3
nexttile

p_bif = plot(lambda_grid(:), n_bif_plot(:,1), 'k.', 'LineWidth', 1);
hold on

plot(lambda_grid(2:end), n_bif_plot(2:end,:), ...
    'k.', 'LineWidth', 1, 'HandleVisibility', 'off')
hold on

p_traj = plot(lambda_t, n, 'b', 'LineWidth', 2);

xlabel('$\lambda_t$', 'Interpreter', 'latex')
ylabel('abundance')
xlim([2.99 3.01])

legend([p_bif p_traj], ...
       'bifurcation diagram', ...
       '$n_t$ as a function of $\lambda_t$', ...
       'Location', 'NorthWest', ...
       'Interpreter', 'latex', ...
       'FontSize', 8)
