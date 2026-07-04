%% Fig9_noisy_trend.m
% Reproduces Fig. 9: logistic-map dynamics under a noisy environmental trend.
%
% The reproductive rate follows a linear trend in its mean value,
% \bar{\lambda}_t, from lambda_0 = 1.001 to lambda_T = 3.9605 over
% T = 1000 generations. Short-term stochastic fluctuations are then added
% around this trend with different standard deviations and autocorrelations.
%
% Each panel overlays the realised abundance dynamics against the mean
% reproductive rate \bar{\lambda}_t on the constant-environment bifurcation
% diagram.
%
% The six panels are arranged as a 2-by-3 grid.
%
% NOTE: these are stochastic simulations. Because the random-number seed is
% not fixed here, the exact noisy realisations will differ between runs and
% will not exactly match the particular realisation shown in the paper.

clear; clc; close all;

%% Constant-environment bifurcation diagram
lambda_step = 0.001;
lambda_grid = 1:lambda_step:4;

n0_bif = 0.1;
T_bif = 10000;
T_keep = 1000;

n_bif = zeros(length(lambda_grid), T_bif + 1);
n_bif(:,1) = n0_bif;

for i = 1:length(lambda_grid)
    lambda = lambda_grid(i);

    for t = 1:T_bif
        n_bif(i,t+1) = lambda * n_bif(i,t) * (1 - n_bif(i,t));
    end
end

n_bif_plot = n_bif(:,end-T_keep:end);

%% Noisy environmental trend parameters
lambda_start = 1.001;
lambda_end = 3.9605;
n0 = 1 - 1 / lambda_start;

Ttrend = 1000;
Tpost = 500;
Tmax = Ttrend + Tpost;

noise_parameters = [
    0.00  0
    0.01  0
    0.01  0.975
    0.05  0
    0.05  0.975
    0.15  0
];

panel_labels = ["(a) ", "(b) ", "(c) ", "(d) ", "(e) ", "(f) "];

lambda_rate = (lambda_end - lambda_start) / Ttrend;

lambda_mean = zeros(1, Tmax);
lambda_mean(1:Ttrend) = (1:Ttrend) * lambda_rate + lambda_start;
lambda_mean(Ttrend+1:Tmax) = lambda_mean(Ttrend);

% Stochastic lambda is generated during the full trend and half of the
% post-trend period.
Tnoise = Tmax - Tpost / 2;

%% Fig. 9: noisy trend panels
figure
set(gcf, 'PaperType', 'A4');

for iNoise = 1:size(noise_parameters, 1)
    sigma_e = noise_parameters(iNoise, 1);
    rho_e = noise_parameters(iNoise, 2);

    %% Generate autocorrelated environmental noise
    white_noise = sigma_e * randn(1, Tnoise);
    white_noise(1) = 0;

    coloured_noise = zeros(1, Tnoise);
    coloured_noise(1) = white_noise(1);

    for t = 1:Tnoise-1
        coloured_noise(t+1) = rho_e * coloured_noise(t) + ...
            sqrt(1 - rho_e^2) * white_noise(t+1);
    end

    noise = coloured_noise;

    lambda_noisy = lambda_mean;
    lambda_noisy(1:Tnoise) = lambda_mean(1:Tnoise) + noise;
    lambda_noisy = min(max(lambda_noisy, 0), 4);

    %% Project abundance dynamics
    n = zeros(1, Tmax + 1);
    n(1) = n0;

    for t = 1:Tmax
        n(t+1) = lambda_noisy(t) * n(t) * (1 - n(t));
    end

    %% Plot panel
    subplot(2, 3, iNoise)

    scatter(lambda_grid, n_bif_plot, 'k', '.')
    hold on
    scatter(lambda_mean, n(1:Tmax), 'b', '.')

    p_bif = plot([nan nan], [nan nan], 'k', 'LineWidth', 2);
    p_dyn = plot([nan nan], [nan nan], 'b', 'LineWidth', 2);

    leg = legend([p_bif p_dyn], ...
        {'bifurcation diagram', 'abundances, $n(\bar{\lambda}_t)$'}, ...
        'Location', 'northwest', 'Interpreter', 'latex');
    set(leg, 'Box', 'off');

    xlabel('reproductive rate, $\bar{\lambda}_t$', 'Interpreter', 'latex')
    ylabel('abundances', 'Interpreter', 'latex')

    panel_title = sprintf('%s $\\sigma_e=%.2f$ and $\\rho(\\epsilon_t)=%.3g$', ...
        panel_labels(iNoise), sigma_e, rho_e);
    title(panel_title, 'Interpreter', 'latex')

    ax = gca;
    ax.FontSize = 12;
    xlim([1 4])
end
