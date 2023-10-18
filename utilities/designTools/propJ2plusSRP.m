function [EROE, OE, cartesianState] = propJ2plusSRP(OE0,EROE0,sunOE0,J2,r,mu,constants,dB,t)

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
    STM = STM;
    STM_SRP = computeEccentricROE_SRP_STM(OE0, sunOE0, mu, constants, t(i));
    EROE(:,i) = [STM, STM_SRP(1:6,7)]*[EROE0; dB];
    cartesianState(:,i) = cartesianGuffantiSolution(OE(:,i),0,mu)*EROE(:,i);

end



end

