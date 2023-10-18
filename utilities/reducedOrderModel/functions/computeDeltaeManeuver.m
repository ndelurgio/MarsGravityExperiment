function [maneuverLocations,maneuverVectors] = computeDeltaeManeuver(DeltaROE_control,T_duration, OE, mu)
% Inputs:   Control ROE Pseudostate 6x1 = [ δa, δλ, δex, δey, δix, δiy ]
%           Reconfiguration Time Duration [s]
%           OE 6x1 = [ a, e, i, Ω, ω, M ]
% Outputs:  Mean Anomaly of Maneuvers (3x1), Maneuver Vectors (3x3)
%
% This function assumes the spacecraft only uses tangential maneuvers.

a = OE(1);
e = OE(2);
i = OE(3);
Om = OE(4);
w = OE(5);
M = OE(6);
eta = sqrt(1-e^2);
n = meanMotion(mu,a);
Mf = M + n*T_duration;

Delta_da = DeltaROE_control(1);
Delta_dlam = DeltaROE_control(2);
Delta_dex = DeltaROE_control(3);
Delta_dey = DeltaROE_control(4);

% Check for no maneuver
if Delta_dex == 0 && Delta_dey == 0
    maneuverLocations = [];
    maneuverVectors = [];
    return;
end

[nuOpt, dv_min] = computeDeltaeDominance(Delta_dex,Delta_dey, e, a, mu);

MOpt = zeros(1,length(nuOpt));
for i = 1:length(nuOpt)
    MOpt(i) = nu2M(nuOpt(i), e);
end
MOpt = sort(MOpt);

locationCandidates = MOpt;
t_left = T_duration;
% Generate list of maneuver location canidates
while t_left > 0
    MOpt = MOpt + 2*pi;
    locationCandidates = [locationCandidates, MOpt];
    t_left = t_left - 2*pi/n;
end
% Remove invaldid maneuver locations
locationCandidates = locationCandidates(locationCandidates > M);
locationCandidates = locationCandidates((locationCandidates - M)/n < T_duration);
% Require at least 3 maneuvers
if length(locationCandidates) < 3
    throw("Error: Less than three location candidates for delta-e maneuver.")
end

combos = nchoosek(locationCandidates,3);
dv_best = inf;
for i = 1:length(combos(:,1))
    combo = combos(i,:);
    M1 = combo(1);
    M2 = combo(2);
    M3 = combo(3);

    % Check if s = +1 or -1
    G1 = getChernickControlInputMatrix([OE(1:5); M1],mu);
    G2 = getChernickControlInputMatrix([OE(1:5); M2],mu);
    G3 = getChernickControlInputMatrix([OE(1:5); M3],mu);

    STM1 = getSTM(Mf-M1);
    STM2 = getSTM(Mf-M2);
    STM3 = getSTM(Mf-M3);

    A = [STM1*G1(:,2), STM2*G2(:,2), STM3*G3(:,2)];
    % A(3,:) = [1,1,1];
    s1 = getSign([G1(3,2), G1(4,2)], [Delta_dex,Delta_dey]);
    s2 = getSign([G2(3,2), G2(4,2)], [Delta_dex,Delta_dey]);
    s3 = getSign([G3(3,2), G3(4,2)], [Delta_dex,Delta_dey]);
    A(3,:) = [s1,s2,s3] .* sqrt(A(3,:).^2 + A(4,:).^2);
    % A(3,:) = A(4,:);
    A = A(1:3,:);
    % c = A \ [Delta_da; Delta_dlam; 1];
    dvT = A \ [Delta_da; Delta_dlam; sqrt(Delta_dex^2 + Delta_dey^2)];
    % dvT = A \ [Delta_da; Delta_dlam; Delta_dey];

    if norm(dvT,1) < dv_best || (norm(dvT,1) == dv_best && M3 < maneuverLocations(3))
        maneuverLocations = [M1, M2, M3];
        maneuverVectors = [0, dvT(1), 0; 0, dvT(2), 0; 0, dvT(3), 0];
    end

    % s1 = getSign([G1(3,2), G1(4,2)], [Delta_dex,Delta_dey]);
    % s2 = getSign([G2(3,2), G2(4,2)], [Delta_dex,Delta_dey]);
    % s3 = getSign([G3(3,2), G3(4,2)], [Delta_dex,Delta_dey]);
    % 
    % f1 = compute_f(M1,e);
    % f2 = compute_f(M2,e);
    % f3 = compute_f(M3,e);
    % 
    % dM12 = Mij(M1,M2);
    % dM13 = Mij(M1,M3);
    % dM23 = Mij(M2,M3);
    % K123 = Kijk(dv_min,s1,s2,s3,dM12,dM13,dM23,f1,f2,f3);
    % 
    % h1f = hij(a,Delta_dlam,Delta_da,M1,Mf);
    % h2f = hij(a,Delta_dlam,Delta_da,M2,Mf);
    % g12 = gij(eta,n,s1,s2,f1,f2,h1f,h2f,dv_min,dM12);
    % 
    % h3f = hij(a,Delta_dlam,Delta_da,M3,Mf);
    % g13 = gij(eta,n,s1,s3,f1,f3,h1f,h3f,dv_min,dM13);
    % 
    % g23 = gij(eta,n,s2,s3,f2,f3,h2f,h3f,dv_min,dM23);
    % 
    % c1 = g23/K123;
    % c2 = -g13/K123;
    % c3 = g12/K123;
    % norm([c1,c2,c3],1)
end

end

