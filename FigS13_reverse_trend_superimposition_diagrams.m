%% FigS13_reverse_trend_superimposition_diagrams.m
% Reproduces Figure S13.
%
% The script studies the logistic map under reverse environmental trends:
%
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% where lambda_t decreases linearly from lambda_start = 3.9605 to
% lambda_end = 1.001 over different trend durations T, before remaining
% constant at lambda_end.
%
% Rows correspond to different values of T. Columns show:
%
%   I:  abundance time series and the environmental trend lambda_t
%   II: abundance trajectory superimposed on the bifurcation diagram

clear; clc; close all;

%% Bifurcation diagram
lambda_grid = 1:0.001:4;
n0_bif = 0.1;
T_bif = 10000;
T_keep = 200;

n_bif = zeros(length(lambda_grid), T_bif + 1);
n_bif(:,1) = n0_bif;

for i_lambda = 1:length(lambda_grid)
    lambda = lambda_grid(i_lambda);

    for t = 1:T_bif
        n_bif(i_lambda,t+1) = lambda * n_bif(i_lambda,t) * ...
            (1 - n_bif(i_lambda,t));
    end
end

n_bif_plot = n_bif(:,end-T_keep:end);

%% Reverse-trend parameters
lambda_start = 3.9605;
lambda_end = 1.001;

post_trend_duration = 500;
trend_durations = [20000 2000 400 5];

n0 = 1 - 1 / lambda_start;

%% Figure S13
figure
set(gcf, 'units', 'normalized', 'outerposition', [0.05 0.05 0.9 0.9])

tiledlayout(4, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

for i_trend = 1:length(trend_durations)

    Ttrend = trend_durations(i_trend);
    r = (lambda_end - lambda_start) / Ttrend;

    lambda_trend = lambda_start:r:lambda_end;
    lambda_t = [lambda_trend, lambda_end * ones(1, post_trend_duration)];

    n = zeros(1, Ttrend + post_trend_duration + 1);
    n(1) = n0;

    for t = 1:Ttrend
        n(t+1) = lambda_trend(t) * n(t) * (1 - n(t));
    end

    for t = Ttrend+1:Ttrend+post_trend_duration
        n(t+1) = lambda_end * n(t) * (1 - n(t));
    end

    %% Column I: dynamics over chronological time
    nexttile

    yyaxis left
    p_n = plot(n, 'b.', 'LineWidth', 1);
    ylabel('$n_t$', 'Interpreter', 'latex')
    hold on

    yyaxis right
    p_lambda = plot(lambda_t, 'r', 'LineWidth', 2);
    ylabel('$\lambda_t$', 'Interpreter', 'latex')
    ylim([0 4])
    hold on

    p_T = xline(Ttrend, 'k', 'LineWidth', 1);

    xlabel('$t$', 'Interpreter', 'latex')
    xlim([0 Ttrend + post_trend_duration])
    title(sprintf('$r=%.1d$', r), 'Interpreter', 'latex')

    legend([p_n p_lambda p_T], ...
           '$n_t$', ...
           '$\lambda_t$ (rhs)', ...
           '$T$ (end of trend)', ...
           'Location', 'NorthEast', ...
           'Interpreter', 'latex', ...
           'FontSize', 8)

    %% Column II: trajectory over lambda_t and bifurcation diagram
    nexttile

    p_bif = plot(lambda_grid(:), n_bif_plot(:,1), ...
        'k.', 'LineWidth', 2);
    hold on

    plot(lambda_grid(2:end), n_bif_plot(2:end,:), ...
        'k.', 'LineWidth', 2, 'HandleVisibility', 'off')
    hold on

    p_eq = plot(lambda_t, 1 - 1 ./ lambda_t, ...
        'g', 'LineWidth', 2);
    hold on

    p_traj = plot(lambda_t, n, ...
        'b.', 'LineWidth', 2);

    ylabel('$n_t$', 'Interpreter', 'latex')
    xlabel('$\lambda_t$', 'Interpreter', 'latex')
    title(sprintf('$r=%.1d$', r), 'Interpreter', 'latex')

    legend([p_bif p_traj p_eq], ...
           'bifurcation diagram', ...
           '$n(\lambda_t)$', ...
           '$\hat{n}_t$', ...
           'Location', 'NorthWest', ...
           'Interpreter', 'latex', ...
           'FontSize', 8)
end
