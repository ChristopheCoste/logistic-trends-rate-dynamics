%% FigS9_very_fast_trends_around_r_tipping_point.m
% Reproduces Figure S9.
%
% The script compares logistic-map dynamics under continuous environmental
% change for several trend durations T around the r-tipping point r*, which
% corresponds to T = 34 in the manuscript.
%
% Model:
%
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% where lambda_t increases linearly from lambda_start to lambda_end over a
% trend duration T, before remaining constant.
%
% Rows correspond to different values of T. Columns show:
%
%   I:   abundance time series and the environmental trend lambda_t
%   II:  abundance trajectory superimposed on the bifurcation diagram
%   III: cobweb diagram
%
% In the cobweb diagrams, response curves are red, trend dynamics are blue,
% post-trend transient dynamics are green, and asymptotic dynamics are black.

clear; clc; close all;

%% Bifurcation diagram
lambda_grid = 0:0.001:4;
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

%% Trend parameters
lambda_start = 1.001;
lambda_end = 3.9605;
post_trend_duration = 250;

n0 = 1 - 1 / lambda_start;

trend_durations = [15 20 29 33 37];

%% Figure S9
figure
set(gcf, 'papertype', 'A4')
fig = gcf;
fig.PaperSize = [21 29.7];
fig.PaperPosition = [1 1 20 25];

tiledlayout(length(trend_durations), 3, ...
    'TileSpacing', 'compact', ...
    'Padding', 'compact')

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
    plot(n, 'b.', 'LineWidth', 2)
    ylabel('abundance')
    hold on

    yyaxis right
    plot(lambda_t, 'r.', 'LineWidth', 2)
    ylabel('$\lambda_t$', 'Interpreter', 'latex')
    ylim([0 4])
    hold on

    xline(Ttrend, 'c', 'LineWidth', 2)

    xlabel('$t$ (generations)', 'Interpreter', 'latex')
    xlim([0 Ttrend + post_trend_duration])
    title(sprintf('$T=%0d$', Ttrend), 'Interpreter', 'latex')

    %% Column II: trajectory over lambda_t and bifurcation diagram
    nexttile

    p1 = plot(lambda_grid(:), n_bif_plot(:,1), ...
        'k.', 'LineWidth', 2);
    hold on

    plot(lambda_grid(2:end), n_bif_plot(2:end,:), ...
        'k.', 'LineWidth', 2, 'HandleVisibility', 'off')
    hold on

    p2 = plot(lambda_t, n, 'b.', 'LineWidth', 2);

    xlabel('$\lambda_t$', 'Interpreter', 'latex')
    ylabel('abundance')
    title(sprintf('$T=%0d$', Ttrend), 'Interpreter', 'latex')

    %% Column III: cobweb diagram
    nexttile

    n_generations_cobweb = Ttrend + post_trend_duration;
    tspread = 1:n_generations_cobweb;

    xspread = 0:0.00001:1;

    plot(xspread, xspread, 'k', 'LineWidth', 1)
    hold on

    % Dummy handles for possible legend use and to document the line types.
    plot(-1, -1, 'b', 'LineWidth', 3)
    hold on
    plot(-1, -1, 'g', 'LineWidth', 1)
    hold on
    plot(-1, -1, 'k', 'LineWidth', 3)
    hold on

    % Post-trend transient dynamics.
    for t = Ttrend+1:n_generations_cobweb-8
        plot(xspread, lambda_t(t) .* xspread .* (1 - xspread), ...
            'r', 'LineWidth', 1)
        hold on
        plot([n(t) n(t)], [n(t) n(t+1)], ...
            'g', 'LineWidth', 1)
        hold on
        plot([n(t) n(t+1)], [n(t+1) n(t+1)], ...
            'g', 'LineWidth', 1)
        hold on
    end

    % Trend dynamics.
    for t = 1:Ttrend
        plot(xspread, lambda_t(t) .* xspread .* (1 - xspread), ...
            'r', 'LineWidth', 1)
        hold on
        plot([n(t) n(t)], [n(t) n(t+1)], ...
            'b', 'LineWidth', 3)
        hold on
        plot([n(t) n(t+1)], [n(t+1) n(t+1)], ...
            'b', 'LineWidth', 3)
        hold on
    end

    % Asymptotic dynamics.
    for t = n_generations_cobweb-7:n_generations_cobweb
        plot(xspread, lambda_t(t) .* xspread .* (1 - xspread), ...
            'r', 'LineWidth', 1)
        hold on
        plot([n(t) n(t)], [n(t) n(t+1)], ...
            'k', 'LineWidth', 3)
        hold on
        plot([n(t) n(t+1)], [n(t+1) n(t+1)], ...
            'k', 'LineWidth', 3)
        hold on
    end

    xlabel('$n_t$', 'Interpreter', 'latex')
    ylabel('$n_{t+1}$', 'Interpreter', 'latex')

    rr = max(n(tspread)) - min(n(tspread));

    xlim([max(min(n(tspread)) - 0.5 * rr, 0), ...
          min(max(n(tspread)) + 0.5 * rr, 1)])
    ylim([max(min(n(tspread)) - 0.5 * rr, 0), ...
          min(max(n(tspread)) + 0.5 * rr, 1)])

    title(sprintf('$T=%0d$', Ttrend), 'Interpreter', 'latex')
end
