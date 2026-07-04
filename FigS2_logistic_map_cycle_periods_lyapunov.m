%% FigS2_logistic_map_cycle_periods_lyapunov.m
% Reproduces Figure S2: cycle period and Lyapunov exponent for the
% logistic map.
%
% Model:
%   n_{t+1} = lambda * n_t * (1 - n_t)
%
% For each value of lambda, the script:
%   1. simulates the logistic map for 40000 generations,
%   2. keeps the last 700 generations,
%   3. estimates the period of the asymptotic cycle when it is <= 100,
%   4. computes the Lyapunov exponent from a 1000-generation trajectory.
%
% Period coding follows the manuscript caption:
%   -1 = chaos, or no cycle detected with period <= 100,
%    0 = cycle detected with 7 < period <= 100,
%  1:7 = displayed cycle periods.

clear; clc; close all;

%% Parameters
lambda_step = 0.0001;
lambda_values = 0:lambda_step:4;

n0 = 0.1;

T_period = 40000;
T_keep = 700;

period_tolerance = 1e-5;
max_period = 100;
max_display_period = 7;

T_lyapunov = 1000;

%% Simulate long trajectories for period detection
n = zeros(length(lambda_values), T_period + 1);
n(:,1) = n0;

for iLambda = 1:length(lambda_values)
    lambda = lambda_values(iLambda);

    for t = 1:T_period
        n(iLambda,t+1) = lambda * n(iLambda,t) * ...
            (1 - n(iLambda,t));
    end
end

n_asymptotic = n(:,end-T_keep:end);

%% Estimate cycle period
cycle_period = zeros(1, length(lambda_values));

for iLambda = 1:length(lambda_values)
    mismatch = Inf;
    candidate_period = 1;

    while mismatch > period_tolerance && candidate_period < max_period
        differences = n_asymptotic(iLambda,candidate_period+1:end) - ...
            n_asymptotic(iLambda,1:end-candidate_period);

        mismatch = differences * differences';
        candidate_period = candidate_period + 1;
    end

    if candidate_period < max_period
        cycle_period(iLambda) = candidate_period - 1;
    else
        cycle_period(iLambda) = -1;
    end
end

% The figure focuses on periods 1 to 7. Longer detected cycles are coded 0.
cycle_period_display = cycle_period;
cycle_period_display(cycle_period_display > max_display_period) = 0;

%% Lyapunov exponent
lyapunov_exponent = zeros(1, length(lambda_values));

for iLambda = 1:length(lambda_values)
    lambda = lambda_values(iLambda);

    x = zeros(1, T_lyapunov + 1);
    x(1) = n0;

    running_sum = 0;

    for t = 1:T_lyapunov
        x(t+1) = lambda * x(t) * (1 - x(t));

        derivative = abs(lambda - 2 * lambda * x(t));

        if derivative == 0
            derivative = eps;
        end

        running_sum = running_sum + log(derivative);
    end

    lyapunov_exponent(iLambda) = running_sum / T_lyapunov;
end

%% Figure S2
figure
set(gcf, 'units', 'normalized', 'outerposition', [0.25 0.25 0.55 0.45])

yyaxis left
plot(lambda_values, cycle_period_display, '.b', 'MarkerSize', 5)
ylabel('cycle period', 'Interpreter', 'latex')
ylim([-1.5 max_display_period + 0.5])

yyaxis right
plot(lambda_values, lyapunov_exponent, '.r', 'MarkerSize', 5)
hold on
yline(0, 'k', 'LineWidth', 1)
ylabel('Lyapunov exponent', 'Interpreter', 'latex')
ylim([-10 2])

xlabel('reproductive rate, $\lambda$', 'Interpreter', 'latex')
xlim([0 4])
title('Cycle periods and Lyapunov exponent of the logistic map', ...
    'Interpreter', 'latex')

ax = gca;
ax.FontSize = 13;
