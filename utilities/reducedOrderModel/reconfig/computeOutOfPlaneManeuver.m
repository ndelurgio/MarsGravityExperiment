function [maneuverTimes, maneuverLocations, maneuverVectors, dv_total] = computeOutOfPlaneManeuver(DeltaEROE, OE, mu)
    % This model uses the first maneuver time.
    
    a = OE(1);
    e = OE(2);
    w = OE(5);
    M = OE(6);
    eta = sqrt(1-e^2);
    n = meanMotion(mu,a);

    DeltaROE = guidance2controlROE(DeltaEROE,OE);
    
    Delta_dix = DeltaROE(5);
    Delta_diy = DeltaROE(6);
    
    theta = atan2(Delta_diy,Delta_dix);
    nu = theta - w;
    M = nu2M(nu,e);
    dvn = n*a/eta * norm(DeltaROE(5:6)) * (1+e*cos(nu));
    maneuverLocations = [M; M+deg2rad(1); M+deg2rad(2)];
    maneuverVectors = [0, 0, dvn; 0,0,0;0,0,0];
    maneuverTimes = maneuverLocations/n;
    dv_total = dvn;
end

