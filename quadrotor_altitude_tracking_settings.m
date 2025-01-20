clear;
close all;

%% set the initial value of Simulink

simulation_time = inf;

% initial value of the reference
global reference;
reference = 0;

% control parameters (unit-mass uav)
Kp = 5;
Kd = 2;
initial_velocity = 0;
initial_height = 0;

open_system('quadrotor_altitude_tracking.slx');
% run the Simulink without waiting for its finish
set_param('quadrotor_altitude_tracking', 'SimulationCommand', 'start');
disp('The Simulink has started ...');


%% Update reference

mqttClient = mqttclient('tcp://127.0.0.1');

subscribe(mqttClient, 'opcua/data', 'Callback', @(topic, data_string) handleMessage(data_string));

function handleMessage(data_string)
    global reference;
    reference = str2double(data_string);
    assignin('base', 'reference', reference);
end

%% Stop the subscription

% clear mqttClient
% clear