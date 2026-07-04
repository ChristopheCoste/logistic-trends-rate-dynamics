%% Fig5_very_slow_trend.m
% Reproduces the three panels of Fig. 5 for the logistic map under a very
% slow linear environmental trend.
%
% The reproductive rate increases from lambda_0 = 1.001 to lambda_T = 3.9605
% over T = 1e8 generations, then remains constant to show the absence of a
% visible post-trend transient.
%
% Panel a: full superimposition diagram.
% Panel b: zoom around the b-tipping point b(r) = lambda_{t_o}.
% Panel c: end of the trend and immediate convergence to the asymptotic cycle.
%
% Note: this script stores the full trajectory for T = 1e8 generations and
% can therefore require substantial memory and runtime.

clear; clc; close all;

%% Constant-environment bifurcation diagram
lambda_step = 0.0001;
lambda_grid = 1:lambda_step:4;

n0_bif = 0.1;
T_bif = 10000;
T_keep = 200;

n_bif = zeros(length(lambda_grid), T_bif + 1);
n_bif(:,1) = n0_bif;

for i = 1:length(lambda_grid)
    lambda = lambda_grid(i);

    for t = 1:T_bif
        n_bif(i,t+1) = lambda * n_bif(i,t) * (1 - n_bif(i,t));
    end
end

n_bif_plot = n_bif(:,end-T_keep:end);

%% Logistic map under a very slow environmental trend
Ttrend = 100000000;
Tpost = 500;

lambda_start = 1.001;
lambda_end = 3.9605;   % final value, chosen in a period-4 window
beta = (lambda_end - lambda_start) / Ttrend;

n0 = 1 - 1 / lambda_start;
lambda_trend = lambda_start:beta:lambda_end;

n = zeros(1, Ttrend + Tpost + 1);
n(1) = n0;

for t = 1:Ttrend
    n(t+1) = lambda_trend(t) * n(t) * (1 - n(t));
end

for t = Ttrend+1:Ttrend+Tpost
    n(t+1) = lambda_end * n(t) * (1 - n(t));
end

lambda_t = [lambda_trend, lambda_end * ones(1, Tpost)];

% First decline in abundance: onset of oscillations, t_o(r).
t_osc = find(diff(n) < 0, 1, 'first');
lambda_osc = lambda_t(t_osc);

%% Fig. 5: very slow trend panels
figure
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])
layout = tiledlayout(8,3, 'TileSpacing', 'compact', 'Padding', 'compact');

%% Fig. 5a: full superimposition diagram
ax1 = nexttile(layout, 4, [7 2]);
hold(ax1, 'on')
box(ax1, 'off')

% Dummy handles for a clean legend.
p_bif = plot(ax1, [nan nan], [nan nan], 'k-', 'LineWidth', 2);
p_traj = plot(ax1, [nan nan], [nan nan], 'b-', 'LineWidth', 2);
p_eq = plot(ax1, [nan nan], [nan nan], 'r-', 'LineWidth', 2);

% Plot the background first, then the moving equilibrium and realised trajectory.
plot(ax1, lambda_grid(:), n_bif_plot, 'k.', 'LineWidth', 1, ...
    'HandleVisibility', 'off')
plot(ax1, lambda_t, 1 - 1 ./ lambda_t, 'r.', 'LineWidth', 2, ...
    'HandleVisibility', 'off')
plot(ax1, lambda_t, n, 'b.', 'LineWidth', 1, ...
    'HandleVisibility', 'off')

p_tip = xline(ax1, lambda_osc, '-', 'Color', [.7 .7 .7], 'LineWidth', 2);

ylabel(ax1, 'abundance, $n_t$', 'Interpreter', 'latex')
xlabel(ax1, '(time-varying) reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex', 'Color', 'red')
xlim(ax1, [1 4])
ax1.XColor = 'red';
ax1.FontSize = 14;
title(ax1, '(a)', 'Interpreter', 'latex')

legend(ax1, [p_bif p_traj p_eq p_tip], ...
    {'bifurcation diagram', ...
     '$n_t$: abundances', ...
     '$\hat{n}_t$: moving equilibrium', ...
     '$b(r)=\lambda_{t_o}$: b-tipping point'}, ...
    'Location', 'NorthWest', 'Interpreter', 'latex')

% Top axis: chronological time in units of 10^7 generations.
ax1_top = axes('Position', ax1.Position, 'XAxisLocation', 'top', ...
    'Color', 'none');
ax1_top.YAxis.Visible = 'off';
ax1_top.Box = 'off';
ax1_top.FontSize = 14;
xlim(ax1_top, ax1.XLim)

time_ticks_a = 0:20000000:Ttrend;
lambda_ticks_a = lambda_start + beta * time_ticks_a;
xticks(ax1_top, lambda_ticks_a)
xticklabels(ax1_top, string(time_ticks_a / 1e7))
xlabel(ax1_top, 'chronological time, $t$ ($\times 10^7$)', ...
    'Interpreter', 'latex')

%% Fig. 5b: zoom around the b-tipping point
ax2 = nexttile(layout, 6, [3 1]);
hold(ax2, 'on')
box(ax2, 'off')

T1 = t_osc - 50000;
T2 = t_osc + 40000;

idx1 = find(lambda_grid > lambda_t(T1), 1, 'first');
idx2 = find(lambda_grid > lambda_t(T2), 1, 'first');

plot(ax2, lambda_t(T1:T2), 1 - 1 ./ lambda_t(T1:T2), ...
    'r.', 'LineWidth', 1)
plot(ax2, lambda_grid(idx1:idx2), n_bif_plot(idx1:idx2,:), ...
    'k', 'LineWidth', 2, 'HandleVisibility', 'off')
plot(ax2, lambda_t(T1:T2), n(T1:T2), ...
    'b.', 'LineWidth', 2)

ylabel(ax2, 'abundance, $n_t$', 'Interpreter', 'latex')
xlabel(ax2, '(time-varying) reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex', 'Color', 'red')
xlim(ax2, [lambda_t(T1) lambda_t(T2)])
ax2.XColor = 'red';
ax2.FontSize = 10;
title(ax2, '(b)', 'Interpreter', 'latex')

ax2_top = axes('Position', ax2.Position, 'XAxisLocation', 'top', ...
    'Color', 'none');
ax2_top.YAxis.Visible = 'off';
ax2_top.Box = 'off';
ax2_top.FontSize = 10;
xlim(ax2_top, [T1 T2])
xlabel(ax2_top, 'chronological time, $t$', 'Interpreter', 'latex')

%% Fig. 5c: end of trend and absence of post-trend transient
ax3 = nexttile(layout, 18, [3 1]);
hold(ax3, 'on')
box(ax3, 'off')

T1 = Ttrend - 80;
T2 = Ttrend + 80;

p_traj_c = plot(ax3, [nan nan], [nan nan], 'b-', 'LineWidth', 2);
plot(ax3, T1:T2, n(T1:T2), 'b.', 'LineWidth', 2, ...
    'HandleVisibility', 'off')
p_end = xline(ax3, Ttrend, 'k-', 'LineWidth', 2);

ylabel(ax3, 'abundance, $n_t$', 'Interpreter', 'latex')
xlabel(ax3, 'chronological time, $t$', 'Interpreter', 'latex')
xlim(ax3, [T1 T2])
ax3.FontSize = 10;
title(ax3, '(c)', 'Interpreter', 'latex')

legend(ax3, [p_traj_c p_end], ...
    {'$n_t$: abundances', '$t=T$: end of trend'}, ...
    'Interpreter', 'latex', 'Location', 'NorthWest')

ax3_top = axes('Position', ax3.Position, 'XAxisLocation', 'top', ...
    'Color', 'none');
ax3_top.XColor = 'red';
ax3_top.YAxis.Visible = 'off';
ax3_top.Box = 'off';
ax3_top.FontSize = 10;
xlim(ax3_top, ax3.XLim)

lambda_tick_positions_c = [Ttrend - 80, Ttrend, Ttrend + 80];
lambda_tick_labels_c = min(lambda_end, lambda_start + beta * (lambda_tick_positions_c - 1));
xticks(ax3_top, lambda_tick_positions_c)
xticklabels(ax3_top, compose('%.6f', lambda_tick_labels_c))
xlabel(ax3_top, 'time-varying reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex', 'Color', 'red')
