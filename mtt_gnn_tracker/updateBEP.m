function updateBEP(BEP, egoCar, detections, confirmedTracks, psel, vsel)
 %%% 
% *|updateBEP|*
% 
% This function updates the bird's-eye plot with road boundaries,
% detections, and tracks.

% Update road boundaries and their display
    [lmv, lmf] = laneMarkingVertices(egoCar);
    plotLaneMarking(findPlotter(BEP,'DisplayName','lane markings'),lmv,lmf);
    
    % update ground truth data
    [position, yaw, length, width, originOffset, color] = targetOutlines(egoCar);
    plotOutline(findPlotter(BEP,'Tag','Ground truth'), position, yaw, length, width, 'OriginOffset', originOffset, 'Color', color);
    
    % Prepare and update detections display
    N = numel(detections);
    detPos = zeros(N,2);    
    isRadar = true(N,1);
    for i = 1:N
        detPos(i,:) = detections{i}.Measurement(1:2)';
        if detections{i}.SensorIndex > 12 % Vision detections            
            isRadar(i) = false;
        end        
    end
    plotDetection(findPlotter(BEP,'DisplayName','vision'), detPos(~isRadar,:));
    plotDetection(findPlotter(BEP,'DisplayName','radar'), detPos(isRadar,:));    
    
    % Prepare and update tracks display
    if ~isempty(confirmedTracks)
        trackIDs = {confirmedTracks.TrackID};
        labels = cellfun(@num2str, trackIDs, 'UniformOutput', false);
        [tracksPos, tracksCov] = getTrackPositions(confirmedTracks, psel);
        tracksVel = getTrackVelocities(confirmedTracks, vsel);
        plotTrack(findPlotter(BEP,'DisplayName','track'), tracksPos, tracksVel, tracksCov, labels);
    end
end