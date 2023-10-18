function [EROE, OE, cartesianState] = propJ2(OE0,EROE0,J2,r,mu,t)

EROE = zeros(6,length(t));
EROE(:,1) = EROE0;
OE = zeros(6,length(t));
OE(:,1) = OE0;
cartesianState = zeros(6,length(t));
cartesianState(:,1) = cartesianGuffantiSolution(OE(:,1),0,mu)*EROE(:,1);
for i = 2:length(t)
    n = meanMotion(mu,OE0(1));
    OE(:,i) = OE0 + computeJ2meanPerturbation(OE0,mu,J2,r)*t(i);
    OE(6,i) = OE(6,i) + n*t(i);
    STM = computeEccentricROE_STM(OE0,J2,r,mu,t(i));
    EROE(:,i) = STM*EROE0;
    % OEosc = mean2osc(OE(:,i),1,mu,J2,r);
    % OEmean_dep = eccentricROE2deputyOE(EROE(:,i),OE(:,i));
    % OEosc_dep = mean2osc(OEmean_dep,1,mu,J2,r);
    % EROEosc = computeEccentricSingularROE(OEosc,OEosc_dep);
    cartesianState(:,i) = cartesianGuffantiSolution(OE(:,i),0,mu)*EROE(:,i);
    % cartesianState(:,i) = cartesianGuffantiSolution(OEosc,0,mu)*EROEosc;

end



end

