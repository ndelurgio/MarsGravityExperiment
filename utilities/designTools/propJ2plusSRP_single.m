function EROE = propJ2plusSRP_single(OE0,EROE0,sunOE0,J2,r,mu,constants,dB,t)

STM = computeEccentricROE_STM(OE0,J2,r,mu,t);
STM_SRP = computeEccentricROE_SRP_STM(OE0, sunOE0, mu, constants, t);
EROE = [STM, STM_SRP(1:6,7)]*[EROE0; dB];

end


