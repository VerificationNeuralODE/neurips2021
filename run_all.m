% Temporarily disable MATLAB figures from displaying the plots
set(0,'DefaultFigureVisible','off');

% 1 - Spiral 2D experiments
disp('Spiral 2D');
cd spiral2d/linear;
run reach.m; % Execute linearTS
cd ../nonlinear;
run reach.m; % Execute nonlinearTS
cd ../..

% 2 - Damped Oscillator
disp('Damped Oscillator');
cd damped_oscillator/anode;
run reach.m; % Execute anode experiment
cd ../ilnode;
run reach.m; % Execute ilnode experiment
cd ../sonode;
run reach.m % Executes sonode experiment
cd ../..

% 3 - MNIST
cd mnist;
addpath('data');
run run_both.m; % Execute all mnist experiments 
