% Reachability analysis of a Neural ODE

%% Define layers and neural ODE
controlPeriod = 40; % total seconds
reachStep = 0.01; % 1 second
% Load parameters
load('model.mat');
% Contruct NeuralODE
% ODEBlock only linear layers
% Convert in form of a linear ODE model
states = 3; % 2 + 1 augmented dimension
outputs = 3; % Only actual dimensions
inputs = 1;
w1 = Wb{1};
b1 = Wb{2}';
w2 = Wb{3};
b2 = Wb{4}';
w3 = Wb{5};
b3 = Wb{6}';
Aout = w3*w2*w1;
Bout = b3 + w3*w2*b1 + w3*b2;
Cout = eye(states);
D = zeros(outputs,1);
numSteps = controlPeriod/reachStep;
odeblock = LinearODE(Aout,Bout,Cout,D,controlPeriod,numSteps);
% Output layers 
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {odelayer};
neuralode = NeuralODE(neuralLayers);
tvec = 0:reachStep:controlPeriod;


%% Reachability
% Setup
x0 = [0.2647;-0.0339;0.0]; % Initial state third trajectory
unc = 0.01;
lb = x0-unc;
ub = x0+unc;
R0 = Star(lb,ub);

t = tic;
Rb = neuralode.reach(R0); % Reachability
tc = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
hold on;
plot(yyy(1,:),yyy(2,:),'r');
xlabel('x_1');
ylabel('x_2');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
saveas(f,'DampedOsc_anode.pdf');

f = figure;
Star.plotRanges_2D(Rb,1,tvec,'b');
hold on;
plot(tvec,yyy(1,:),'r');
xlabel('Time (s)');
ylabel('x_1');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
saveas(f,'DampedOsc_anode_x1.pdf');

f = figure;
Star.plotRanges_2D(Rb,2,tvec,'b');
hold on;
plot(tvec,yyy(2,:),'r');
xlabel('Time (s)');
ylabel('x_2');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
saveas(f,'DampedOsc_anode_x2.pdf');

%% Save results
save('reach.mat','tc','Rb');