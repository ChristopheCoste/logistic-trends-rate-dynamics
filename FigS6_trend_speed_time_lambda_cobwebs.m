%% FigS6_trend_speed_time_lambda_cobwebs.m
% Reproduces Figure S6: abundance time series, trajectories over the
% bifurcation diagram, and cobweb diagrams for four environmental trend
% speeds in the logistic map.
%
% Model:
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% Rows:
%   a: very slow trend
%   b: slow trend
%   c: fast trend
%   d: step change
%
% Columns:
%   I:   chronological time series
%   II:  trajectory over lambda_t with the constant-environment bifurcation diagram
%   III: cobweb diagram

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
lambda_grid_more_than_one = lambda_grid(lambda_grid > 1);

%% Trend parameters
lambda_start = 1.001;
lambda_end = 3.9605;
post_trend_duration = 500;
n0 = 1 - 1 / lambda_start;

trend_durations = [100000000, 7000, 225, 1];
row_labels = {'a', 'b', 'c', 'd'};

lambda_inspection = 3.144;
lambda_inspection_title = 3.146;

%% Figure
figure
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])
tiledlayout(4, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

for i_trend = 1:length(trend_durations)

    Ttrend = trend_durations(i_trend);
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

    %% Column I: dynamics over chronological time
    nexttile

    yyaxis left
    plot(n, 'b.', 'LineWidth', 2)
    ylabel('$n_t$', 'Interpreter', 'latex')
    hold on

    yyaxis right
    plot(lambda_t, 'r.', 'LineWidth', 2)
    ylabel('$\lambda_t$', 'Interpreter', 'latex')
    ylim([0 4])
    hold on

    xline(Ttrend, 'k', 'LineWidth', 2)

    xlabel('$t$', 'Interpreter', 'latex')
    xlim([0 Ttrend + post_trend_duration])
    title(sprintf('(%sI) r=%.1d', row_labels{i_trend}, beta), ...
        'Interpreter', 'latex')

    if i_trend == 4
        legend('$n_t$', ...
               '$\lambda_t$ (rhs y-axis)', ...
               '$t=T$ (end of trend)', ...
               'Location', 'NorthEast', ...
               'Interpreter', 'latex', ...
               'FontSize', 8)
    else
        legend('$n_t$', ...
               '$\lambda_t$ (rhs y-axis)', ...
               '$t=T$ (end of trend)', ...
               'Location', 'NorthWest', ...
               'Interpreter', 'latex', ...
               'FontSize', 8)
    end

    %% Column II: trajectory over lambda_t and bifurcation diagram
    nexttile

    if i_trend < 4
        p0 = plot(lambda_grid_more_than_one(:), ...
            1 - 1 ./ lambda_grid_more_than_one(:), ...
            'r.', 'LineWidth', 2);
        hold on
    end

    p1 = plot(lambda_grid(:), n_bif_plot(:,1), 'k.', 'LineWidth', 2);
    hold on
    plot(lambda_grid(2:end), n_bif_plot(2:end,:), ...
        'k.', 'LineWidth', 2, 'HandleVisibility', 'off')
    hold on

    p2 = plot(lambda_t, n, 'b.', 'LineWidth', 2);

    xlabel('$\lambda_t$', 'Interpreter', 'latex')
    ylabel('$n_t$', 'Interpreter', 'latex')
    title(sprintf('(%sII) r=%.1d', row_labels{i_trend}, beta), ...
        'Interpreter', 'latex')

    if i_trend < 4
        legend([p0 p1 p2], ...
            'mov. eq.', ...
            'bif. diag.', ...
            '$n_t$', ...
            'Location', 'NorthWest', ...
            'Interpreter', 'latex', ...
            'FontSize', 8)
    else
        legend([p1 p2], ...
            'bif. diag.', ...
            '$n_t$', ...
            'Location', 'NorthWest', ...
            'Interpreter', 'latex', ...
            'FontSize', 8)
    end

    %% Column III: cobweb diagram
    nexttile

    if i_trend < 4
        n_generations_cobweb = 15;

        ind = find(lambda_t > lambda_inspection);
        tspread_start = ind(1) - 1;
        tspread = tspread_start:tspread_start + n_generations_cobweb;

        xspread = 0:0.00001:1;

        plot(xspread, xspread, 'k', 'LineWidth', 1)
        hold on

        for t = tspread
            plot(xspread, lambda_t(t) .* xspread .* (1 - xspread), ...
                'r', 'LineWidth', 1)
            hold on
            plot([n(t) n(t)], [n(t) n(t+1)], 'b', 'LineWidth', 1)
            hold on
            plot([n(t) n(t+1)], [n(t+1) n(t+1)], ...
                'b', 'LineWidth', 1)
            hold on
        end

        xlabel('$n_t$', 'Interpreter', 'latex')
        ylabel('$n_{t+1}$', 'Interpreter', 'latex')
        legend('$n_{t+1}=n_t$', ...
               '$n_{t+1}=f_t(n_t)$', ...
               '$n_t$', ...
               'Location', 'northwest', ...
               'Interpreter', 'latex', ...
               'FontSize', 8)

        rr = max(n(tspread)) - min(n(tspread));

        if i_trend == 1
            expansion = 2;
        elseif i_trend == 2
            expansion = 1;
        else
            expansion = 0.1;
        end

        xlim([max(min(n(tspread)) - expansion * rr, 0), ...
              min(max(n(tspread)) + expansion * rr, 1)])
        ylim([max(min(n(tspread)) - expansion * rr, 0), ...
              min(max(n(tspread)) + expansion * rr, 1)])

        title(sprintf('(%sIII) r=%.1d, $%1d$ time-steps from $\\lambda_t=%.3f$', ...
            row_labels{i_trend}, beta, n_generations_cobweb, ...
            lambda_inspection_title), ...
            'Interpreter', 'latex')

    else
        n_generations_cobweb = 500;

        ind = find(lambda_t > lambda_inspection);
        tspread_start = ind(1) - 1;
        tspread = tspread_start:tspread_start + n_generations_cobweb;

        xspread = 0:0.01:1;

        plot(xspread, xspread, 'k', 'LineWidth', 1)
        hold on

        for t = tspread(1:end-100)
            plot(xspread, lambda_t(t) .* xspread .* (1 - xspread), ...
                'r', 'LineWidth', 1)
            hold on
            plot([n(t) n(t)], [n(t) n(t+1)], 'b', 'LineWidth', 1)
            hold on
            plot([-2 -2], 'm', 'LineWidth', 1)
            hold on
            plot([n(t) n(t+1)], [n(t+1) n(t+1)], ...
                'b', 'LineWidth', 1)
            hold on
        end

        for t = tspread(end-99:end)
            plot(xspread, lambda_t(t) .* xspread .* (1 - xspread), ...
                'r', 'LineWidth', 1)
            hold on
            plot([n(t) n(t)], [n(t) n(t+1)], 'm', 'LineWidth', 3)
            hold on
            plot([n(t) n(t+1)], [n(t+1) n(t+1)], ...
                'm', 'LineWidth', 3)
            hold on
        end

        xlabel('$n_t$', 'Interpreter', 'latex')
        ylabel('$n_{t+1}$', 'Interpreter', 'latex')
        legend('$n_{t+1}=n_t$', ...
               '$n_{t+1}=f_t(n_t)$', ...
               'asymptotic $n_t$', ...
               'transient $n_t$', ...
               'Location', 'northwest', ...
               'Interpreter', 'latex', ...
               'FontSize', 8)

        rr = max(n(tspread)) - min(n(tspread));

        xlim([max(min(n(tspread)) - rr, 0), ...
              min(max(n(tspread)) + rr, 1)])
        ylim([max(min(n(tspread)) - rr, 0), ...
              min(max(n(tspread)) + rr, 1)])

        title(sprintf('(%sIII) r=%.1d, $%1d$ post-trend time-steps', ...
            row_labels{i_trend}, beta, n_generations_cobweb), ...
            'Interpreter', 'latex')
    end
end
