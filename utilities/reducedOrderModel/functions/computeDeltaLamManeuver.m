function [maneuverLocations,maneuverVectors] = computeDeltaLamManeuver(Delta_dlam,T_duration, OE)
% Inputs:   Δδλ
%           Reconfiguration Time Duration [s]
%           OE 6x1 = [ a, e, i, Ω, ω, M ]
% Outputs:  Mean Anomaly of Maneuvers (2x1), Maneuver Vectors (2x3)
%
% This function assumes the spacecraft only uses tangential maneuvers.

a = OE(1);
e = OE(2);
M = OE(6);
mu = 3.986004419e14;
n = meanMotion(mu,a);
eta = sqrt(1-e^2);

% Initalize
maneuverLocations = zeros(2,1);
maneuverVectors = zeros(2,3);

t_perigee = (2*pi - M)/n; % Time until first perigee pass
t_left = T_duration - t_perigee; % Time after first perigee pass
n_orbits = floor(t_left / (2*pi/n)); % Number of perigee passes allowed for the maneuver
if n_orbits < 1
    throw("Error: time duration too small to execute delta-lambda maneuver.")
end
dM = 2*pi*n_orbits;
Delta_da_des = 2/3*Delta_dlam/dM; % Positive because 0 - da_des

% Maneuver 1
maneuverLocations(1) = M + (2*pi - mod(M,2*pi)); % Perigee
dvT = eta*n*a/(2*(1+e)) * Delta_da_des;
maneuverVectors(1,:) = [ 0, dvT, 0 ];

% Maneuver 2
maneuverLocations(2) = maneuverLocations(1) + dM;
maneuverVectors(2,:) = -maneuverVectors(1,:); % Opposite

end

