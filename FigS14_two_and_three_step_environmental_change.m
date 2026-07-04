%% FigS14_two_and_three_step_environmental_change.m
% Reproduces Figure S14.
%
% The script studies the logistic map under very fast environmental changes:
%
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% The reproductive rate lambda_t increases linearly from lambda_start to
% lambda_end over either T = 2 or T = 3 generations, then remains constant
% at lambda_end for 500 generations.
%
% Rows correspond to the two values of T:
%
%   top row:    T = 2
%   bottom row: T = 3
%
% Columns show:
%
%   I:  abundance time series and the environmental trend lambda_t
%   II: cobweb diagram, with transient dynamics in blue and the last
%       100 generations, representing asymptotic dynamics, in magenta

clear; clc; close all;

%% Parameters
lambda_start = 1.001;
lambda_end = 3.9605;

post_trend_duration = 500;
trend_durations = [2 3];

n0 = 1 - 1 / lambda_start;

%% Figure S14
figure
set(gcf, 'units', 'inches', ...
    'position', [0 0 16 10], ...
    'paperpositionmode', 'auto')

tiledlayout(length(trend_durations), 2, ...
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
    p_n = plot(n, 'b.', 'LineWidth', 2);
    ylabel('abundance')
    hold on

    yyaxis right
    p_lambda = plot(lambda_t, 'r.', 'LineWidth', 2);
    ylabel('$\lambda_t$', 'Interpreter', 'latex')
    ylim([0 4])
    hold on

    p_T = xline(Ttrend, 'c', 'LineWidth', 2);

    xlabel('$t$ (generations)', 'Interpreter', 'latex')
    xlim([0 Ttrend + post_trend_duration])
    title(sprintf('$T=%d$', Ttrend), 'Interpreter', 'latex')

    legend([p_n p_lambda p_T], ...
           '$n_t$', ...
           '$\lambda_t$ (rhs)', ...
           '$T$ (end of trend)', ...
           'Location', 'northeast', ...
           'Interpreter', 'latex', ...
           'FontSize', 8)

    %% Column II: cobweb diagram
    nexttile

    lambda_inspection = 3.002;
    n_generations_cobweb = 500;

    first_after_inspection = find(lambda_t > lambda_inspection, 1, 'first');
    tspread_start = first_after_inspection - 1;
    tspread = tspread_start:tspread_start + n_generations_cobweb;

    xspread = 0:0.01:1;

    p_identity = plot(xspread, xspread, 'k', 'LineWidth', 1);
    hold on

    p_response = plot(xspread, lambda_t(tspread_start) .* ...
        xspread .* (1 - xspread), 'r', 'LineWidth', 1);
    hold on

    p_transient = plot(nan, nan, 'b', 'LineWidth', 1);
    hold on

    p_asymptotic = plot(nan, nan, 'm', 'LineWidth', 3);
    hold on

    for t = tspread(1:end-100)
        plot(xspread, lambda_t(t) .* xspread .* (1 - xspread), ...
            'r', 'LineWidth', 1)
        hold on
        plot([n(t) n(t)], [n(t) n(t+1)], ...
            'b', 'LineWidth', 1)
        hold on
        plot([n(t) n(t+1)], [n(t+1) n(t+1)], ...
            'b', 'LineWidth', 1)
        hold on
    end

    for t = tspread(end-99:end)
        plot(xspread, lambda_t(t) .* xspread .* (1 - xspread), ...
            'r', 'LineWidth', 1)
        hold on
        plot([n(t) n(t)], [n(t) n(t+1)], ...
            'm', 'LineWidth', 3)
        hold on
        plot([n(t) n(t+1)], [n(t+1) n(t+1)], ...
            'm', 'LineWidth', 3)
        hold on
    end

    xlabel('$n_t$', 'Interpreter', 'latex')
    ylabel('$n_{t+1}$', 'Interpreter', 'latex')
    title(sprintf('$T=%d$', Ttrend), 'Interpreter', 'latex')

    legend([p_identity p_response p_transient p_asymptotic], ...
           '$n_{t+1}=n_t$', ...
           '$n_{t+1}=f(n_t)$ response curves', ...
           '$n_t$, transient dynamics', ...
           '$n_t$, asymptotic dynamics', ...
           'Location', 'northwest', ...
           'Interpreter', 'latex', ...
           'FontSize', 8)

    rr = max(n(tspread)) - min(n(tspread));

    xlim([max(min(n(tspread)) - rr, 0), ...
          min(max(n(tspread)) + rr, 1)])
    ylim([max(min(n(tspread)) - rr, 0), ...
          min(max(n(tspread)) + rr, 1)])
end
