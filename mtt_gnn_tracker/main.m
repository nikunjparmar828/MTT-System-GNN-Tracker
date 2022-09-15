close all;
clc;
%% Initialization

% Initialize parameters
init_params;

% Initialize scene actors
defineScenario;

positionSelector = [1 0 0 0; 0 0 1 0]; % Position selector
velocitySelector = [0 1 0 0; 0 0 0 1]; % Velocity selector

% Sensor and Birds-eye view configuration
sensors = configureSensors(egoCar,SensorsSampleRate);
BEP = createDemoDisplay(egoCar, sensors);

%% Tracker
while advance(scenario)
    k = k + 1;
    time = scenario.SimulationTime;

    % Get the position of the other vehicle in ego vehicle coordinates
    targets = targetPoses(egoCar);

    % -------------- Simulate the sensors -------------------
    detections = {};
    isValidTime = zeros(1,length(sensors));

    for i = 1:length(sensors)
        
        [sensorDets, numValidDets, isValidTime(i)] = sensors{i}(targets, time);

        if numValidDets

            for j = 1:numValidDets
                % This adds the SNR object attribute to vision
                % detections and sets it to a NaN.
                if ~isfield(sensorDets{j}.ObjectAttributes{1}, 'SNR')
                    sensorDets{j}.ObjectAttributes{1}.SNR = NaN;
                end
            end

            detections = [detections; sensorDets]; % #ok<AGROW>

        end
    end

    
    % Update the tracker if there are new detections
    if any(isValidTime)
        TrackerStep = TrackerStep + 1;

        % Cluster Detections
        VehicleDim = [sensors{1}.ActorProfiles.Length, sensors{1}.ActorProfiles.Width,...
            sensors{1}.ActorProfiles.Height];
        [DetectionClusters] = clusterDetections(detections, VehicleDim);
        % Fetch Measurements
        Measurements = getMeasurements(DetectionClusters);

        % ----------------- Kalman Prediction ----------------------
        t1 = scenario.SimulationTime;
        dt = t1 - t0;
        t0 = t1;

        for i = 1:size(Tracks,2)
            [Tracks(i).State, Tracks(i).StateCovariance] = predict(Tracks(i).State, Tracks(i).StateCovariance, Q, dt);
        end

        % ----------------- Tracker Data Association -------------------
        [Tracks] = dataAssociation(Tracks, Measurements,TrackerStep,AssignmentThreshold,N,R);

        % ------------------- Kalman Update ------------------------
        for i = 1:size(Tracks,2)
            if Tracks(i).Assigned
                [Tracks(i).State,Tracks(i).StateCovariance,Tracks(i).Sk] = correct(Tracks(i).State, ...
                                                    Tracks(i).StateCovariance,Tracks(i).Measurement,R);
            end
        end

        % ----------------- Tracker Management ----------------------
        [confirmedTracks,Tracks] = TrackManagement(Tracks,N,M,EliminationTH);

        % Update bird's-eye plot
        updateBEP(BEP, egoCar, detections, confirmedTracks, positionSelector, velocitySelector);
    end

end
