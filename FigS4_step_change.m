%% FigS4_step_change.m
% Reproduces Figure S4 as separate two-panel figures.
%
% Each subfigure contains
%   (I)  abundance dynamics through time after a near-instantaneous change
%        in lambda,
%   (II) a cobweb diagram showing transient and asymptotic dynamics.
%
% Model:
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% The system starts at the equilibrium corresponding to lambda_0,
% n_0 = 1 - 1/lambda_0, then shifts to lambda_T = 3.9605 and is followed
% for 500 generations.
%
% The three lambda_0 values correspond to the three examples shown in
% Figure S4.

clear; clc; close all;

%% Parameters
lambda_T = 3.9605;
transition_duration = 1;
post_transition_duration = 500;

lambda0_values = [1.0020, 1.0403, 1.0392];
case_labels = {'a', 'b', 'c'};
case_descriptions = { ...
    'short transient', ...
    'no transient', ...
    'long transient'};

n_asymptotic_points = 100;

%% Produce one two-panel figure for each initial condition
for iCase = 1:length(lambda0_values)
    lambda_0 = lambda0_values(iCase);

    beta = (lambda_T - lambda_0) / transition_duration;
    lambda_trend = lambda_0:beta:lambda_T;
    lambda_t = [lambda_trend, ...
        lambda_T * ones(1, post_transition_duration)];

    total_time = transition_duration + post_transition_duration;

    n = zeros(1, total_time + 1);
    n(1) = 1 - 1 / lambda_0;

    for t = 1:transition_duration
        n(t+1) = lambda_t(t) * n(t) * (1 - n(t));
    end

    for t = transition_duration+1:total_time
        n(t+1) = lambda_T * n(t) * (1 - n(t));
    end

    %% Figure layout
    figure('Units', 'inches', ...
        'Position', [0 0 16 5], ...
        'PaperPositionMode', 'auto');

    %% Panel I: abundance dynamics through time
    ax1 = subplot(1, 2, 1);
    plot(ax1, 0:total_time, n, 'b.', 'LineWidth', 2)

    ylabel(ax1, '$n_t$', 'Interpreter', 'latex')
    xlabel(ax1, '$t$', 'Interpreter', 'latex')
    xlim(ax1, [0 total_time])
    ylim(ax1, [0 1])

    legend(ax1, '$n_t$', 'Location', 'northeast', ...
        'Interpreter', 'latex')

    title(ax1, sprintf('(%sI) time-series after step-change for $\\lambda_0=%.4f$: %s', ...
        case_labels{iCase}, lambda_0, case_descriptions{iCase}), ...
        'Interpreter', 'latex')

    %% Panel II: cobweb diagram
    ax2 = subplot(1, 2, 2);
    hold(ax2, 'on')

    x_grid = 0:0.01:1;
    cobweb_times = transition_duration+1:total_time;

    plot(ax2, x_grid, x_grid, 'k', 'LineWidth', 1)
    plot(ax2, x_grid, lambda_T .* x_grid .* (1 - x_grid), ...
        'r', 'LineWidth', 1)

    transient_times = cobweb_times(1:end-n_asymptotic_points);
    asymptotic_times = cobweb_times(end-n_asymptotic_points+1:end);

    plot_cobweb_segments(ax2, n, transient_times, 'b', 1)
    plot_cobweb_segments(ax2, n, asymptotic_times, 'm', 3)

    xlabel(ax2, '$n_t$', 'Interpreter', 'latex')
    ylabel(ax2, '$n_{t+1}$', 'Interpreter', 'latex')

    legend(ax2, ...
        '$n_{t+1}=n_t$', ...
        '$n_{t+1}=f(n_t)$ response curve', ...
        '$n_t$, transient dynamics', ...
        '$n_t$, asymptotic dynamics', ...
        'Location', 'northwest', ...
        'Interpreter', 'latex')

    n_window = n(cobweb_times);
    window_range = max(n_window) - min(n_window);

    if window_range == 0
        window_range = 0.01;
    end

    x_lower = max(min(n_window) - window_range, 0);
    x_upper = min(max(n_window) + window_range, 1);

    xlim(ax2, [x_lower x_upper])
    ylim(ax2, [x_lower x_upper])

    title(ax2, sprintf('(%sII) cobweb diagram after step-change for $\\lambda_0=%.4f$: %s', ...
        case_labels{iCase}, lambda_0, case_descriptions{iCase}), ...
        'Interpreter', 'latex')
end

%% Local function
function plot_cobweb_segments(ax, n, t_values, line_colour, line_width)
    for t = t_values
        plot(ax, [n(t) n(t)], [n(t) n(t+1)], ...
            'Color', line_colour, 'LineWidth', line_width, ...
            'HandleVisibility', 'off')
        plot(ax, [n(t) n(t+1)], [n(t+1) n(t+1)], ...
            'Color', line_colour, 'LineWidth', line_width, ...
            'HandleVisibility', 'off')
    end

    % Dummy handle for the legend.
    plot(ax, [nan nan], [nan nan], ...
        'Color', line_colour, 'LineWidth', line_width)
end
