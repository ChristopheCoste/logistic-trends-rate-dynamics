%% FigS7_first_oscillation_generation_vs_rate.m
% Reproduces Figure S7 from the shared trend-rate scan data.
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
% Figure S7 shows t_o(r), t_3(r), and T as functions of r. The two panels
% differ only by the range of r displayed.

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

r_slow_fast_boundary = (lambda_end - lambda_start) / 240;
r_fast_veryfast_boundary = (lambda_end - lambda_start) / 36;

%% Figure S7
figure
set(gcf, 'units', 'normalized', 'outerposition', [0.15 0.2 0.7 0.45])

tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

plot_s7_panel(r, ...
              t_o, ...
              t_3, ...
              T, ...
              r_slow_fast_boundary, ...
              r_fast_veryfast_boundary, ...
              [(lambda_end - lambda_start) / 350, lambda_end - lambda_start], ...
              '(a)')

plot_s7_panel(r, ...
              t_o, ...
              t_3, ...
              T, ...
              r_slow_fast_boundary, ...
              r_fast_veryfast_boundary, ...
              [min(r) max(r)], ...
              '(b)')

%% Local plotting function
function plot_s7_panel(r, ...
                       t_o, ...
                       t_3, ...
                       T, ...
                       r_slow_fast_boundary, ...
                       r_fast_veryfast_boundary, ...
                       x_limits, ...
                       panel_label)

    nexttile

    loglog(r, t_o, 'LineWidth', 2)
    hold on
    loglog(r, t_3, 'LineWidth', 2)
    hold on
    loglog(r, T, 'LineWidth', 2)
    hold on

    xline(r_slow_fast_boundary, 'g', 'LineWidth', 1)
    hold on
    xline(r_fast_veryfast_boundary, 'k', 'LineWidth', 3)

    xlabel('$r$', 'Interpreter', 'latex')
    ylabel('generation', 'Interpreter', 'latex')
    xlim(x_limits)

    title(panel_label, 'Interpreter', 'latex')

    legend('$t_o$', ...
           '$t_3$', ...
           '$T$', ...
           '$r=r^{\dagger}$ S-F trends border', ...
           '$r=r^*$ r-tipping point (F-VF border)', ...
           'Interpreter', 'latex', ...
           'Location', 'northeast', ...
           'FontSize', 8)
end
