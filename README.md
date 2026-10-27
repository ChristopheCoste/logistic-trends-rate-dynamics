# logistic-trends-rate-dynamics
MATLAB code to reproduce figures for “How does the rate of environmental change affect density-dependent population dynamics?”, including logistic-map trends, bifurcation and superimposition diagrams, cobweb plots, noisy environments, step changes, and trend-rate scans.
The preprint is accessible at https://doi.org/10.32942/X2KW98 with figure numbers corresponding to the description below.

# Code for logistic-map and trend-induced dynamics figures
This repository contains MATLAB scripts used to reproduce the main and supplementary figures associated with the manuscript:

**“How does the rate of environmental change affect density-dependent population dynamics?”**
by Christophe F. D. Coste, Brett Petersen, Dongbo Li, Chenggui Yuan, Steven M. Sait, and Mike S. Fowler.

## Abstract
Natural populations experience variable environments. Anthropogenically driven environmental change, in particular, is expected to impose trends on key demographic parameters related to reproduction and survival.
Theoretical and empirical studies of how environmental changes affect populations have highlighted dynamical phenomena including bifurcation-related tipping points – typically identified by comparing different, but constant, environmental states (e.g., current vs future predicted conditions) – and long transients – that can arise after sudden environmental perturbations.
However, real-world environmental trends are neither instantaneous nor slow enough to justify treating the environment as distinct, but constant states, motivating recent interest in r-tipping points – regime shifts induced by r, the rate of environmental change in demographic parameters.
Most existing work examines this phenomenon in complex ecological models and for specific values of the rate of environmental change (r).
Here, we develop novel graphical and mathematical tools to help ecologists investigate how populations and communities respond to environmental trends across a continuum of r values, from environmentally driven demographic changes occurring across tens of millions of generations, to rapid, large changes across a single generation.
Using a simple density-dependent model, we identify four qualitatively distinct dynamical responses to an environmental trend as a function of r – including bifurcation delays and the associated “catch-up” phase, lags and ghost attractors during environmental tracking, and post-trend transient behaviour.
Traditional methods fail to reveal these patterns and we introduce an r-bifurcation diagram here to visualise them. We also describe and explain the emergence of abrupt regime shifts linked to delayed bifurcations, revealed by a novel superimposition diagram, that allows direct comparison between step- and gradual trend approaches to studying environmental change.
We show that our findings and approaches are robust across modelling frameworks and ecological contexts, e.g., incorporating trophic interactions and short-term stochastic fluctuations, and in discrete- and continuous-time models.
Our work provides new insights into interactions between short- and long-term environmental change processes, linking concepts of the rate of environmental change with regime shifts, bifurcations and tipping points.
For a population undergoing an environmental trend, the journey towards the post-trend state can be as important as the destination.

## Repository overview
The scripts focus mostly on logistic-map dynamics under a linear trend. They also consider constant environments, nonlinear environmental trends, noisy environments, step changes, and reverse trends, using time-series plots, superimposition diagrams, and cobweb diagrams.
One script also reproduces a prey-predator system under trend.

## Requirements
The scripts are written for MATLAB. They use standard MATLAB plotting and numerical operations.
No additional MATLAB toolbox should be required for the provided scripts. In particular, the autocorrelation in [`FigS11_noisy_stationary_logistic_autocorrelation.m`](FigS11_noisy_stationary_logistic_autocorrelation.m) is computed directly rather than using `autocorr`. Several figures involve long simulations.

## Shared cached data
Three figures use the same precomputed trend-rate scan:
- [`Fig7_plot_r_bifurcation_diagram.m`](Fig7_plot_r_bifurcation_diagram.m)
- [`FigS7_first_oscillation_generation_vs_rate.m`](FigS7_first_oscillation_generation_vs_rate.m)
- [`FigS8_delay_and_remaining_trend_vs_rate.m`](FigS8_delay_and_remaining_trend_vs_rate.m)

The cached data file is:
- [`trend_rate_scan_data.mat`](trend_rate_scan_data.mat)
It contains the matrix `trend_rate_scan_data`. Columns correspond to environmental trend rates `r`; rows are:
1. trend duration `T`
2. environmental rate of change `r`
3. generation of first oscillation, `t_o(r)`
4. `b(r)`, the parameter value `lambda_t` at first oscillation
5. generation at which `lambda_t` crosses 3, `t_3(r)`
6. post-trend transient duration, `D(r)`

To regenerate this file from scratch, run:
- [`Compute_trend_rate_scan_data.m`](Compute_trend_rate_scan_data.m)
Regenerating the data can be slow.

## Figure scripts

### Main figures
- [`Fig1_bifdiag.m`](Fig1_bifdiag.m)  
  Central bifurcation diagram of the logistic map.
- [`Fig1_timeseries.m`](Fig1_timeseries.m)  
  Example constant-environment time series around the bifurcation diagram.
- [`Fig2_slow_trend_timeseries.m`](Fig2_slow_trend_timeseries.m)  
  Slow linear environmental trend: full trajectory and zooms around the first oscillation.
- [`Fig3_superimposition_diagram.m`](Fig3_superimposition_diagram.m)  
  Slow-trend abundance trajectory superimposed on the constant-environment bifurcation diagram.
- [`Fig4_acceleration_slow_trends.m`](Fig4_acceleration_slow_trends.m)  
  Abundance acceleration for several slow trends.
- [`Fig5_very_slow_trend.m`](Fig5_very_slow_trend.m)  
  Very slow trend with `T = 1e8` generations.
- [`Fig6_fast_trend_superimposition.m`](Fig6_fast_trend_superimposition.m)  
  Fast-trend superimposition diagram with chronological time shown on the upper x-axis.
- [`Fig7_plot_r_bifurcation_diagram.m`](Fig7_plot_r_bifurcation_diagram.m)  
  Rate-based bifurcation-style diagram showing `b(r)` and `D(r)`, using [`trend_rate_scan_data.mat`](trend_rate_scan_data.mat).
- [`Fig8_trend_class_examples.m`](Fig8_trend_class_examples.m)  
  Representative examples of very slow, slow, fast, and very fast trends.
- [`Fig9_noisy_trend.m`](Fig9_noisy_trend.m)  
  Noisy environmental trends with different noise standard deviations and autocorrelations.
- [`Fig10_prey_predator_trend_classes.m`](Fig10_prey_predator_trend_classes.m)  
  Trend-class examples for a prey-predator model.
- [`Fig11_cobweb_slow_trend.m`](Fig11_cobweb_slow_trend.m)  
  Cobweb diagrams for constant and slow-trend logistic-map dynamics.

### Supplementary figures
- [`FigS1_logistic_map_constant_environments.m`](FigS1_logistic_map_constant_environments.m)  
  Transient and asymptotic dynamics of the logistic map in constant environments.
- [`FigS2_logistic_map_cycle_periods_lyapunov.m`](FigS2_logistic_map_cycle_periods_lyapunov.m)  
  Cycle period and Lyapunov exponent across `lambda`.
- [`FigS3_step_change_transient_duration.m`](FigS3_step_change_transient_duration.m)  
  Transient duration after instantaneous step change to `lambda_T = 3.9605`.
- [`FigS4_step_change.m`](FigS4_step_change.m)  
  Step-change examples with abundance dynamics and cobweb diagrams.
- [`FigS5_acceleration_parameter_and_b_tipping.m`](FigS5_acceleration_parameter_and_b_tipping.m)  
  `d(r)`, parameter at maximum acceleration, and `b(r)`.
- [`FigS6_trend_speed_time_lambda_cobwebs.m`](FigS6_trend_speed_time_lambda_cobwebs.m)  
  Time series, superimposition diagrams, and cobweb diagrams for four trend speeds.
- [`FigS7_first_oscillation_generation_vs_rate.m`](FigS7_first_oscillation_generation_vs_rate.m)  
  `t_o(r)`, `t_3(r)`, and `T` as functions of `r`, using [`trend_rate_scan_data.mat`](trend_rate_scan_data.mat).
- [`FigS8_delay_and_remaining_trend_vs_rate.m`](FigS8_delay_and_remaining_trend_vs_rate.m)  
  `t_o(r)-t_3(r)` and `T-t_o(r)` as functions of `r`, using [`trend_rate_scan_data.mat`](trend_rate_scan_data.mat).
- [`FigS9_very_fast_trends_around_r_tipping_point.m`](FigS9_very_fast_trends_around_r_tipping_point.m)  
  Very fast trends around the r-tipping point.
- [`FigS10_slow_trend_superimposition_diagram.m`](FigS10_slow_trend_superimposition_diagram.m)  
  Superimposition diagram for a slow trend with `T = 20000`.
- [`FigS11_noisy_stationary_logistic_autocorrelation.m`](FigS11_noisy_stationary_logistic_autocorrelation.m)  
  Lag-1 abundance autocorrelation in stationary noisy environments.
- [`FigS12_nonlinear_trend_superimposition_diagram.m`](FigS12_nonlinear_trend_superimposition_diagram.m)  
  Nonlinear environmental trend and zoom around `lambda_t = 3`.
- [`FigS13_reverse_trend_superimposition_diagrams.m`](FigS13_reverse_trend_superimposition_diagrams.m)  
  Reverse trends from high to low `lambda_t`.
- [`FigS14_two_and_three_step_environmental_change.m`](FigS14_two_and_three_step_environmental_change.m)  
  Very fast changes with `T = 2` and `T = 3`.
- [`FigS15_repelling_boundaries_lag_dynamics.m`](FigS15_repelling_boundaries_lag_dynamics.m)  
  Lag dynamics and analytical boundary curves.
- [`FigS16_nested_lag_cascade_dynamics.m`](FigS16_nested_lag_cascade_dynamics.m)  
  Nested lag quantities `g_t`, `h_t`, and abundance `n_t`.

## Running the scripts
Run each figure script directly from MATLAB.
Scripts that need [`trend_rate_scan_data.mat`](trend_rate_scan_data.mat) load it from the same folder as the script. The repository includes this cached file, so the three dependent scripts can be run without recomputing the long trend-rate scan.
Most scripts create one MATLAB figure. A few scripts create multiple figures or multi-panel layouts, matching the manuscript figure structure.

## Reproducibility notes
Some stochastic figures, especially [`Fig9_noisy_trend.m`](Fig9_noisy_trend.m) and [`FigS11_noisy_stationary_logistic_autocorrelation.m`](FigS11_noisy_stationary_logistic_autocorrelation.m), use random noise. The exact stochastic realisations can differ between runs unless a random-number seed is set before running the script.
