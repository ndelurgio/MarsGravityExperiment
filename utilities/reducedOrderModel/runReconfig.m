OE = [15000e3;0.5;deg2rad(10);deg2rad(0);deg2rad(20);deg2rad(0)];
ROEi = 1/OE(1) * [0;4000;300;300;50;40];
% ROEf = 1/OE(1) * [0;2000;300;300;50;40];
ROEf = 1/OE(1) * [0;4500;250;200;50;90];


dROE = ROEf - ROEi;

mu = 3.986004419e14;
n = meanMotion(mu,OE(1));
T = 2*pi/n;
T_duration = 2*T;

[maneuverTimes, maneuverLocations, maneuverVectors, dv_total] = computeManeuver(dROE,T_duration, OE);

% Test
Mf = OE(6) + n*T_duration;

M1 = OE(6) + n*maneuverTimes(1);
Gamma1 = getChernickControlInputMatrix([OE(1:5); M1]);
STM1 = getSTM(Mf-M1);

M2 = OE(6) + n*maneuverTimes(2);
Gamma2 = getChernickControlInputMatrix([OE(1:5); M2]);
STM2 = getSTM(Mf-M2);

M3 = OE(6) + n*maneuverTimes(3);
Gamma3 = getChernickControlInputMatrix([OE(1:5); M3]);
STM3 = getSTM(Mf-M3);

dROE_control = (STM1*Gamma1*maneuverVectors(1,:)' + STM2*Gamma2*maneuverVectors(2,:)' + STM3*Gamma3*maneuverVectors(3,:)')
dROE_guidance = OE(1) * control2guidanceROE(dROE_control,OE)