%% Fig7_plot_r_bifurcation_diagram.m
% Plots Fig. 7 from the cached data produced by
% Compute_trend_rate_scan_data.m.
%
% The expected data file is trend_rate_scan_data.mat. It contains the matrix
% trend_rate_scan_data, whose columns correspond to environmental trend
% rates r and whose rows are:
%
%   row 1: trend duration T
%   row 2: environmental rate of change r
%   row 3: generation of first oscillation, t_o(r)
%   row 4: b(r), i.e. lambda_t at first oscillation
%   row 5: generation at which lambda_t crosses 3, t_3(r)
%   row 6: post-trend transient duration, D(r)
%
% To regenerate the cached data from scratch, run
% Compute_trend_rate_scan_data.m first. This can be slow.

clear; clc; close all;

%% Load cached data
this_file = mfilename('fullpath');
this_folder = fileparts(this_file);
data_file = fullfile(this_folder, 'trend_rate_scan_data.mat');

S = load(data_file, 'trend_rate_scan_data');

if ~isfield(S, 'trend_rate_scan_data')
    error('The data file must contain the variable trend_rate_scan_data.')
end

trend_rate_scan_data = S.trend_rate_scan_data;

%% Unpack data
Ttrend = trend_rate_scan_data(1,:);
r = trend_rate_scan_data(2,:);
b_tip = trend_rate_scan_data(4,:);
post_transient_duration = trend_rate_scan_data(6,:);

lambda_start = 1.001;
lambda_end = 3.9605;

% Thresholds separating the four qualitative trend classes.
idx_no_post_transient = find(cumprod(post_transient_duration == 0, "reverse"));
r_breve = r(idx_no_post_transient(1));

r_dagger = (lambda_end - lambda_start) / 240;
r_star = (lambda_end - lambda_start) / 36;

%% Fig. 7: r-bifurcation diagram
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');

figure
set(gcf, 'units', 'normalized', 'outerposition', [0 0 .8 1])

layout = tiledlayout(1,1);
ax1 = axes(layout);
hold(ax1, 'on')
box(ax1, 'off')

% Left axis: b-tipping point b(r).
yyaxis(ax1, 'left')
semilogx(ax1, r, b_tip, 'k.', 'MarkerSize', 15)
p_b = plot(ax1, [nan nan], [nan nan], 'k-', 'LineWidth', 2);

ylabel(ax1, ...
    'b-tipping point ($\lambda_t$ at 1st oscil.): $b(r)$', ...
    'Interpreter', 'latex', 'Color', 'black')
ylim(ax1, [2.4 4])
ax1.YScale = 'linear';
ax1.YColor = 'black';

% Right axis: post-trend transient duration D(r).
yyaxis(ax1, 'right')
semilogx(ax1, r, post_transient_duration, 'r.', 'MarkerSize', 4)
p_D = plot(ax1, [nan nan], [nan nan], 'r-', 'LineWidth', 2);

ylabel(ax1, 'post-trend transient duration: $D(r)$', ...
    'Interpreter', 'latex', 'Color', 'red')
yticks(ax1, [0 200 400 600 800 1000])
ylim(ax1, [-10 1000])
ax1.YScale = 'linear';
ax1.YColor = 'red';

% Class boundaries.
xline(ax1, r_breve, 'b--', 'LineWidth', 2)
xline(ax1, r_dagger, 'b--', 'LineWidth', 2)
xline(ax1, r_star, 'b--', 'LineWidth', 2)

xlabel(ax1, 'environmental rate of change $r$', 'Interpreter', 'latex')
xlim(ax1, [3e-8 3])
ax1.XScale = 'log';
ax1.FontSize = 15;

legend(ax1, [p_b p_D], ...
    {'b-tipping point ($\lambda_t$ at 1st oscil.): $b(r)$', ...
     'post-trend transient duration: $D(r)$ (rhs)'}, ...
    'Interpreter', 'latex', 'Location', 'northwest')

% Bottom-axis ticks and labels.
exp_ticks = 10.^[-7 -5 -3 0 1];
x_ticks = [exp_ticks(1), r_breve, exp_ticks(2), exp_ticks(3), ...
    r_dagger, r_star, exp_ticks(4), exp_ticks(5)];
x_labels = {'$10^{-7}$', '$\breve{r}$', '$10^{-5}$', '$10^{-3}$', ...
    '$r^{\dagger}$', '$r^*$', '$10^{0}$', '$10^{1}$'};

set(ax1, 'XTick', x_ticks, 'XTickLabel', x_labels, ...
    'XColor', 'blue', 'XScale', 'log')

% Labels for qualitative trend regimes.
annotation('textbox', [.04 .375 .3 .3], ...
    'String', 'very slow', 'FitBoxToText', 'on', ...
    'Interpreter', 'latex', 'FontSize', 15, ...
    'Color', 'blue', 'HorizontalAlignment', 'center');

annotation('textbox', [.28 .375 .3 .3], ...
    'String', 'slow', 'FitBoxToText', 'on', ...
    'Interpreter', 'latex', 'FontSize', 15, ...
    'Color', 'blue', 'HorizontalAlignment', 'center');

annotation('textbox', [.564 .375 .3 .3], ...
    'String', 'fast', 'FitBoxToText', 'on', ...
    'Interpreter', 'latex', 'FontSize', 15, ...
    'Color', 'blue', 'HorizontalAlignment', 'center');

annotation('textbox', [.68 .375 .3 .3], ...
    'String', 'very fast', 'FitBoxToText', 'on', ...
    'Interpreter', 'latex', 'FontSize', 15, ...
    'Color', 'blue', 'HorizontalAlignment', 'center');

%% Top axis: trend duration T
ax_top = axes('Position', ax1.Position, ...
    'XAxisLocation', 'top', ...
    'Color', 'none', ...
    'XScale', 'log', ...
    'XDir', 'reverse');

ax_top.YAxis.Visible = 'off';
ax_top.Box = 'off';
ax_top.FontSize = 15;
ax_top.XColor = 'black';

xlim(ax_top, [min(Ttrend) max(Ttrend)])
xlabel(ax_top, 'trend duration $T$', 'Interpreter', 'latex', 'Color', 'black')
