%% FigS5_acceleration_parameter_and_b_tipping.m
% Reproduces Figure S5 and adds the true b-tipping point.
%
% Model:
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% The environmental trend increases lambda_t linearly from lambda_0 = 1.001
% to lambda_T = 3.45. For each trend duration T, the script computes:
%
%   a_t = ||n_{t+1}-n_t| - |n_t-n_{t-1}||
%   d(r) = max_t a_t
%   lambda_a(r) = parameter value at which d(r) occurs
%   b(r) = parameter value at the first oscillation
%
% The figure plots d(r), lambda_a(r), and b(r).

clear; clc; close all;

%% Parameters
lambda_start = 1.001;
lambda_end = 3.45;

post_trend_duration = 200;
n0 = 1 - 1 / lambda_start;

% Trend-duration grid used for the rate scan.
Tmax = 3 / (3 * 10^(-8));
log_Ttrend = log(1000000):log(2):log(Tmax);
trend_durations = floor(exp(log_Ttrend)) + 1;

n_trends = length(trend_durations);

r_values = zeros(1, n_trends);
max_acceleration = zeros(1, n_trends);
param_at_max_acceleration = zeros(1, n_trends);
b_first_oscillation = zeros(1, n_trends);
t_at_max_acceleration = zeros(1, n_trends);
t_first_oscillation = zeros(1, n_trends);

%% Compute d(r), parameter at max acceleration, and first-oscillation point
for iTrend = 1:n_trends
    Ttrend = trend_durations(iTrend);
    r = 2.9604 / Ttrend;

    beta = (lambda_end - lambda_start) / Ttrend;
    lambda_trend = lambda_start:beta:lambda_end;
    lambda_t = [lambda_trend, lambda_end * ones(1, post_trend_duration)];

    n = zeros(1, Ttrend + post_trend_duration + 1);
    n(1) = n0;

    for t = 1:Ttrend
        n(t+1) = lambda_t(t) * n(t) * (1 - n(t));
    end

    for t = Ttrend+1:Ttrend+post_trend_duration
        n(t+1) = lambda_end * n(t) * (1 - n(t));
    end

    velocity = abs(n(2:end) - n(1:end-1));
    acceleration = abs(velocity(2:end) - velocity(1:end-1));

    [max_acceleration(iTrend), first_max_index] = max(acceleration);
    t_at_max_acceleration(iTrend) = first_max_index;
    param_at_max_acceleration(iTrend) = lambda_t(first_max_index);

    first_oscillation_index = find(n(2:end) - n(1:end-1) < 0, 1, 'first');

    if isempty(first_oscillation_index)
        first_oscillation_index = Ttrend;
    end

    t_first_oscillation(iTrend) = first_oscillation_index;
    b_first_oscillation(iTrend) = lambda_t(first_oscillation_index);

    r_values(iTrend) = r;
end

%% Figure S5
figure
set(gcf, 'units', 'normalized', 'outerposition', [0.25 0.25 0.50 0.45])

% Append the limiting point r = 0.
r_plot = [r_values 0];
d_plot = [max_acceleration 0];
lambda_a_plot = [param_at_max_acceleration 3];
b_plot = [b_first_oscillation 3];

yyaxis left
p_d = plot(r_plot, d_plot, 'b-', 'LineWidth', 2);
ylabel('maximum acceleration, $d(r)$', 'Interpreter', 'latex')
ylim([0 4e-4])

yyaxis right
hold on
p_lambda_a = plot(r_plot, lambda_a_plot, 'r-', 'LineWidth', 2);
p_b = plot(r_plot, b_plot, 'r--', 'LineWidth', 2);

ylabel('parameter value', 'Interpreter', 'latex')
ylim([3 3.014])

xlabel('trend speed, $r$', 'Interpreter', 'latex')
xlim([0 3e-6])

legend([p_d p_lambda_a p_b], ...
    {'max. acceleration: $d(r)$', ...
     'param. at max. acceleration', ...
     'param. at first oscillation: $b(r)$'}, ...
    'Interpreter', 'latex', ...
    'Location', 'northwest')

ax = gca;
ax.FontSize = 13;
