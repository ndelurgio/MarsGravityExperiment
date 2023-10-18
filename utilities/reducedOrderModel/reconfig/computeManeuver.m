function [maneuverTimes, maneuverLocations, maneuverVectors, dv_total] = computeManeuver(DeltaROE_guidance,T_duration, OE)
% Inputs:   Guidance ROE Pseudostate 6x1 = [ δa, δλ, δex, δey, δix, δiy ]
%           Reconfiguration Time Duration [s]
%           OE 6x1 = [ a, e, i, Ω, ω, M ]
% Outputs:  Time of Maneuvers (Nx1), True Anomaly of Maneuvers (Nx1),
% Maneuver Definitions (Nx3), Total Delta-V (1)
%
% This function assumes the spacecraft only uses tangential maneuvers.

% Check that Δδa = 0
if DeltaROE_guidance ~= 0
    throw("Error: Δδa maneuvers are not supported in the reduced order model.")
end

% Initialize
maneuverTimes = [];
maneuverLocations = [];
maneuverVectors = [];
dv_total = 0;

a = OE(1);
e = OE(2);
i = OE(3);
Om = OE(4);
w = OE(5);
M = OE(6);
mu = 3.986004419e14;
n = meanMotion(mu,a);

% Convert to Control ROE
DeltaROE_control = guidance2controlROE(DeltaROE_guidance,OE);
DeltaROE_control*a

%%% In-plane Maneuvers
% Find Dominance Case
dominanceCase = computeDominanceCase(DeltaROE_control,T_duration, OE);
switch dominanceCase
    case "No Maneuver"
    case "da"
        throw("Error: Δδa dominant maneuvers are not supported in the reduced order model.")
    case "dlam"
        % Complete Δδλ maneuver first
        [loc_dlam,vec_dlam] = computeDeltaLamManeuver(Delta_dlam,T_duration/2, OE);
        maneuverLocations = [maneuverLocations; vec_dlam];
        for i = 1:length(loc_dlam)
            maneuverLocations = [maneuverLocations; loc_dlam(i)];
            t = getManeuverTime(loc_dlam(i),M, n);
            maneuverTimes = [maneuverTimes; t];
            maneuverVectors = [maneuverVectors; vec_dlam(i)];
        end
        % Now, complete Δδe maneuver
        [loc_de,vec_de] = computeDeltaeManeuver(DeltaROE_control,T_duration/2, OE);
        while loc_de(1) < maneuverLocations(end)
            loc_de = loc_de + 2*pi;
        end
        for i = 1:length(loc_de)
            maneuverLocations = [maneuverLocations, loc_de(i)];
            t = getManeuverTime(loc_de(i),M,n);
            maneuverTimes = [maneuverTimes; t];
            maneuverVectors = [maneuverVectors; vec_de(i)];
        end
    case "de"
        [loc_de,vec_de] = computeDeltaeManeuver(DeltaROE_control,T_duration, OE);
        for i = 1:length(loc_de)
            maneuverLocations = [maneuverLocations, loc_de(i)];
            t = getManeuverTime(loc_de(i),M,n);
            maneuverTimes = [maneuverTimes; t];
            maneuverVectors = [maneuverVectors; vec_de(i,:)];
        end
    otherwise
        throw("Error: Unknown maneuver type")
end

%%% Out-of-plane Maneuvers
Delta_di = DeltaROE_control(5:6);
if norm(Delta_di) ~= 0
    [loc_di,vec_di] = computeDeltaiManeuver(Delta_di,OE);
    if ~isempty(maneuverLocations)
        indx = find(loc_di(1) > maneuverLocations, 1);
        if isempty(indx)
            indx = 0;
        end
        maneuverLocations = [maneuverLocations(1:indx), loc_di, maneuverLocations(indx+1:end)];
        maneuverVectors = [maneuverVectors(1:indx,:); vec_di; maneuverVectors(indx+1:end,:)];
        t = getManeuverTime(loc_di,M,n);
        maneuverTimes = [maneuverTimes(1:indx,:); t; maneuverTimes(indx+1:end,:)];
    else
        maneuverLocations = [maneuverLocations, loc_di];
        maneuverVectors = [maneuverVectors; vec_di];
        t = getManeuverTime(loc_di,M,n);
        maneuverTimes = [maneuverTimes; t];
    end
    
end

for i = 1:length(maneuverLocations)
    dv_total = dv_total + norm(maneuverVectors(i,:));
end

end