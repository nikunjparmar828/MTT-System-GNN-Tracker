figure;
%     plot(Performance.Actors.MATracks,'b')
    hold on
    plot(Performance.Actors.EATracks,'r')
    plot(Performance.Actors.Ground,'--k')
    title('Performance Index 1: # of tracks and actors')
    xlabel('Step')
    ylabel('# of vehicles in the scene')
    legend('MATLAB Tracker','Eatron Tracker','Ground Truth')
    
figure;
%     plot(Performance.MeanDistance.MA,'b-*')
    hold on
    plot(Performance.MeanDistance.EA,'r-*');
    title('Performance Index 2: Average distance btw tracks and actors')
    xlabel('Step')
    ylabel('Avrerage distance (m)')
    legend('MATLAB Tracker','Eatron Tracker')

figure;
    plot(Performance.GhostActors.MA,'b-*')
    hold on
    plot(Performance.GhostActors.EA,'r-o')
    title('Performance Index 3: # of ghost actors')
    xlabel('Step')
    ylabel('# of ghost actors in the scene')
    legend('MATLAB Tracker','Eatron Tracker')
    

