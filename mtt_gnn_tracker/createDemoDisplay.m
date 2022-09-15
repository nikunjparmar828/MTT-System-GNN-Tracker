function BEP = createDemoDisplay(egoCar, sensors)
%%% 
% *|createDemoDisplay|*
% 
% This function creates a three-panel display:
% 
% # Top-left corner of display: A top view that follows the ego vehicle.
% # Bottom-left corner of display: A chase-camera view that follows the ego vehicle.
% # Right-half of display: A <matlab:doc('birdsEyePlot') bird's-eye plot> display.


% Make a figure
    hFigure = figure('Position', [0, 0, 1200, 640], 'Name', 'Sensor Fusion with Synthetic Data Example');
    movegui(hFigure, [0 -1]); % Moves the figure to the left and a little down from the top    

    % Add a car plot that follows the ego vehicle from behind
    hCarViewPanel = uipanel(hFigure, 'Position', [0 0 0.5 0.5], 'Title', 'Chase Camera View');
    hCarPlot = axes(hCarViewPanel);
    chasePlot(egoCar, 'Parent', hCarPlot);

    % Add a car plot that follows the ego vehicle from a top view
    hTopViewPanel = uipanel(hFigure, 'Position', [0 0.5 0.5 0.5], 'Title', 'Top View');
    hCarPlot = axes(hTopViewPanel);
    chasePlot(egoCar, 'Parent', hCarPlot, 'ViewHeight', 180, 'ViewLocation', [0 0], 'ViewPitch', 90);
    
    % Add a panel for a bird's-eye plot
    hBEVPanel = uipanel(hFigure, 'Position', [0.5 0 0.5 1], 'Title', 'Bird''s-Eye Plot');
    
    % Create bird's-eye plot for the ego car and sensor coverage
    hBEVPlot = axes(hBEVPanel);
    frontBackLim = 80;
    BEP = birdsEyePlot('Parent', hBEVPlot, 'Xlimits', [-frontBackLim frontBackLim], 'Ylimits', [-35 35]);
    
    % Plot the coverage areas for long-range radars
    for i = 1:4
        cap = coverageAreaPlotter(BEP,'FaceColor',[1 0.4 0.6],'EdgeColor',[1 0.4 0.6]);
        plotCoverageArea(cap, sensors{i}.SensorLocation,...
            sensors{i}.MaxRange, sensors{i}.Yaw, sensors{i}.FieldOfView(1));
    end
    
    % Plot the coverage areas for mid-range radars
    for i = 5:8
        cap = coverageAreaPlotter(BEP,'FaceColor',[1 0.6 0.6],'EdgeColor',[1 0.6 0.6]);
        plotCoverageArea(cap, sensors{i}.SensorLocation,...
            sensors{i}.MaxRange, sensors{i}.Yaw, sensors{i}.FieldOfView(1));
    end
    
    % Plot the coverage areas for short-range radars
    for i = 9:12
        cap = coverageAreaPlotter(BEP,'FaceColor',[0.8 0.4 0.4],'EdgeColor',[0.8 0.4 0.4]);
        plotCoverageArea(cap, sensors{i}.SensorLocation,...
            sensors{i}.MaxRange, sensors{i}.Yaw, sensors{i}.FieldOfView(1));
    end
    
%     Plot the coverage areas for vision sensors
    for i = 13:14
        cap = coverageAreaPlotter(BEP,'FaceColor',[0.2 0.4 1],'EdgeColor',[0.2 0.4 1]);
        plotCoverageArea(cap, sensors{i}.SensorLocation,...
            sensors{i}.MaxRange, sensors{i}.Yaw, 45);
    end
    
    % Create a vision detection plotter put it in a struct for future use
    detectionPlotter(BEP, 'DisplayName','vision', 'MarkerEdgeColor','blue', 'Marker','^');
    
    % Combine all radar detections into one entry and store it for later update
    detectionPlotter(BEP, 'DisplayName','radar', 'MarkerEdgeColor','red');
    
    % Add road borders to plot
    laneMarkingPlotter(BEP, 'DisplayName','lane markings');
    
    % Add the tracks to the bird's-eye plot. Show last 10 track updates.
    trackPlotter(BEP, 'DisplayName','track', 'HistoryDepth',10);
    
    axis(BEP.Parent, 'equal');
    xlim(BEP.Parent, [-frontBackLim frontBackLim]);
    ylim(BEP.Parent, [-40 40]);
    
    % Add an outline plotter for ground truth
    outlinePlotter(BEP, 'Tag', 'Ground truth');
end