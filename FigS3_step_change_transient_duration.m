%% FigS3_step_change_transient_duration.m
% Reproduces Figure S3: transient duration after an instantaneous
% step-change to lambda_T = 3.9605 in the logistic map.
%
% Model:
%   n_{t+1} = lambda_T * n_t * (1 - n_t)
%
% For each initial abundance n0, the transient duration is estimated as the
% last generation before the trajectory becomes epsilon-close to a
% 4-generation cycle:
%
%   max_t | n(t+4) - n(t) | < epsilon
%
% with epsilon = 0.0001. The black vertical lines show the four points of
% the asymptotic 4-generation cycle at lambda_T.

clear; clc; close all;

%% Parameters
lambda_T = 3.9605;
epsilon = 1e-4;

Tmax = 1500;
n0_step = 1e-4;
n0_values = n0_step:n0_step:1-n0_step;

%% Compute the asymptotic 4-generation cycle at lambda_T
Tcycle = 10000;
n_cycle = zeros(1, Tcycle + 1);
n_cycle(1) = 0.5;

for t = 1:Tcycle
    n_cycle(t+1) = lambda_T * n_cycle(t) * (1 - n_cycle(t));
end

cycle_points = n_cycle(end-3:end);

%% Estimate transient duration for each initial condition
transient_duration = zeros(1, length(n0_values));

for iN0 = 1:length(n0_values)
    n = zeros(1, Tmax + 1);
    n(1) = n0_values(iN0);

    for t = 1:Tmax
        n(t+1) = lambda_T * n(t) * (1 - n(t));
    end

    distance_to_period4 = abs(n(5:end) - n(1:end-4));

    if all(distance_to_period4 < epsilon)
        transient_duration(iN0) = 0;
    else
        last_far_generation = find(distance_to_period4 > epsilon, 1, 'last');
        transient_duration(iN0) = last_far_generation;
    end
end

%% Figure S3
figure
set(gcf, 'units', 'normalized', 'outerposition', [0.25 0.25 0.55 0.45])

plot(n0_values, transient_duration, '.k', 'MarkerSize', 5)
hold on
xline(cycle_points, 'k', 'LineWidth', 1)

xlabel('$n_0$', 'Interpreter', 'latex')
ylabel('transient duration', 'Interpreter', 'latex')

legend({'$\min(t, \max_t |n(t+4)-n(t)| < \epsilon)$', ...
        'cycle points at $\lambda_T$'}, ...
    'Interpreter', 'latex', 'Location', 'northeast')

xlim([0 1])
ylim([0 max(transient_duration) * 1.05])

ax = gca;
ax.FontSize = 13;
