function [maneuverTimes, maneuverLocations, maneuverVectors, dv_total] = computeInPlaneManeuver(DeltaEROE, OE, mu)
    % This model uses the three first maneuver times.

    % Map to Chernick ROE
    OE(6) = 0;
    DeltaROE = guidance2controlROE(DeltaEROE,OE);

    % Bisection to get Maneuver locations
    % [maneuverLocations,~] = computeDeltaeDominance(DeltaROE(3),DeltaROE(4),OE(2),OE(1), mu);
    maneuverLocations = computeDeltaeDominanceReduced(DeltaROE(3),DeltaROE(4),OE(2));

    % Delta_dex = DeltaROE(3);
    % Delta_dey = DeltaROE(4);
    % e = OE(2);
    % if Delta_dex*Delta_dey > 0
    %     maneuverLocations(1) = bisection(pi,2*pi,Delta_dex,Delta_dey,OE(2));
    %     maneuverLocations(2) = bisection(0,pi,Delta_dex,Delta_dey,OE(2));
    % else
    %     maneuverLocations(1) = bisection(0,pi,Delta_dex,Delta_dey,OE(2));
    %     maneuverLocations(2) = bisection(pi,2*pi,Delta_dex,Delta_dey,OE(2));
    % end
    % maneuverLocations(1) = acos(Delta_dex/(e*Delta_dey)-e);
    % maneuverLocations(2) = acos(-Delta_dex/(e*Delta_dey)-e);

    MOpt = zeros(1,length(maneuverLocations));
    for i = 1:length(maneuverLocations)
        MOpt(i) = nu2M(maneuverLocations(i), OE(2));
    end
    MOpt = sort(MOpt);
    MOpt = [MOpt, MOpt(1) + 2*pi];
    
    maneuverLocations = MOpt;
    n = meanMotion(mu,OE(1));
    maneuverTimes = (MOpt-OE(6))/n;
    Mf = OE(6) + n*maneuverTimes(3);

    G1 = getChernickControlInputMatrix([OE(1:5); MOpt(1)],mu);
    G2 = getChernickControlInputMatrix([OE(1:5); MOpt(2)],mu);
    G3 = getChernickControlInputMatrix([OE(1:5); MOpt(3)],mu);

    STM1 = getSTM(Mf-MOpt(1));
    STM2 = getSTM(Mf-MOpt(2));
    STM3 = getSTM(Mf-MOpt(3));

    A = [STM1*G1(:,2), STM2*G2(:,2), STM3*G3(:,2)];
    A = A([1:2,4],:);
    dv_T = A \ DeltaROE([1:2,4]);
    maneuverVectors = [zeros(3,1), dv_T, zeros(3,1)];
    dv_total = sum(abs(dv_T));

    % Debug
    % G1 = getEROEControlMatrix([OE(1:5); MOpt(1)],mu);
    % G2 = getEROEControlMatrix([OE(1:5); MOpt(2)],mu);
    % G3 = getEROEControlMatrix([OE(1:5); MOpt(3)],mu);
    % 
    % STM1 = getEROESTM(OE,mu,maneuverTimes(3)-maneuverTimes(1));
    % STM2 = getEROESTM(OE,mu,maneuverTimes(3)-maneuverTimes(2));
    % STM3 = getEROESTM(OE,mu,maneuverTimes(3)-maneuverTimes(3));
    % A = [STM1*G1(:,2), STM2*G2(:,2), STM3*G3(:,2)];
    % disp(norm(A*dv_T-DeltaEROE))

end

function Delta_dex = Delta_dex_func(nu,e)
    eta = sqrt(1-e^2);
    Delta_dex = eta*(e+cos(nu).*(2+e*cos(nu)))./(1+e*cos(nu));
end

function Delta_dey = Delta_dey_func(nu,e)
    eta = sqrt(1-e^2);
    Delta_dey = eta*(2+e*cos(nu))./(e*(1+e*cos(nu)));
end

function val = f(Delta_dex,Delta_dey,e,nu)
    val = Delta_dey_func(nu,e) - Delta_dey/Delta_dex*Delta_dex_func(nu,e);
end

function nu = bisection(nu_low,nu_high,Delta_dex,Delta_dey,e)
    while abs(nu_high-nu_low) > 1e-6
        c = (nu_high+nu_low)/2;
        if sign(f(Delta_dex,Delta_dey,e,nu_low)) ~= sign(f(Delta_dex,Delta_dey,e,c))
            nu_high = c;
        else
            nu_low = c;
        end
    end
    nu = (nu_high+nu_low)/2;
end

