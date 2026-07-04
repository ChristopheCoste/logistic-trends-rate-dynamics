%% FigS15_repelling_boundaries_lag_dynamics.m
% Reproduces Figure S15.
%
% The script studies the lag between the realised abundance n_t and the
% moving equilibrium n_hat_t in the logistic map under a linear environmental
% trend:
%
%   n_{t+1} = lambda_t * n_t * (1 - n_t)
%
% with lambda_t increasing from lambda_start to lambda_end at constant rate
% r. The lag is
%
%   h_t = n_t - n_hat_t
%
% where n_hat_t = 1 - 1/lambda_t. The figure compares the realised lag h_t,
% a perturbed trajectory h_2(t), and the analytical boundary curves l_1 and
% l_2(t) used in the manuscript.

clear; clc; close all;

%% Environmental trend
r = 1.5e-4;

lambda_start = 1.001;
lambda_end = 3.9605;

n0 = 1 - 1 / lambda_start;

Ttrend = floor((lambda_end - lambda_start) / r);

lambda_t = lambda_start:r:lambda_end;
n_hat = 1 - 1 ./ lambda_t;

%% Perturbation
lambda_perturbation = 2.92;
t_perturbation = find(lambda_t > lambda_perturbation, 1, 'first');

%% Simulate trajectories
n = zeros(1, Ttrend + 1);
n(1) = n0;

n_perturbed = zeros(1, Ttrend + 1);
n_perturbed(1) = n0;

for t = 1:Ttrend
    n(t+1) = lambda_t(t) * n(t) * (1 - n(t));
end

for t = 1:Ttrend
    if t == t_perturbation
        n_perturbed(t+1) = n_hat(t+1);
    else
        n_perturbed(t+1) = lambda_t(t) * n_perturbed(t) * ...
            (1 - n_perturbed(t));
    end
end

%% Lag and boundary curves
h = n - n_hat;
h_perturbed = n_perturbed - n_hat;

l2 = -r ./ (lambda_t.^2);
h_hat = l2 .* (-1 ./ (1 - lambda_t));

l1 = zeros(size(lambda_t));

%% Figure S15
figure

p_h = plot(nan, nan, 'b', 'LineWidth', 2);
hold on
p_h2 = plot(nan, nan, 'r', 'LineWidth', 2);
hold on

p_hhat = plot(lambda_t, h_hat, 'g', 'LineWidth', 5);
hold on

p_boundaries = plot(lambda_t, l2, 'k', 'LineWidth', 2);
hold on
plot(lambda_t, l1, 'k', 'LineWidth', 2, 'HandleVisibility', 'off')
hold on

plot(lambda_t, h_perturbed, 'r.', 'LineWidth', 2)
hold on
plot(lambda_t, h, 'b.', 'LineWidth', 2)

legend([p_h p_h2 p_hhat p_boundaries], ...
       '$h_t$', ...
       '$h_2(t)$', ...
       '$\hat{h}_t$', ...
       'boundaries $l_1$ and $l_2(t)$', ...
       'Interpreter', 'latex', ...
       'Location', 'northwest', ...
       'FontSize', 8)

xlim([2.85 3.1])
ylim([-0.5e-4 0.25e-4])

xlabel('time-varying reproductive rate, $\lambda_t$', ...
    'Interpreter', 'latex')
ylabel('lag, $h_t$', 'Interpreter', 'latex')

ax = gca;
ax.FontSize = 13;
