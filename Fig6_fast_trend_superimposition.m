%% Fig6_fast_trend_superimposition.m
% Reproduces Fig. 6: superimposition diagram for the logistic map under a
% fast linear environmental trend.
%
% The reproductive rate increases from lambda_0 = 1.001 to lambda_T = 3.9605
% over T = 225 generations, then remains constant. The figure overlays the
% realised abundance trajectory on the constant-environment bifurcation
% diagram, using lambda_t as the lower x-axis and chronological time as the
% upper x-axis.

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

%% Logistic map under a fast environmental trend
Ttrend = 225;
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

%% Fig. 6: fast trend superimposition diagram
figure
set(gcf, 'units', 'normalized', 'outerposition', [0 0 .8 1])

hold on
box off

% Dummy handles for a clean legend.
p_bif = plot([nan nan], [nan nan], 'k-', 'LineWidth', 2);
p_traj = plot([nan nan], [nan nan], 'b-', 'LineWidth', 2);
p_eq = plot([nan nan], [nan nan], 'r-', 'LineWidth', 2);
p_tip_legend = plot([nan nan], [nan nan], '-', ...
    'Color', [.7 .7 .7], 'LineWidth', 2);

% Plot in the same visual order as the published figure:
% red moving equilibrium in the background, then black bifurcation diagram,
% then the blue realised trajectory, and finally the grey b-tipping line.
plot(lambda_t, 1 - 1 ./ lambda_t, 'r', 'LineWidth', 6, ...
    'HandleVisibility', 'off')
plot(lambda_grid(:), n_bif_plot, 'k.', 'LineWidth', 2, ...
    'HandleVisibility', 'off')
plot(lambda_t, n, 'b', 'LineWidth', 2, ...
    'HandleVisibility', 'off')

xline(lambda_osc, '-', 'Color', [.7 .7 .7], 'LineWidth', 4, ...
    'HandleVisibility', 'off')

ylabel('abundances, $n_t$', 'Interpreter', 'latex')
xlabel('(time-varying) reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex', 'Color', 'red')

ax1 = gca;
ax1.FontSize = 15;
ax1.XColor = 'red';
xlim([1 4])

legend([p_bif p_traj p_eq p_tip_legend], ...
    {'bifurcation diagram', ...
     '$n_t$: abundance dynamics', ...
     '$\hat{n}_t$: equilibrium', ...
     '$b(r)=\lambda_{t_o}$: b-tipping point'}, ...
    'Location', 'NorthWest', 'Interpreter', 'latex')

% Top axis: chronological time during the environmental trend.
ax2 = axes('Position', get(ax1, 'Position'), ...
    'XAxisLocation', 'top', ...
    'Color', 'none');
ax2.XColor = 'black';
ax2.YAxis.Visible = 'off';
ax2.FontSize = 15;
xlabel(ax2, 'chronological time, $t$', ...
    'Interpreter', 'latex', 'Color', 'black')

% Top-axis scaling between chronological time and lambda_t.
xlim(ax2, [1 floor(Ttrend * 4 / lambda_end)])
