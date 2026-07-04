%% Fig1_timeseries.m
% Surrounding panels of Figure 1: example logistic-map time series.
% The script plots abundance trajectories for selected constant lambda
% values illustrating different dynamical regimes around the bifurcation diagram.

clear all; clc; close all;

tmax = 60;

figure;

%% lambda = 1.5: stable equilibrium with monotonic approach
subplot(2,3,1);

lam = 1.5;
nvec = zeros(1,tmax);
nvec(1) = 0.001;

for t = 2:tmax
    nvec(t) = lam*nvec(t-1)*(1 - nvec(t-1));
end

plot(1:tmax, nvec, 'LineWidth', 1, 'Color', 'b');
xlabel('time, $t$', 'Interpreter', 'latex');
ylabel('abundance, $n_t$', 'Interpreter', 'latex');
title(sprintf('$\\lambda={%0.4f}$', lam), 'Interpreter', 'latex');
ylim([-.1 1.1]);

%% lambda = 2.9: stable equilibrium with damped oscillations
subplot(2,3,2);

lam = 2.9;
nvec = zeros(1,tmax);
nvec(1) = 0.001;

for t = 2:tmax
    nvec(t) = lam*nvec(t-1)*(1 - nvec(t-1));
end

plot(1:tmax, nvec, 'LineWidth', 1, 'Color', 'magenta');
xlabel('time, $t$', 'Interpreter', 'latex');
ylabel('abundance,  $n_t$', 'Interpreter', 'latex');
title(sprintf('$\\lambda={%0.4f}$', lam), 'Interpreter', 'latex');
ylim([-.1 1.1]);

%% lambda = 3.9605: 4-generation asymptotic cycle after transient
subplot(2,3,3);

lam = 3.9605;
nvec = zeros(1,tmax);
nvec(1) = 0.4;

for t = 2:tmax
    nvec(t) = lam*nvec(t-1)*(1 - nvec(t-1));
end

plot(1:tmax, nvec, 'LineWidth', 1, 'Color', 'red');
xlabel('time, $t$', 'Interpreter', 'latex');
ylabel('abundance,  $n_t$', 'Interpreter', 'latex');
title(sprintf('$\\lambda={%0.4f}$', lam), 'Interpreter', 'latex');
ylim([-.1 1.1]);

%% lambda = 3.8: chaotic dynamics
subplot(2,3,4);

lam = 3.8;
nvec = zeros(1,tmax);
nvec(1) = 0.4;

for t = 2:tmax
    nvec(t) = lam*nvec(t-1)*(1 - nvec(t-1));
end

plot(1:tmax, nvec, 'LineWidth', 1, 'Color', 'black');
xlabel('time, $t$', 'Interpreter', 'latex');
ylabel('abundance,  $n_t$', 'Interpreter', 'latex');
title(sprintf('$\\lambda={%0.4f}$', lam), 'Interpreter', 'latex');
ylim([-.1 1.1]);

%% lambda = 3.3: 2-generation cycle
subplot(2,3,5);

lam = 3.3;
nvec = zeros(1,tmax);
nvec(1) = 0.4;

for t = 2:tmax
    nvec(t) = lam*nvec(t-1)*(1 - nvec(t-1));
end

plot(1:tmax, nvec, 'LineWidth', 1, 'Color', 'green');
xlabel('time, $t$', 'Interpreter', 'latex');
ylabel('abundance,  $n_t$', 'Interpreter', 'latex');
title(sprintf('$\\lambda={%0.4f}$', lam), 'Interpreter', 'latex');
ylim([-.1 1.1]);
