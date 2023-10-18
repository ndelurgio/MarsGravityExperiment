%% Startup script to run which initializes simulink environment

% clean up environment
clc;
clear;
close all;
bdclose all;

% clear previous simulation instances
Simulink.sdi.clear
sdi.Repository.clearRepositoryFile

%% Set up Simulink Project Paths
% Initialize project settings
% projectPaths = ProjectPaths();
% projectPaths.initialize();

%% Load Configuration

fprintf("Loading Configuration\n\n");

% Load config
default();
fprintf("\n\n");
fprintf("----- Setup Complete ----- \n\n");
fprintf("\n\n");
