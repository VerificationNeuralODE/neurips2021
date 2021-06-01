% Reachability analysis of a Neural ODE

%% Define layers and neural ODE
controlPeriod = 25; % total seconds
reachStep = 0.01; % 1 second
C = eye(2); % Want to get both of the outputs from NeuralODE
% Load parameters
load('odeffnn_spiral.mat');
% Contruct NeuralODE
layer1 = LayerS(Wb{1},Wb{2}','purelin');
% ODEBlock only linear layers
% Convert in form of a linear ODE model
states = 2;
outputs = 2;
inputs = 1;
w1 = Wb{3};
b1 = Wb{4}';
w2 = Wb{5};
b2 = Wb{6}';
Aout = w2*w1;
Bout = b2' + b1'*w2';
Cout = eye(states);
D = zeros(outputs,1);
numSteps = controlPeriod/reachStep;
odeblock = LinearODE(Aout,Bout',Cout,D,controlPeriod,numSteps);
% Output layers 
layer4 = LayerS(Wb{7},Wb{8}','purelin');
odelayer = ODEblockLayer(odeblock,controlPeriod,reachStep,true);
neuralLayers = {layer1, odelayer, layer4};
neuralode = NeuralODE(neuralLayers);
tvec = 0:reachStep:controlPeriod;
unsafeR = Star([1.3;-2.0],[2.0;-1.3]);


%% Reachability run #1
% Setup
x0 = [2.0;0.0]; % This is like the initial input to the ODEblock (initial state)
R0 = Star([1.9;-0.1],[2.1;0.1]);

t = tic;
Rb = neuralode.reach(R0); % Reachability
tb = toc(t);
yyy = neuralode.evaluate(x0); % Simulation

% Plot results
f = figure;
hold on;
Star.plotBoxes_2D_noFill(Rb,1,2,'b');
plot(yyy(1,:),yyy(2,:),'r');
Star.plotBoxes_2D(unsafeR,1,2,'m');
xlabel('x_1');
ylabel('x_2');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
saveas(f,'spirallinear_0.1.pdf');

% f = figure;
% Star.plotRanges_2D(Rb,1,tvec,'b');
% hold on;
% plot(tvec,yyy(1,:),'r');
% xlabel('Time (s)');
% ylabel('x_1');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% saveas(f,'spirallinear_0.1_1.png');
% 
% f = figure;
% Star.plotRanges_2D(Rb,2,tvec,'b');
% hold on;
% plot(tvec,yyy(2,:),'r');
% xlabel('Time (s)');
% ylabel('x_2');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% saveas(f,'spirallinear_0.1_2.png');

%% Reachability run #2
R0 = Star([1.8;-0.2],[2.2;0.2]);

t = tic;
Rc = neuralode.reach(R0); % Reachability
tc = toc(t);

% Plot results
f = figure;
Star.plotBoxes_2D_noFill(Rc,1,2,'b');
hold on;
plot(yyy(1,:),yyy(2,:),'r');
Star.plotBoxes_2D(unsafeR,1,2,'m');
xlabel('x_1');
ylabel('x_2');
ax = gca; % Get current axis
ax.XAxis.FontSize = 15; % Set font size of axis
ax.YAxis.FontSize = 15;
saveas(f,'spirallinear_0.2.pdf');

% f = figure;
% Star.plotRanges_2D(Rb,1,tvec,'b');
% hold on;
% plot(tvec,yyy(1,:),'r');
% xlabel('Time (s)');
% ylabel('x_1');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% saveas(f,'spirallinear_0.2_1.png');
% 
% f = figure;
% Star.plotRanges_2D(Rb,2,tvec,'b');
% hold on;
% plot(tvec,yyy(2,:),'r');
% xlabel('Time (s)');
% ylabel('x_2');
% ax = gca; % Get current axis
% ax.XAxis.FontSize = 15; % Set font size of axis
% ax.YAxis.FontSize = 15;
% saveas(f,'spirallinear_0.2_2.png');


save('reach.mat','tb','tc','Rb','Rc');

