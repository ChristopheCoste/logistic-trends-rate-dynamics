%% FigS11_noisy_stationary_logistic_autocorrelation.m
% Reproduces Figure S11.
%
% The script studies a stationary noisy logistic map:
%
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% where lambda_t = lambda_bar + epsilon_t. The same stochastic sequence
% epsilon_t is generated once and used for every value of lambda_bar.
% This keeps the noise realisation identical across the parameter scan. The noise has standard deviation sigma_e and optional lag-1
% autocorrelation.
%
% For each value of the mean reproductive rate lambda_bar, the script
% simulates an abundance trajectory and computes the lag-1 autocorrelation
% of abundance after discarding an initial transient.
%
% The autocorrelation is computed directly, without using the Econometrics
% Toolbox.

clear; clc; close all;

%% Parameters
sigma_e = 0.1;
noise_autocorrelation = 0.0;

lambda_mean_values = 0:0.01:4;

n0 = 0.01;
tmax = 4000;
transient_cutoff = 100;

autocorrelation_values = zeros(size(lambda_mean_values));

%% Shared noise sequence
white_noise = sigma_e * randn(1, tmax);
white_noise(1) = 0;

colored_noise = zeros(1, tmax);
colored_noise(1) = white_noise(1);

for t = 1:tmax-1
    colored_noise(t+1) = noise_autocorrelation * colored_noise(t) + ...
        sqrt(1 - noise_autocorrelation^2) * white_noise(t+1);
end

noise = colored_noise;

%% Simulate noisy stationary environments
for i_lambda = 1:length(lambda_mean_values)

    lambda_mean = lambda_mean_values(i_lambda);

    lambda_t = lambda_mean + noise;
    lambda_t = max(min(lambda_t, 4), 0);

    n = zeros(1, tmax + 1);
    n(1) = n0;

    for t = 1:tmax
        n(t+1) = lambda_t(t) * n(t) * (1 - n(t));
    end

    n_analysis = n(transient_cutoff:tmax);

    % Lag-1 autocorrelation, matching the standard autocovariance
    % normalization used by autocorr: gamma(1) / gamma(0).
    n_centered = n_analysis - mean(n_analysis);
    autocorrelation_values(i_lambda) = ...
        sum(n_centered(1:end-1) .* n_centered(2:end)) / ...
        sum(n_centered.^2);
end

%% Figure S11
figure
plot(lambda_mean_values, autocorrelation_values, 'LineWidth', 2)

xlabel('$\bar{\lambda}$', 'Interpreter', 'latex')
ylabel('$\rho(\bar{\lambda})$', 'Interpreter', 'latex')

ax = gca;
ax.FontSize = 13;
