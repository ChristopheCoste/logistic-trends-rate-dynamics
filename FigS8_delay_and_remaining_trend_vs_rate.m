%% FigS8_delay_and_remaining_trend_vs_rate.m
% Reproduces Figure S8 from the shared trend-rate scan data.
%
% The expected data file is trend_rate_scan_data.mat, produced by
% Compute_trend_rate_scan_data.m. It contains the matrix
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
% Figure S8 shows two chronological quantities as functions of r:
%
%   t_o(r) - t_3(r): delay in oscillations after lambda_t reaches 3
%   T - t_o(r):      duration of the portion of the trend after the first
%                    oscillation
%
% Both quantities are plotted on a log-log scale.

clear; clc; close all;

set(groot, 'defaultAxesTickLabelInterpreter', 'latex');

%% Load shared data
this_file = mfilename('fullpath');
this_folder = fileparts(this_file);
data_file = fullfile(this_folder, 'trend_rate_scan_data.mat');

if ~isfile(data_file)
    error(['Could not find ', data_file, ...
           '. Run Compute_trend_rate_scan_data.m first, or place ', ...
           'trend_rate_scan_data.mat in the same folder as this script.'])
end

S = load(data_file, 'trend_rate_scan_data');

if ~isfield(S, 'trend_rate_scan_data')
    error(['The file ', data_file, ...
           ' does not contain the variable trend_rate_scan_data.'])
end

trend_rate_scan_data = S.trend_rate_scan_data;

%% Extract quantities
lambda_start = 1.001;
lambda_end = 3.9605;

T = trend_rate_scan_data(1,:);
r = trend_rate_scan_data(2,:);
t_o = trend_rate_scan_data(3,:);
t_3 = floor(trend_rate_scan_data(5,:));
D = trend_rate_scan_data(6,:);

delay_after_lambda_3 = t_o - t_3;
remaining_trend_after_oscillation = T - t_o;

% Values equal to zero cannot be displayed on a log scale.
delay_after_lambda_3(delay_after_lambda_3 <= 0) = NaN;
remaining_trend_after_oscillation(remaining_trend_after_oscillation <= 0) = NaN;

very_slow_boundary_index = find(cumprod(D == 0, "reverse"), 1, 'first');
r_very_slow_boundary = r(very_slow_boundary_index);

r_slow_fast_boundary = (lambda_end - lambda_start) / 240;
r_fast_veryfast_boundary = (lambda_end - lambda_start) / 36;

%% Figure S8
figure
set(gcf, 'units', 'normalized', 'outerposition', [0.2 0.2 0.6 0.55])

loglog(r, delay_after_lambda_3, 'LineWidth', 2)
hold on
loglog(r, remaining_trend_after_oscillation, 'LineWidth', 2)
hold on

xline(r_very_slow_boundary, 'k--', 'LineWidth', 1)
hold on
xline(r_slow_fast_boundary, 'k--', 'LineWidth', 1)
hold on
xline(r_fast_veryfast_boundary, 'k--', 'LineWidth', 1)

legend('$t_o-t_3$', ...
       '$T-t_o$', ...
       'Interpreter', 'latex', ...
       'Location', 'northeast', ...
       'FontSize', 8)

ylabel('$t$', 'Interpreter', 'latex')
xlabel('environmental rate of change $r$', 'Interpreter', 'latex')
xlim([min(r) max(r)])

%% Custom x-axis labels
power_ticks = -7:2:-3;
base_ticks = 10 .^ power_ticks;

x_ticks = [base_ticks(1), ...
           r_very_slow_boundary, ...
           base_ticks(2:3), ...
           r_slow_fast_boundary, ...
           r_fast_veryfast_boundary, ...
           10^0, ...
           10^1];

x_tick_labels = {'$10^{-7}$', ...
                 '$\breve{r}$', ...
                 '$10^{-5}$', ...
                 '$10^{-3}$', ...
                 '$r^{\dagger}$', ...
                 '$r^*$', ...
                 '$10^{0}$', ...
                 '$10^{1}$'};

set(gca, 'XTick', x_ticks, 'XTickLabel', x_tick_labels)

%% Regime labels
y_text = 10^5.5;

text(10^-7.4, y_text, 'very slow', ...
    'Interpreter', 'latex', 'FontSize', 12)

text(10^-4.3, y_text, 'slow', ...
    'Interpreter', 'latex', 'FontSize', 12)

text(10^-1.8, y_text, 'fast', ...
    'Interpreter', 'latex', 'FontSize', 12)

text(10^-0.8, y_text, 'very fast', ...
    'Interpreter', 'latex', 'FontSize', 12)
