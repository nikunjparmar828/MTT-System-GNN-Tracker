% Assignment gate value
AssignmentThreshold = 30;        % The higher the Gate value, the higher the likelihood that every track...
                                 % will be assigned a detection.

% M/N initiation parameters
% The track is "confirmed" if after N consecutive updates at
% least M measurements are assigned to the track after the track initiation.
% M detections hits in N consecutive updates 
N = 5;
M = 4;

% Elimination threshold: The track will be deleted after EliminationTH # of updates without 
% any measurement update
EliminationTH = 10; % updates

% Measurement Noise
R = [22.1 0 0 0
     0 2209 0 0
     0 0 22.1 0
     0 0 0 2209];

% Process noise
Q= 7e-1.*eye(4);

% Performance anlysis parameters:
XScene = 80;
YScene = 40;
% PerfRadius is defined after scenario generation

%% Generate the Scenario

% Define an empty scenario.
scenario = drivingScenario;
scenario.SampleTime = 0.01;  % seconds
SensorsSampleRate   = 0.1;  % seconds

EgoSpeed = 25; % m/s


%% Fusion Loop for the scenario
Tracks = [];
count = 0;
toSnap = true;
TrackerStep = 0;
t0 = 0;
k = 0;
Performance.Actors.Ground  = [];
Performance.Actors.EATracks = [];
Performance.Actors.MATracks = [];
Performance.MeanDistance.EA = [];
Performance.MeanDistance.MA = [];
Performance.GhostActors.EA = [];
Performance.GhostActors.MA = [];
