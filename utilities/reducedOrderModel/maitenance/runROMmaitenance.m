OE0 = [
    chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
    chief.initialConditions.meanOrbitElements.eccentricity;
    chief.initialConditions.meanOrbitElements.inclination_rad;
    chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad;
    chief.initialConditions.meanOrbitElements.argumentPerigee_rad;
    chief.initialConditions.meanOrbitElements.MeanAnomaly_rad;
];
% Deputy 1
EROE = [0, 0, 0, 5.9e3, 0, -0.77e3]'/OE0(1);
% EROE = [0, 0, 0, 5.8333e3, 0, -0.77e3]'/OE0(1);
da = EROE(1);
dlam = EROE(2);
dex = EROE(3);
dey = EROE(4);
dix = EROE(5);
diy = EROE(6);
de_min = norm([dex,dey]);
de_max = 1.1*de_min;
psi_nom = wrapTo2Pi(atan2(dey,dex));
psi_min = psi_nom - deg2rad(10);
psi_max = psi_nom + deg2rad(10);
diy_max = diy;
diy_min = 2*diy;
dlam_min = -1000/OE0(1);
dlam_max = 1000/OE0(1);
disp("Min RN Separation = " + string(computeMinSepControlWindows(OE0(1),OE0(2),de_min,psi_min,psi_max,dix,diy_min,diy_max)))

%% diy test
% t_analytical = diy_time(OE,EROE,diy_min,diy_max,environment.marsProperties)
% 
% STM = computeEccentricROE_STM(OE,environment.marsProperties.J2,environment.marsProperties.radius_m,environment.marsProperties.gravitationalParameter_m3_s2,t_analytical);
% EROE_result = STM*EROE;
% diy_result = EROE_result(6)

%% dlam test
% t_analytical = dlam_time(OE,EROE,dlam_min,dlam_max,environment.marsProperties)
% 
% STM = computeEccentricROE_STM(OE,environment.marsProperties.J2,environment.marsProperties.radius_m,environment.marsProperties.gravitationalParameter_m3_s2,t_analytical);
% EROE_result = STM*EROE;
% dlam_result = EROE_result(2)

%% de test
% t_analytical = de_time(OE,EROE,de_min,de_max,environment.marsProperties)
% 
% STM = computeEccentricROE_STM(OE,environment.marsProperties.J2,environment.marsProperties.radius_m,environment.marsProperties.gravitationalParameter_m3_s2,t_analytical);
% EROE_result = STM*EROE;
% de_result = norm(EROE_result(3:4))

%% psi test
% t_analytical = psi_time(OE,EROE,psi_min,psi_max,environment.marsProperties)
% 
% STM = computeEccentricROE_STM(OE,environment.marsProperties.J2,environment.marsProperties.radius_m,environment.marsProperties.gravitationalParameter_m3_s2,t_analytical);
% EROE_result = STM*EROE;
% psi_result = wrapTo2Pi(atan2(EROE_result(4),EROE_result(3)))

%% ROM Setup and Run
% t_duration = seconds(days(67));
Bchief = chief.properties.SRPcoefficient*chief.properties.area_m2/chief.properties.dryMass_kg;
Bdep = deputy1.properties.SRPcoefficient*deputy1.properties.area_m2/deputy1.properties.dryMass_kg;
dB = Bdep - Bchief;
tic
[times,flags,magnitudes,EROE_out] = computeManeuverTimes(OE0,EROE,de_min,de_max,psi_min,psi_max,diy_min,diy_max,dlam_min,dlam_max,t_duration,environment.marsProperties,environment.constants,dB,telem);
toc

%% Plotting
h = figure;
hold on;
grid on;
stairs([0,times]/86400,cumsum([0,magnitudes]),'LineWidth',2)
xlabel("Time [days]")
ylabel("$\Delta v$ [m/s]","Interpreter","latex")
fontsize(gcf,scale=1.5)
% saveas(h,figurepath + "rom_maitenance_dv.eps",'epsc')