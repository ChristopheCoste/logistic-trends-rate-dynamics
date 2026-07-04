%% FigS1_logistic_map_constant_environments.m
% Reproduces Figure S1: transient and asymptotic dynamics of the logistic
% map in constant environments.
%
% Model:
%   n_{t+1} = lambda * n_t * (1 - n_t)
%
% The figure uses the initial condition n0 = 0.395 and shows representative
% constant values of lambda spanning extinction, monotonic convergence,
% damped oscillatory convergence, period-doubling cycles, chaos, and
% periodic windows.

clear; clc; close all;

%% Parameters
Tmax = 60;
n0 = 0.395;

lambda_values = [
    0.5000
    1.5000
    1.9000
    2.6000
    2.9000
    3.2000
    3.5000
    3.8284
    3.9000
    3.9605
];

%% Figure S1
figure
set(gcf, 'units', 'normalized', 'outerposition', [0.25 0.05 0.50 0.90])

for iLambda = 1:length(lambda_values)
    lambda = lambda_values(iLambda);

    n = zeros(1, Tmax + 1);
    n(1) = n0;

    for t = 1:Tmax
        n(t+1) = lambda * n(t) * (1 - n(t));
    end

    subplot(5, 2, iLambda)

    plot(0:Tmax, n, 'b', 'LineWidth', 1)

    xlim([0 Tmax])
    ylim([0 1])

    xlabel('$t$', 'Interpreter', 'latex')
    ylabel('abundance', 'Interpreter', 'latex')
    title(sprintf('$\\lambda = %.4f$', lambda), 'Interpreter', 'latex')

    ax = gca;
    ax.FontSize = 9;
end
