%% Fig2_slow_trend_timeseries.m
% Reproduces the three panels of Fig. 2 for the logistic map under a slow
% linear environmental trend. The reproductive rate increases from
% lambda_0 = 1.001 to lambda_T = 3.9605 over T = 7000 generations, then
% remains constant to show the post-trend transient dynamics.
%
% Panel a: full abundance trajectory during and after the trend.
% Panel b: short zoom around the first oscillation, t_o(r).
% Panel c: wider zoom showing the rapid increase in oscillation amplitude.

clear; clc; close all;

%% Parameters and population projection
Ttrend = 7000;
Tpost  = 500;

lambda_start = 1.001;
lambda_end   = 3.9605;   % final value, chosen in a period-4 window
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
t_lambda3 = find(lambda_t < 3, 1, 'last');

%% Fig. 2a: full time series
figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .9 .9], ...
    'Position', [.1 .1 .8 .8])

ax1 = axes('Position', [.1 .1 .8 .8]);
p1 = plot(ax1, n, 'b.', 'LineWidth', 2);
hold(ax1, 'on')

% Dummy handle used only so that the legend shows a readable blue line,
% while the abundance trajectory itself remains plotted as blue dots.
p1_legend = plot(ax1, [nan nan], [nan nan], 'b-', 'LineWidth', 2);

set(ax1, 'Box', 'off')
ylabel(ax1, 'abundance, $n_t$', 'Interpreter', 'latex')
xlabel(ax1, 'time, $t$', 'Interpreter', 'latex')
xlim(ax1, [0 Ttrend + Tpost])

p2 = xline(ax1, Ttrend, 'k-', 'LineWidth', 2);
p3 = xline(ax1, t_osc, '-', 'Color', [.7 .7 .7], 'LineWidth', 2);
p4 = xline(ax1, t_lambda3, '--', 'Color', 'red', 'LineWidth', 2);
ax1.FontSize = 15;

ax2 = axes('Position', get(ax1, 'Position'), ...
    'XAxisLocation', 'top', ...
    'Color', 'none', ...
    'YColor', 'none');
ax2.XColor = 'red';
ax2.YAxis.Visible = 'off';
xlabel(ax2, 'time-varying reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex', 'Color', 'red')
xlim(ax2, [0 1])

tick_lambdas = [lambda_start, 1.5, 2, 2.5, 3, 3.5, lambda_end];
tick_times = arrayfun(@(x) find(lambda_t <= x, 1, 'last'), tick_lambdas);
xticks(ax2, tick_times / length(lambda_t))
xticklabels(ax2, {'1.001', '1.5', '2', '2.5', '3', '3.5', '3.9605'})
ax2.FontSize = 15;

legend(ax1, [p1_legend p2 p3 p4], ...
    {'$n_t$: abundance dynamics', ...
     '$t=T$: end of environmental trend', ...
     '$t=t_o(r)$: time at first oscillation (delayed bifurcation)', ...
     '$\lambda=3$: constant-environment bifurcation'}, ...
    'Location', 'NorthWest', 'Interpreter', 'latex')

%% Fig. 2c: short zoom around the first oscillation
T1 = t_osc - 15;
T2 = t_osc + 15;

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [.1 .1 .45 .45], ...
    'Position', [.15 .15 .4 .4])

ax1 = axes('Position', [.15 .15 .75 .7]);
plot(ax1, T1:T2, n(T1:T2), 'b', 'LineWidth', 2)
hold(ax1, 'on')
set(ax1, 'Box', 'off')
ylabel(ax1, 'abundance, $n_t$', 'Interpreter', 'latex')
xlabel(ax1, 'time, $t$', 'Interpreter', 'latex')
xlim(ax1, [T1 T2])
xline(ax1, t_osc, '-', 'Color', [.7 .7 .7], 'LineWidth', 2);
ax1.FontSize = 10;

ax2 = axes('Position', get(ax1, 'Position'), ...
    'XAxisLocation', 'top', ...
    'Color', 'none', ...
    'YColor', 'none');
ax2.XColor = 'red';
ax2.YAxis.Visible = 'off';
xlabel(ax2, 'time-varying reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex', 'Color', 'red')
xlim(ax2, [0 1])

tick_times = T1:10:T2;
xticks(ax2, (tick_times - T1) / (T2 - T1 + 1))
xticklabels(ax2, compose('%.3f', lambda_t(tick_times)))
ax2.FontSize = 10;

%% Fig. 2b: wider zoom around the first oscillation
T1 = t_osc - 10;
T2 = t_osc + 80;

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [.1 .1 .45 .45], ...
    'Position', [.15 .15 .4 .4])

ax1 = axes('Position', [.15 .15 .75 .7]);
plot(ax1, T1:T2, n(T1:T2), 'b', 'LineWidth', 2)
hold(ax1, 'on')
set(ax1, 'Box', 'off')
ylabel(ax1, 'abundance, $n_t$', 'Interpreter', 'latex')
xlabel(ax1, 'time, $t$', 'Interpreter', 'latex')
xlim(ax1, [T1 T2])
xline(ax1, t_osc, '-', 'Color', [.7 .7 .7], 'LineWidth', 2);
ax1.FontSize = 10;

ax2 = axes('Position', get(ax1, 'Position'), ...
    'XAxisLocation', 'top', ...
    'Color', 'none', ...
    'YColor', 'none');
ax2.XColor = 'red';
ax2.YAxis.Visible = 'off';
xlabel(ax2, 'time-varying reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex', 'Color', 'red')
xlim(ax2, [0 1])

tick_times = T1:20:T2;
xticks(ax2, (tick_times - T1) / (T2 - T1 + 1))
xticklabels(ax2, compose('%.3f', lambda_t(tick_times)))
ax2.FontSize = 10;
