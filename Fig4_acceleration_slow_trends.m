%% Fig4_acceleration_slow_trends.m
% Reproduces Fig. 4 for the logistic map under slow environmental trends.
%
% For several slow trend durations, the script simulates the logistic map
% with a linearly increasing reproductive rate and plots the abundance
% acceleration
%
%   a_t = ||n_{t+1} - n_t| - |n_t - n_{t-1}||
%
% as a function of the time-varying reproductive rate lambda_t. The plot
% focuses on the narrow range around the delayed first bifurcation.

clear; clc; close all;

%% Parameters
lambda_start = 1.001;
lambda_end   = 3.45;

n0 = 1 - 1 / lambda_start;

lambda_plot_min = 3;
lambda_plot_max = 3.014;

% Trend durations used to compare very slow and slow environmental change.
Tmax = 3 / (3e-8);
Ttrend_vec = floor(exp(log(1e6):log(2):log(Tmax))) + 1;
n_trends = length(Ttrend_vec);

% Red-white-blue colour gradient for the different trend durations.
trend_colours = [
    0.55 0.00 0.00   % dark red
    1.00 0.00 0.00   % red
    0.85 0.00 0.35   % dark pink / burgundy
    0.80 0.00 0.80   % magenta
    0.50 0.00 0.80   % purple
    0.00 0.55 1.00   % light blue
    0.00 0.00 1.00   % blue
];
%% Simulate each trend and plot acceleration near lambda = 3
figure
hold on

for i = n_trends:-1:1
    Ttrend = Ttrend_vec(i);

    % Trend-speed label used in the figure legend.
    r = 2.9604 / Ttrend;
    beta = (lambda_end - lambda_start) / Ttrend;

    n_current = n0;
    speed_previous = NaN;

    lambda_plot = [];
    acceleration_plot = [];

    for t = 1:Ttrend
        lambda_current = lambda_start + beta * (t - 1);

        n_next = lambda_current * n_current * (1 - n_current);
        speed_current = abs(n_next - n_current);

        if t > 1
            acceleration_current = abs(speed_current - speed_previous);

            if lambda_current >= lambda_plot_min && lambda_current <= lambda_plot_max
                lambda_plot(end+1) = lambda_current; %#ok<SAGROW>
                acceleration_plot(end+1) = acceleration_current; %#ok<SAGROW>
            elseif lambda_current > lambda_plot_max
                break
            end
        end

        n_current = n_next;
        speed_previous = speed_current;
    end

    plot(lambda_plot, acceleration_plot, ...
        'LineWidth', 2, ...
        'Color', trend_colours(i,:), ...
        'DisplayName', sprintf('$r = %.1e$', r));
end

hold off

xlim([lambda_plot_min lambda_plot_max])
xlabel('reproductive rate, $\lambda_t$', 'Interpreter', 'latex')
ylabel('acceleration, $a_t$', 'Interpreter', 'latex')
legend('show', 'Interpreter', 'latex', 'Location', 'NorthWest')

ax = gca;
ax.FontSize = 12;
box off
