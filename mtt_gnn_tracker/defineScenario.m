% Load scenario road and extract waypoints for each lane
Scenario = load('Scenario1.mat');
WPs{1} = Scenario.data.ActorSpecifications(2).Waypoints;
WPs{2} = Scenario.data.ActorSpecifications(1).Waypoints;
WPs{3} = Scenario.data.ActorSpecifications(3).Waypoints;

road(scenario, WPs{2}, 'lanes',lanespec(3));

% Ego vehicle (lane 2)
egoCar = vehicle(scenario, 'ClassID', 1);
egoWPs = circshift(WPs{2},-8);
path(egoCar, egoWPs, EgoSpeed);

% Car1 (passing car in lane 3)
Car1 = vehicle(scenario, 'ClassID', 1);
Car1WPs = circshift(WPs{1},0);
path(Car1, Car1WPs, EgoSpeed + 5);

% Car2 (car in lane 1)
Car2 = vehicle(scenario, 'ClassID', 1);
Car2WPs = circshift(WPs{3},-15);
path(Car2, Car2WPs, EgoSpeed -5);

% Ego follower (lane 2)
Car3 = vehicle(scenario, 'ClassID', 1);
Car3WPs = circshift(WPs{2},+5);
path(Car3, Car3WPs, EgoSpeed);

% Car4 (stopped car in lane 1)
Car4 = vehicle(scenario, 'ClassID', 1);
Car4WPs = circshift(WPs{3},-13);
path(Car4, Car4WPs, 1);

ActorRadius = norm([Car1.Length,Car1.Width]);