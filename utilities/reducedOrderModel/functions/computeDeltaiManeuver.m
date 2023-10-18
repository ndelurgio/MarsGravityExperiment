function [maneuverLocations,maneuverVectors] = computeDeltaiManeuver(Delta_di,OE,mu)
% Inputs:   δi pseudostate 2x1 = [ δix, δiy ]
%           OE 6x1 = [ a, e, i, Ω, ω, M ]
% Outputs:  Mean Anomaly of Maneuvers (1x1), Maneuver Vectors (1x3)
%
% This function assumes the spacecraft only uses normal maneuvers.

a = OE(1);
e = OE(2);
w = OE(5);
M = OE(6);
eta = sqrt(1-e^2);
n = meanMotion(mu,a);

Delta_dix = Delta_di(1);
Delta_diy = Delta_di(2);

theta = atan2(Delta_diy,Delta_dix);
nu = theta - w;
M = nu2M(nu,e);
dvn = n*a/eta * norm(Delta_di) * (1+e*cos(nu));
maneuverLocations = [M];
maneuverVectors = [0, 0, dvn];


end

