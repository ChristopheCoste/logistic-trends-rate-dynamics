%% Fig1_bifdiag.m
% Central panel of Figure 1: bifurcation diagram of the logistic map.
% The script iterates n_{t+1} = lambda*n_t*(1-n_t) for constant lambda
% values and plots the final asymptotic abundances after transients.

clc; clear all; close all;

%% Parameters
step = 0.0005;
veclam = 1:step:4;

n0 = 0.1;
tmax = 50000;
tlast = 1000;

%% Simulate logistic map across lambda values
nvec = zeros(length(veclam), tmax + 1);
nvec(:,1) = n0;

for i = 1:length(veclam)
    lam = veclam(i);
    for t = 1:tmax
        nvec(i,t+1) = lam*nvec(i,t)*(1 - nvec(i,t));
    end
end

%% Keep final iterations for the bifurcation diagram
nvecplot = nvec(:,end-tlast:end);

idx_blue    = veclam <= 2;
idx_magenta = veclam > 2 & veclam <= 3;
idx_green   = veclam > 3 & veclam <= 3.449;
idx_grey1   = veclam > 3.449 & veclam <= 3.9604;
idx_red     = veclam > 3.9604 & veclam <= 3.9610;
idx_grey2   = veclam > 3.9610;

unstable_eq_lam = 3:step:4;
unstable_eq_n = 1 - 1./unstable_eq_lam;

%% Plot
figure;

scatter(veclam(idx_blue),    nvecplot(idx_blue,:),    '.', 'b'); hold on;
scatter(veclam(idx_magenta), nvecplot(idx_magenta,:), '.', 'magenta');
scatter(veclam(idx_green),   nvecplot(idx_green,:),   '.', 'MarkerEdgeColor', 'green');
scatter(veclam(idx_grey1),   nvecplot(idx_grey1,:),   0.001, '.', 'MarkerEdgeColor', [.3 .3 .3]);
scatter(veclam(idx_grey2),   nvecplot(idx_grey2,:),   0.001, '.', 'MarkerEdgeColor', [.3 .3 .3]);
scatter(veclam(idx_red),     nvecplot(idx_red,:),     'o', 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red');
plot(unstable_eq_lam, unstable_eq_n, '.', 'Color', [.7 .7 .7]);

hold off;

ax = gca;
ax.FontSize = 20;

xlabel('constant reproductive rate, $\lambda$', 'Interpreter', 'latex', 'FontSize', 32);
ylabel('asymptotic abundances, $n_t$', 'Interpreter', 'latex', 'FontSize', 32);
