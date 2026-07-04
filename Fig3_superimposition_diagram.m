%% Fig3_superimposition_diagram.m
% Reproduces the two panels of Fig. 3 for the logistic map under a slow
% linear environmental trend.
%
% The script first computes the constant-environment bifurcation diagram,
% then simulates a slow trend in the reproductive rate from lambda_0 = 1.001
% to lambda_T = 3.9605 over T = 7000 generations.
%
% Panel a: superimposition diagram, with the abundance trajectory plotted
%          against the time-varying reproductive rate lambda_t.
% Panel b: zoom around the b-tipping point b(r) = lambda_{t_o}.

clear; clc; close all;

%% Constant-environment bifurcation diagram
lambda_step = 0.001;
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

%% Logistic map under a slow environmental trend
Ttrend = 7000;
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

%% Fig. 3a: superimposition diagram
figure
set(gcf, 'units', 'normalized', 'outerposition', [0 0 .6 .6], ...
    'position', [.1 .1 .8 .8])

ax1 = axes('Position', [.12 .12 .76 .74]);
hold(ax1, 'on')
box(ax1, 'off')

% Dummy handles for a clean legend.
p_bif = plot(ax1, [nan nan], [nan nan], 'k-', 'LineWidth', 2);
p_traj = plot(ax1, [nan nan], [nan nan], 'b-', 'LineWidth', 2);
p_eq = plot(ax1, [nan nan], [nan nan], 'r-', 'LineWidth', 2);

% Moving equilibrium, constant-environment bifurcation diagram, and realised trajectory.
plot(ax1, lambda_t, 1 - 1 ./ lambda_t, 'r.', 'LineWidth', 1, ...
    'HandleVisibility', 'off')
plot(ax1, lambda_grid(:), n_bif_plot, 'k.', 'LineWidth', 2, ...
    'HandleVisibility', 'off')
plot(ax1, lambda_t, n, 'b.', 'LineWidth', 2, ...
    'HandleVisibility', 'off')

p_tip = xline(ax1, lambda_osc, '-', 'Color', [.7 .7 .7], 'LineWidth', 2);

ylabel(ax1, 'abundance, $n_t$', 'Interpreter', 'latex')
xlabel(ax1, '(time-varying) reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex', 'Color', 'red')
xlim(ax1, [1 4])
ax1.FontSize = 12;
ax1.XColor = 'red';

% Top axis: chronological time corresponding to lambda_t during the trend.
% Tick positions are converted from chronological time to lambda_t units so
% that the top axis matches the manuscript figure.
ax2 = axes('Position', ax1.Position, 'XAxisLocation', 'top', ...
    'Color', 'none');
ax2.YAxis.Visible = 'off';
ax2.Box = 'off';
ax2.FontSize = 12;
xlim(ax2, ax1.XLim)

time_ticks = 1000:1000:Ttrend;
lambda_tick_positions = lambda_start + beta * time_ticks;
xticks(ax2, lambda_tick_positions)
xticklabels(ax2, string(time_ticks))
xlabel(ax2, 'chronological time, $t$', 'Interpreter', 'latex')

legend(ax1, [p_bif p_traj p_eq p_tip], ...
    {'bifurcation diagram', ...
     '$n_t$: abundance dynamics', ...
     '$\hat{n}_t$: equilibrium', ...
     '$b(r)=\lambda_{t_o}$: b-tipping point'}, ...
    'Location', 'NorthWest', 'Interpreter', 'latex')

%% Fig. 3b: zoom around the b-tipping point
T1 = t_osc - 10;
T2 = t_osc + 80;

idx1 = find(lambda_grid > lambda_t(T1), 1, 'first');
idx2 = find(lambda_grid > lambda_t(T2), 1, 'first');

figure
set(gcf, 'units', 'normalized', 'outerposition', [0 0 .4 .4], ...
    'position', [.1 .1 .8 .8])

ax1 = axes('Position', [.14 .14 .76 .72]);
hold(ax1, 'on')
box(ax1, 'off')

plot(ax1, lambda_grid(idx1:idx2), n_bif_plot(idx1:idx2,:), ...
    'k', 'LineWidth', 2, 'HandleVisibility', 'off')
plot(ax1, lambda_t(T1:T2), 1 - 1 ./ lambda_t(T1:T2), ...
    'r', 'LineWidth', 2)
plot(ax1, lambda_t(T1:T2), n(T1:T2), ...
    'b-', 'LineWidth', 2)
xline(ax1, lambda_osc, '-', 'Color', [.7 .7 .7], 'LineWidth', 2)

xlim(ax1, [3.14 3.18])
xticks(ax1, 3.14:0.005:3.18)
ax1.FontSize = 10;
ax1.XColor = 'red';

% Top axis: chronological time for the zoomed interval.
% As above, chronological ticks are converted into lambda_t positions.
ax2 = axes('Position', ax1.Position, 'XAxisLocation', 'top', ...
    'Color', 'none');
ax2.YAxis.Visible = 'off';
ax2.Box = 'off';
ax2.FontSize = 10;
xlim(ax2, ax1.XLim)

time_ticks_zoom = 5060:10:5160;
lambda_tick_positions_zoom = lambda_start + beta * time_ticks_zoom;
xticks(ax2, lambda_tick_positions_zoom)
xticklabels(ax2, string(time_ticks_zoom))
