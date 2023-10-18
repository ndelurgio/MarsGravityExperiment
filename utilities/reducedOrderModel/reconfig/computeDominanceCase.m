function dominanceCase = computeDominanceCase(DeltaROE_control,T_duration, OE)
% Inputs:   Control ROE Pseudostate 6x1 = [ δa, δλ, δex, δey, δix, δiy ]
%           Reconfiguration Time Duration [s]
%           OE 6x1 = [ a, e, i, Ω, ω, M ]
% Outputs:  Dominance Case, string (Δδa, Δδλ, Δδe, or none)
%
% This function assumes the spacecraft only uses tangential maneuvers.

% return if there is not an in-plane maneuver
if norm(DeltaROE_control(1:4)) == 0
    dominanceCase = "No Maneuver"; % No in-plane
    return
end

a = OE(1);
e = OE(2);
M = OE(6);
mu = 3.986004419e14;
n = meanMotion(mu,a);
eta = sqrt(1-e^2);

Delta_da    = DeltaROE_control(1);
Delta_dlam  = DeltaROE_control(2);
Delta_dex   = DeltaROE_control(3);
Delta_dey   = DeltaROE_control(4);

% % raise exception if Δδa not equal to zero
% if Delta_da ~= 0
%     throw("Error: The reduced order model does not allow for nonzero Δδa.")
% end

% Δδa dv minimum
Delta_da_max = 2*(1+e)/(a*eta*n);
dv_min_da = abs(a*Delta_da/Delta_da_max);
% Δδλ dv minimum
t_perigee = (2*pi - M)/n; % Time until first perigee pass
t_left = T_duration - t_perigee; % Time after first perigee pass
n_orbits = floor(t_left / (2*pi/n)); % Number of perigee passes allowed for the maneuver
if n_orbits < 1
    throw("Error: time duration too small to execute delta-lambda maneuver.")
end
dM = 2*pi*n_orbits;
Delta_dlam_max = 3*(1+e)*dM/(a*eta*n);
dv_min_dlam = abs(Delta_dlam/Delta_dlam_max);
% Δδe minimum
[~, dv_min_de] = computeDeltaeDominance(Delta_dex,Delta_dey, e, a);

switch max([dv_min_da,dv_min_dlam,dv_min_de])
    case dv_min_da
        dominanceCase = "da";
    case dv_min_dlam
        dominanceCase = "dlam";
    case dv_min_de
        dominanceCase = "de";
end


end

