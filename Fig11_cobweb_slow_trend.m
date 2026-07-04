%% Fig11_cobweb_slow_trend.m
% Reproduces Fig. 11: cobweb diagrams for the logistic map.
%
% The figure contrasts cobweb diagrams in a constant environment at
% lambda = 3.100 with cobweb diagrams taken at selected moments during a
% slow environmental trend from lambda_0 = 1.001 to lambda_T = 3.9605.
%
% Panels:
%   (a) constant environment, long trajectory at lambda = 3.100
%   (b) constant environment, first 15 generations at lambda = 3.100
%   (c-f) slow-trend cobwebs around lambda_t = 3.100, 3.144, 3.152, 3.180

clear; clc; close all;

%% Slow-trend trajectory
Ttrend = 7000;
Tpost = 500;

lambda_start = 1.001;
lambda_end = 3.9605;
beta = (lambda_end - lambda_start) / Ttrend;

n0 = 1 - 1 / lambda_start;

lambda_trend = lambda_start:beta:lambda_end;
lambda_t = [lambda_trend, lambda_end * ones(1, Tpost)];

n = zeros(1, Ttrend + Tpost + 1);
n(1) = n0;

for t = 1:Ttrend
    n(t+1) = lambda_t(t) * n(t) * (1 - n(t));
end

for t = Ttrend+1:Ttrend+Tpost
    n(t+1) = lambda_end * n(t) * (1 - n(t));
end

%% Constant-environment reference trajectory at lambda = 3.100
lambda_constant = 3.100;

% Initial condition for the constant-environment comparison.
n_constant = zeros(1, Ttrend + Tpost + 1);
n_constant(1) = 0.67737;

for t = 1:Ttrend+Tpost
    n_constant(t+1) = lambda_constant * n_constant(t) * ...
        (1 - n_constant(t));
end

%% Cobweb panels
figure
tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

x_grid = 0:0.00001:1;

%% Panel (a): constant environment, long trajectory
nexttile
plot_cobweb_panel( ...
    x_grid, ...
    lambda_constant * ones(1, 2000), ...
    n_constant, ...
    1:2000, ...
    '(a) constant environment at $\lambda=3.100$', ...
    true, ...
    1.0)

%% Panel (b): constant environment, first generations
nexttile
plot_cobweb_panel( ...
    x_grid, ...
    lambda_constant * ones(1, 15), ...
    n_constant, ...
    1:15, ...
    '(b) constant environment at $\lambda=3.100$', ...
    false, ...
    1.0)

%% Panels (c-f): slow trend at selected lambda_t values
inspection_values = [3.100 10; 3.144 15; 3.152 15; 3.180 10];
panel_letters = {'c', 'd', 'e', 'f'};

for iPanel = 1:size(inspection_values, 1)
    nexttile

    lambda_inspection = inspection_values(iPanel, 1);
    n_generations = inspection_values(iPanel, 2);

    first_index = find(lambda_t > lambda_inspection, 1, 'first') - 1;
    t_window = first_index:first_index+n_generations;

    title_string = sprintf('(%s) slow trend, $\\lambda_t\\approx %.3f$', ...
        panel_letters{iPanel}, lambda_inspection);

    plot_cobweb_panel( ...
        x_grid, ...
        lambda_t(t_window), ...
        n, ...
        t_window, ...
        title_string, ...
        false, ...
        0.5)
end

%% Local function
function plot_cobweb_panel(x_grid, lambda_values, n_values, t_window, ...
    title_string, show_legend, zoom_factor)

    plot(x_grid, x_grid, 'k', 'LineWidth', 1)
    hold on

    for i = 1:length(t_window)
        t = t_window(i);
        lambda_current = lambda_values(i);

        plot(x_grid, lambda_current .* x_grid .* (1 - x_grid), ...
            'r', 'LineWidth', 1)
        plot([n_values(t) n_values(t)], ...
            [n_values(t) n_values(t+1)], ...
            'b', 'LineWidth', 1)
        plot([n_values(t) n_values(t+1)], ...
            [n_values(t+1) n_values(t+1)], ...
            'b', 'LineWidth', 1)
    end

    hold off

    xlabel('$n_t$', 'Interpreter', 'latex')
    ylabel('$n_{t+1}$', 'Interpreter', 'latex')
    title(title_string, 'Interpreter', 'latex')

    if show_legend
        leg = legend('1:1 line', '$f_t$ response curve(s)', ...
            'abund. traj.', 'Location', 'northeast', ...
            'Interpreter', 'latex');
        leg.IconColumnWidth = 10;
    end

    rr = max(n_values(t_window)) - min(n_values(t_window));

    if rr == 0
        rr = 0.01;
    end

    x_lower = max(min(n_values(t_window)) - zoom_factor * rr, 0);
    x_upper = min(max(n_values(t_window)) + 2 * zoom_factor * rr, 1);

    if zoom_factor == 0.5
        x_upper = min(max(n_values(t_window)) + zoom_factor * rr, 1);
    end

    xlim([x_lower x_upper])
    ylim([x_lower x_upper])
end
