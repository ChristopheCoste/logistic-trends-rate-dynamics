%% Fig8_trend_class_examples.m
% Reproduces the four actual plot panels of Fig. 8 for the logistic map, as separate figures.
%
% The script builds the four superimposition-style panels corresponding to:
%   (a) very slow trend: T = 6e6 generations
%   (b) slow trend:      T = 3000 generations
%   (c) fast trend:      T = 207 generations
%   (d) very fast trend: T = 16 generations
%
% In each panel, the lower x-axis is chronological time t and the upper
% x-axis is the time-varying reproductive rate lambda_t. The figure shows:
%   - the moving equilibrium (red),
%   - the bifurcation diagram projected onto the time axis (black),
%   - the realised abundance dynamics (blue),
%   - the b-tipping time t_o (grey),
%   - the end of the environmental trend T (green).

clear; clc; close all;

%% Common parameters
lambda_start = 1.001;
lambda_end = 3.9605;    % final value, chosen in a period-4 window

n0_bif = 0.1;
n0 = 1 - 1 / lambda_start;

lambda_step = 0.001;
lambda_grid = lambda_start:lambda_step:lambda_end;

T_bif = 10000;
T_keep = 200;

trend_durations = [6000000, 3000, 207, 16];
panel_titles = { ...
    'Very Slow Trend ($T=6\times 10^6$ generations)', ...
    'Slow Trend (T=3000 generations)', ...
    'Fast Trend (T=207 generations)', ...
    'Very Fast Trend (T=16 generations)'};
panel_labels = {'(a)', '(b)', '(c)', '(d)'};

%% Constant-environment bifurcation diagram
n_bif = zeros(length(lambda_grid), T_bif + 1);
n_bif(:,1) = n0_bif;

for i = 1:length(lambda_grid)
    lambda = lambda_grid(i);

    for t = 1:T_bif
        n_bif(i,t+1) = lambda * n_bif(i,t) * (1 - n_bif(i,t));
    end
end

n_bif_plot = n_bif(:,end-T_keep:end);

%% Figure 8: four trend-class panels, plotted as separate figures
% Each trend class is plotted in a separate figure window.
for iT = 1:length(trend_durations)
    figure
    set(gcf, 'units', 'normalized', 'outerposition', [0.25 0.15 0.45 0.55])
    Ttrend = trend_durations(iT);
    Tpost = floor(Ttrend / 4);

    beta = (lambda_end - lambda_start) / Ttrend;
    lambda_trend = lambda_start:beta:lambda_end;
    lambda_t = [lambda_trend, lambda_end * ones(1, Tpost)];

    n = zeros(1, Ttrend + Tpost + 1);
    n(1) = n0;

    for t = 1:Ttrend
        n(t+1) = lambda_trend(t) * n(t) * (1 - n(t));
    end

    for t = Ttrend+1:Ttrend+Tpost
        n(t+1) = lambda_end * n(t) * (1 - n(t));
    end

    % First decline in abundance: onset of oscillations, t_o.
    first_decline = find(diff(n) < 0, 1, 'first');
    if isempty(first_decline)
        t_osc = Ttrend;
    else
        t_osc = min(first_decline - 1, Ttrend);
    end

    % Project the bifurcation diagram onto chronological time.
    time_bif = (1:size(n_bif_plot,1)) * (Ttrend / size(n_bif_plot,1));

    ax = axes('Position', [.14 .15 .78 .68]);
    hold(ax, 'on')
    box(ax, 'off')

    % Dummy handles for legend.
    p_bif = plot(ax, [nan nan], [nan nan], 'k-', 'LineWidth', 2);
    p_eq = plot(ax, [nan nan], [nan nan], 'r-', 'LineWidth', 2);
    p_dyn = plot(ax, [nan nan], [nan nan], 'b-', 'LineWidth', 2);
    p_tip = plot(ax, [nan nan], [nan nan], '-', 'Color', [.7 .7 .7], 'LineWidth', 2);
    p_end = plot(ax, [nan nan], [nan nan], 'g-', 'LineWidth', 2);

    % Plot order chosen to match the manuscript visuals.
    plot(ax, 0:Ttrend, 1 - 1 ./ lambda_t(1:Ttrend+1), 'r', 'LineWidth', 4, ...
        'HandleVisibility', 'off')
    plot(ax, time_bif, n_bif_plot(:,1), 'k.', 'LineWidth', 2, ...
        'HandleVisibility', 'off')
    plot(ax, time_bif(2:end), n_bif_plot(2:end,:), 'k.', 'LineWidth', 2, ...
        'HandleVisibility', 'off')
    if iT <= 2
        plot(ax, 0:Ttrend+Tpost, n, 'b.', 'MarkerSize', 6, ...
            'HandleVisibility', 'off')
    else
        plot(ax, 0:Ttrend+Tpost, n, 'b', 'LineWidth', 2, ...
            'HandleVisibility', 'off')
    end
    xline(ax, t_osc, '-', 'Color', [.7 .7 .7], 'LineWidth', 3, ...
        'HandleVisibility', 'off')
    xline(ax, Ttrend, 'g-', 'LineWidth', 3, 'HandleVisibility', 'off')

    ylabel(ax, 'abundances, $n_t$', 'Interpreter', 'latex')
    xlabel(ax, 'chronological time, $t$', 'Interpreter', 'latex', 'Color', 'black')
    xlim(ax, [0 Ttrend + Tpost])
    ax.XColor = 'black';
    ax.FontSize = 10;

    panel_title = sprintf('%s %s', panel_labels{iT}, panel_titles{iT});

    % Top axis: lambda_t.
    ax_top = axes('Position', ax.Position, ...
        'XAxisLocation', 'top', ...
        'Color', 'none');
    ax_top.XColor = 'red';
    ax_top.YAxis.Visible = 'off';
    ax_top.Box = 'off';
    ax_top.FontSize = 10;
    xlim(ax_top, [0 Ttrend + Tpost])

    lambda_tick_values = [1, 1.5, 2, 2.5, 3, 3.5, lambda_end];
    lambda_tick_positions = [0, ...
        ((lambda_tick_values(2:end-1) - lambda_start) / (lambda_end - lambda_start)) * Ttrend, ...
        Ttrend, Ttrend + Tpost];
    lambda_tick_labels = {'1', '1.5', '2', '2.5', '3', '3.5', '3.9605', '3.9605'};

    xticks(ax_top, lambda_tick_positions)
    xticklabels(ax_top, lambda_tick_labels)
    xlabel(ax_top, '(time-varying) reproductive rate, $\lambda_t$', ...
        'Interpreter', 'latex', 'Color', 'red')

    % Add the panel title as a figure-level annotation so it remains visible
    % above the top axis and its tick labels.
    annotation('textbox', [0.14 0.94 0.78 0.045], ...
        'String', panel_title, ...
        'Interpreter', 'latex', ...
        'EdgeColor', 'none', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', 11);

    legend(ax, [p_bif p_eq p_dyn p_tip p_end], ...
        {'bifurcation diagram', ...
         '$\hat{n}_t$: equilibrium', ...
         '$n_t$: abundance dynamics', ...
         '$t=t_o$: b-tipping point', ...
         '$t=T$: end of trend'}, ...
        'Location', 'northwest', 'Interpreter', 'latex', 'FontSize', 8)
end
