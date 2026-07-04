%% FigS16_nested_lag_cascade_dynamics.m
% Reproduces Figure S16.
%
% The script studies the logistic map under a linear environmental trend:
%
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% where lambda_t increases from lambda_start to lambda_end at constant rate
% r. The abundance trajectory is compared to the moving equilibrium:
%
%   n_hat_t = 1 - 1/lambda_t
%
% The lag is
%
%   h_t = n_t - n_hat_t
%
% and the nested lag quantity is
%
%   g_t = h_t - h_hat_t
%
% where h_hat_t is the analytical approximation used in the manuscript.
% The figure shows log(|g_t|), log(|h_t|), and log(n_t) as functions of
% lambda_t. This gives the real part of the logarithms plotted by MATLAB
% when g_t or h_t are negative, without generating complex-number warnings.

clear; clc; close all;

%% Environmental trend
r = 1.5e-4;

lambda_start = 1.001;
lambda_end = 3.9605;

n0 = 1 - 1 / lambda_start;

Ttrend = floor((lambda_end - lambda_start) / r);

lambda_t = lambda_start:r:lambda_end;
n_hat = 1 - 1 ./ lambda_t;

%% Simulate abundance trajectory
n = zeros(1, Ttrend + 1);
n(1) = n0;

for t = 1:Ttrend
    n(t+1) = lambda_t(t) * n(t) * (1 - n(t));
end

%% Lag quantities
l2 = -r ./ (lambda_t.^2);

h = n - n_hat;
h_hat = l2 .* (-1 ./ (1 - lambda_t));

g = h - h_hat;

%% Figure S16
figure

color_g = [0.0000 0.4470 0.7410];
color_h = [0.8500 0.3250 0.0980];
color_n = [0.9290 0.6940 0.1250];

yyaxis left
p_g = plot(lambda_t, log(abs(g)), ...
    'LineStyle', '-', ...
    'Color', color_g, ...
    'LineWidth', 2);
hold on

p_h = plot(lambda_t, log(abs(h)), ...
    'LineStyle', '-', ...
    'Color', color_h, ...
    'LineWidth', 2);

ylabel('logarithm of nested functions $g_t$ and $h_t$', ...
    'Interpreter', 'latex')

yyaxis right
p_n = plot(lambda_t, log(n), ...
    'LineStyle', '-', ...
    'Color', color_n, ...
    'LineWidth', 2);

ylabel('logarithm of abundances $n_t$', 'Interpreter', 'latex')

xlim([3.05 3.1])

xlabel('time-varying reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex')

legend([p_g p_h p_n], ...
       '$\ln(g_t)$', ...
       '$\ln(h_t)$', ...
       '$\ln(n_t)$ (rhs)', ...
       'Interpreter', 'latex', ...
       'Location', 'best', ...
       'FontSize', 8)

ax = gca;
ax.FontSize = 13;
ax.XColor = 'k';
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = color_n;
