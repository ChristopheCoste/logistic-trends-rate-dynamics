%% Fig10_prey_predator_trend_classes.m
% Reproduces the plotted panels of Fig. 10.
%
% The model is a prey-predator system with logistic prey growth and a
% Holling type-II functional response. The predator death rate d_t declines
% linearly from d_initial to d_final over a trend duration T, and then
% remains constant at d_final.
%
% For each trend duration, the script produces three panels:
%   I   abundance dynamics through chronological time,
%   II  superimposition on the bifurcation diagram along the changing d_t,
%   III phase diagram.
%
% Row and column labels can be added outside MATLAB when assembling the
% final multi-panel figure.

clear; clc; close all;

%% Model parameters
params.r = 0.1;     % prey growth rate at low density and without predators
params.h = 3;       % handling time
params.b = 0.2;     % conversion rate
params.a = 0.4;     % attack rate, scaled by prey carrying capacity

d_initial = 0.02;
d_final = 0.002;

%% Trend classes
trend_durations = [750000, 75000, 7500, 20];
post_trend_durations = [30000, 30000, 40000, 10000];

row_labels = {'a', 'b', 'c', 'd'};

%% Constant-environment bifurcation diagram
last_points = 400;
d_grid = 0:0.0002:0.04;
d_plot_max_index = floor(length(d_grid) / 2);

prey_bif = zeros(last_points, length(d_grid));
pred_bif = zeros(last_points, length(d_grid));

for iD = 1:length(d_grid)
    d_constant = d_grid(iD);

    t0 = 0;
    t_final = 5000;
    y0 = 0.01 * ones(2,1);

    sol_bif = ode45(@(t,y) prey_predator_constant_d(t, y, params, d_constant), ...
        [t0 t_final], y0);

    y_eval = deval(sol_bif, t0:t_final);
    prey_bif(:,iD) = y_eval(1,end-last_points+1:end);
    pred_bif(:,iD) = y_eval(2,end-last_points+1:end);
end

d_bif_plot = d_grid(1:d_plot_max_index);
prey_bif_plot = prey_bif(:,1:d_plot_max_index);
pred_bif_plot = pred_bif(:,1:d_plot_max_index);

%% Figure 10
figure
set(gcf, 'units', 'normalized', 'outerposition', 1.2 * [0 0 .71 1])

for iTrend = 1:length(trend_durations)
    Ttrend = trend_durations(iTrend);
    Tpost = post_trend_durations(iTrend);
    time_total = Ttrend + Tpost;

    d_of_t = @(t) d_initial + max(min(t, Ttrend), 0) * ...
        (d_final - d_initial) / Ttrend;

    prey_equilibrium = @(t) d_of_t(t) ./ ...
        (params.a * (params.b - params.h .* d_of_t(t)));

    pred_equilibrium = @(t) params.r .* prey_equilibrium(t) .* ...
        (1 - prey_equilibrium(t)) .* ...
        (1 + params.a * params.h .* prey_equilibrium(t)) ./ ...
        (params.a .* prey_equilibrium(t));

    y0 = [prey_equilibrium(0); pred_equilibrium(0)];

    sol = ode45(@(t,y) prey_predator_timevarying_d(t, y, params, d_of_t), ...
        [0 time_total], y0);

    time_eval = 0:time_total;
    solution_eval = deval(sol, time_eval);

    equilibrium_time = 1:time_total;
    trend_end_index = Ttrend + 1;

    %% Column I: abundance dynamics through time
    ax1 = subplot(4, 3, (iTrend - 1) * 3 + 1);
    hold(ax1, 'on')

    plot(ax1, sol.x, sol.y(1,:), 'b', 'LineWidth', 2)
    plot(ax1, sol.x, sol.y(2,:), 'r', 'LineWidth', 2)
    plot(ax1, equilibrium_time, prey_equilibrium(equilibrium_time), ...
        'k', 'LineWidth', 1)
    plot(ax1, equilibrium_time, pred_equilibrium(equilibrium_time), ...
        'k', 'LineWidth', 1)

    ylim(ax1, [0 0.5])
    xlim(ax1, [0 time_total])

    ylabel(ax1, 'abundances', 'Interpreter', 'latex')
    xlabel(ax1, 'time, $t$', 'Interpreter', 'latex')

    yyaxis(ax1, 'right')
    plot(ax1, equilibrium_time, d_of_t(equilibrium_time), '--', ...
        'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 1)
    ylabel(ax1, 'death rate, $d_t$', 'Interpreter', 'latex')
    ax1.YColor = [0.4660, 0.6740, 0.1880];

    yyaxis(ax1, 'left')
    title(ax1, sprintf('(%sI) T=%.0f', row_labels{iTrend}, Ttrend), ...
        'Interpreter', 'latex')

    %% Column II: superimposition with bifurcation diagram
    ax2 = subplot(4, 3, (iTrend - 1) * 3 + 2);
    hold(ax2, 'on')

    scatter(ax2, d_bif_plot, prey_bif_plot, '.', ...
        'MarkerEdgeColor', [0.3010 0.7450 0.9330])
    scatter(ax2, d_bif_plot, pred_bif_plot, '.', ...
        'MarkerEdgeColor', [0.9290 0.6940 0.1250])

    if iTrend == length(trend_durations)
        plot(ax2, d_of_t(time_eval), solution_eval(1,:), 'b.', 'LineWidth', 2)
        plot(ax2, d_of_t(time_eval), solution_eval(2,:), 'r.', 'LineWidth', 2)
    else
        plot(ax2, d_of_t(time_eval), solution_eval(1,:), 'b', 'LineWidth', 2)
        plot(ax2, d_of_t(time_eval), solution_eval(2,:), 'r', 'LineWidth', 2)
    end

    plot(ax2, d_of_t(equilibrium_time), prey_equilibrium(equilibrium_time), ...
        'k', 'LineWidth', 1)
    plot(ax2, d_of_t(equilibrium_time), pred_equilibrium(equilibrium_time), ...
        'k', 'LineWidth', 1)

    xlabel(ax2, 'death rate, $d_t$', 'Interpreter', 'latex')
    ylabel(ax2, 'abundances', 'Interpreter', 'latex')
    title(ax2, sprintf('(%sII) T=%.0f', row_labels{iTrend}, Ttrend), ...
        'Interpreter', 'latex')

    %% Column III: phase diagram
    ax3 = subplot(4, 3, (iTrend - 1) * 3 + 3);
    hold(ax3, 'on')

    plot(ax3, solution_eval(1,1:trend_end_index), ...
        solution_eval(2,1:trend_end_index), 'b', ...
        'LineWidth', trend_phase_line_width(iTrend))

    plot(ax3, solution_eval(1,trend_end_index:end), ...
        solution_eval(2,trend_end_index:end), ...
        'Color', [.6 .6 .6])

    plot(ax3, solution_eval(1,end-1000:end), ...
        solution_eval(2,end-1000:end), 'k', 'LineWidth', 1)

    plot(ax3, prey_equilibrium(equilibrium_time), ...
        pred_equilibrium(equilibrium_time), 'g', 'LineWidth', 0.5)

    ylim(ax3, [0.1 0.45])

    xlabel(ax3, '$n_1(t)$', 'Interpreter', 'latex')
    ylabel(ax3, '$n_2(t)$', 'Interpreter', 'latex')
    title(ax3, sprintf('(%sIII) T=%.0f', row_labels{iTrend}, Ttrend), ...
        'Interpreter', 'latex')
end

%% Local functions
function yp = prey_predator_timevarying_d(t, y, params, d_of_t)
    yp = [
        params.r * y(1) * (1 - y(1)) - ...
            y(2) * y(1) * params.a / (1 + params.a * params.h * y(1));

        params.b * y(2) * y(1) * params.a / ...
            (1 + params.a * params.h * y(1)) - d_of_t(t) * y(2)
    ];
end

function yp = prey_predator_constant_d(~, y, params, d_constant)
    yp = [
        params.r * y(1) * (1 - y(1)) - ...
            y(2) * y(1) * params.a / (1 + params.a * params.h * y(1));

        params.b * y(2) * y(1) * params.a / ...
            (1 + params.a * params.h * y(1)) - d_constant * y(2)
    ];
end

function lw = trend_phase_line_width(iTrend)
    if iTrend <= 2
        lw = 0.1;
    else
        lw = 2;
    end
end
