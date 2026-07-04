%% Compute_trend_rate_scan_data.m
% Computes the shared trend-rate scan data used by several figure scripts.
%
% This script scans environmental trend durations T from 1 generation to
% 1e8 generations. For each T, it simulates the logistic map under a linear
% increase in lambda_t:
%
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% and records quantities that describe delayed oscillation and post-trend
% transient dynamics.
%
% The output file is:
%
%   trend_rate_scan_data.mat
%
% It contains the matrix trend_rate_scan_data, whose columns correspond to
% environmental trend rates r and whose rows are:
%
%   row 1: trend duration T
%   row 2: environmental rate of change r
%   row 3: generation of first oscillation, t_o(r)
%   row 4: b(r), i.e. lambda_t at first oscillation
%   row 5: generation at which lambda_t crosses 3, t_3(r)
%   row 6: post-trend transient duration, D(r)
%
% The cached data are used by:
%
%   Fig7_plot_r_bifurcation_diagram.m
%   FigS7_first_oscillation_generation_vs_rate.m
%   FigS8_delay_and_remaining_trend_vs_rate.m
%
% You do not need to run this script if trend_rate_scan_data.mat is already
% available in the same folder as the plotting scripts. Regenerating the
% data from scratch can be slow.
%
% At completion, the script closes the waitbar and prints the output file
% name and elapsed runtime in the MATLAB command window.

clear; clc; close all;

run_timer = tic;

%% Parameters
lambda_start = 1.001;
lambda_end = 3.9605;

stable_time = 1200;
distance_threshold = 0.0001;

max_duration = 1e8;
duration_scale = 1.001;

n0 = 1 - 1 / lambda_start;

n_steps = floor(log(max_duration) / log(duration_scale)) + 1;
trend_rate_scan_data = nan(6, n_steps);

%% Scan trend durations
h = waitbar(0, 'Computing trend-rate scan data...');
cleanup_waitbar = onCleanup(@() close_waitbar_if_valid(h));

for k = 1:n_steps
    log_duration_index = k - 1;
    waitbar(k / n_steps, h, ...
        sprintf('Computing trend-rate scan data: %d of %d', k, n_steps))

    Ttrend = floor(exp(log_duration_index * log(duration_scale)));
    r = (lambda_end - lambda_start) / Ttrend;

    lambda_trend = lambda_start:r:lambda_end;
    lambda_t = [lambda_trend, lambda_end * ones(1, stable_time)];

    n = zeros(1, Ttrend + stable_time + 1);
    n(1) = n0;

    for t = 1:Ttrend
        n(t+1) = lambda_trend(t) * n(t) * (1 - n(t));
    end

    for t = Ttrend+1:Ttrend+stable_time
        n(t+1) = lambda_end * n(t) * (1 - n(t));
    end

    % Duration of the post-trend transient, D(r), measured by convergence
    % to the final period-4 cycle.
    n_post = n(Ttrend+1:Ttrend+stable_time);
    n_post_diff = n_post(1+4:end) - n_post(1:end-4);

    if all(abs(n_post_diff) < distance_threshold)
        post_trend_duration = 0;
    else
        last_large_difference = find(abs(n_post_diff) > distance_threshold, ...
            1, 'last');
        post_trend_duration = last_large_difference;
    end

    % First decline in abundance: onset of oscillations, t_o(r).
    first_oscillation = find(diff(n) < 0, 1, 'first');

    if isempty(first_oscillation)
        t_osc = NaN;
        lambda_osc = NaN;
    else
        t_osc = first_oscillation;
        lambda_osc = lambda_t(first_oscillation);
    end

    t3 = (3 - lambda_start) / r;

    trend_rate_scan_data(:,k) = ...
        [Ttrend; r; t_osc; lambda_osc; t3; post_trend_duration];
end

%% Save shared data file
row_descriptions = {
    '1: trend duration T'
    '2: environmental rate of change r'
    '3: generation of first oscillation t_o(r)'
    '4: b(r), i.e. lambda_t at first oscillation'
    '5: generation at which lambda_t crosses 3, t_3(r)'
    '6: post-trend transient duration D(r)'
};

this_folder = fileparts(mfilename('fullpath'));
data_file = fullfile(this_folder, 'trend_rate_scan_data.mat');

elapsed_time_seconds = toc(run_timer);
run_completed_at = datetime('now');

save(data_file, ...
    'trend_rate_scan_data', 'row_descriptions', ...
    'lambda_start', 'lambda_end', 'stable_time', ...
    'distance_threshold', 'max_duration', 'duration_scale', ...
    'run_completed_at', 'elapsed_time_seconds')

close_waitbar_if_valid(h)
clear cleanup_waitbar

fprintf('\nCompute_trend_rate_scan_data.m completed successfully.\n')
fprintf('Output file: %s\n', data_file)
fprintf('Elapsed time: %.2f seconds (%.2f hours).\n\n', ...
    elapsed_time_seconds, elapsed_time_seconds / 3600)

%% Local function
function close_waitbar_if_valid(h)
    if exist('h', 'var') && isgraphics(h)
        try
            close(h)
        catch
            % The waitbar may already have been closed manually.
        end
    end
end
