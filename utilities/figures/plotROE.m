% Get Chief OEs
OE0 = [
    telem.("Chief Mean OE.semiMajorAxis_m")(1);
    telem.("Chief Mean OE.eccentricity")(1);
    telem.("Chief Mean OE.inclination_rad")(1);
    telem.("Chief Mean OE.longitudeAscendingNode_rad")(1);
    telem.("Chief Mean OE.argumentPerigee_rad")(1);
    telem.("Chief Mean OE.MeanAnomaly_rad")(1);
];
OE = [
    telem.("Chief Mean OE.semiMajorAxis_m")';
    telem.("Chief Mean OE.eccentricity")';
    telem.("Chief Mean OE.inclination_rad")';
    telem.("Chief Mean OE.longitudeAscendingNode_rad")';
    telem.("Chief Mean OE.argumentPerigee_rad")';
    telem.("Chief Mean OE.MeanAnomaly_rad")';
];
SunOE = [
    telem.("Sun OE.semiMajorAxis_m")(1); 
    telem.("Sun OE.eccentricity")(1); 
    telem.("Sun OE.inclination_rad")(1); 
    telem.("Sun OE.longitudeAscendingNode_rad")(1); 
    telem.("Sun OE.argumentPerigee_rad")(1); 
    telem.("Sun OE.MeanAnomaly_rad")(1)
];
% Deputy 1
% First, generate linearized solution:
EROE0 = [
    telem.("Deputy 1 Mean EROE.relativeSemiMajorAxis")(1);
    telem.("Deputy 1 Mean EROE.relativeLongitude")(1);
    telem.("Deputy 1 Mean EROE.relativeEccentricityX")(1);
    telem.("Deputy 1 Mean EROE.relativeEccentricityY")(1);
    telem.("Deputy 1 Mean EROE.relativeInclinationX")(1);
    telem.("Deputy 1 Mean EROE.relativeInclinationY")(1);
];
[EROE1j2,~,~] = propJ2(OE0,EROE0,...
    environment.marsProperties.J2,...
    environment.marsProperties.radius_m,...
    environment.marsProperties.gravitationalParameter_m3_s2,...
    time);

Bchief = chief.properties.SRPcoefficient*chief.properties.area_m2/chief.properties.dryMass_kg;
Bdep = deputy1.properties.SRPcoefficient*deputy1.properties.area_m2/deputy1.properties.dryMass_kg;
dB = Bdep - Bchief;
[EROE1j2srp,~,~] = propJ2plusSRP(OE0,EROE0,SunOE,...
    environment.marsProperties.J2,...
    environment.marsProperties.radius_m,...
    environment.marsProperties.gravitationalParameter_m3_s2,...
    environment.constants,...
    dB,...
    time);
if J2_flag && srp_flag
    EROE1 = EROE1j2srp;
elseif J2_flag
    EROE1 = EROE1j2;
end

h = figure;
a = chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
set(gcf,'Position',[100 100 600 800])
subplot(6,1,1)
% title("Relative Semi-Major Axis")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeSemiMajorAxis"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeSemiMajorAxis"),LineWidth=2)
plot(time/3600,a*EROE1(1,:),LineWidth=2,LineStyle="--")
legend(["Osculating","J2+SRP STM"])
% xlabel("t [hr]")
ylabel('$a\delta a$ [m]','Interpreter','latex',"FontSize",12)

subplot(6,1,2)
% title("Relative Longitude")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeLongitude"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeLongitude"),LineWidth=2)
plot(time/3600,a*EROE1(2,:),LineWidth=2,LineStyle="--")
% legend(["Osculating","Mean Linear"])
% xlabel("t [hr]")
ylabel("$a\delta \lambda$ [m]",'Interpreter','latex',"FontSize",12)

subplot(6,1,3)
% title("Relative Eccentricity X")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeEccentricityX"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeEccentricityX"),LineWidth=2)
plot(time/3600,a*EROE1(3,:),LineWidth=2,LineStyle="--")
% legend(["Osculating","Mean Linear"])
% xlabel("t [hr]")
ylabel("$a\delta e_x$ [m]",'Interpreter','latex',"FontSize",12)

subplot(6,1,4)
% title("Relative Eccentricity Y")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeEccentricityY"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeEccentricityY"),LineWidth=2)
plot(time/3600,a*EROE1(4,:),LineWidth=2,LineStyle="--")
% legend(["Osculating","Mean Linear"])
% xlabel("t [hr]")
ylabel("$a\delta e_y$ [m]",'Interpreter','latex',"FontSize",12)

subplot(6,1,5)
% title("Relative Inclination X")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeInclinationX"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeInclinationX"),LineWidth=2)
plot(time/3600,a*EROE1(5,:),LineWidth=2,LineStyle="--")
% legend(["Osculating","Mean Linear"])
% xlabel("t [hr]")
ylabel("$a\delta i_x$ [m]",'Interpreter','latex',"FontSize",12)

subplot(6,1,6)
% title("Relative Inclination Y")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeInclinationY"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeInclinationY"),LineWidth=2)
plot(time/3600,a*EROE1(6,:),LineWidth=2,LineStyle="--")
% legend(["Osculating","Mean Linear"])
xlabel("t [hr]")
ylabel("$a\delta i_y$ [m]",'Interpreter','latex',"FontSize",12)

fontsize(gcf,scale=1.5)
saveas(h,figurepath + "sim_eroe_osc_vs_mean.eps",'epsc')



% Deputy 2
% First, generate linearized solution:
EROE0 = [
    telem.("Deputy 2 Mean EROE.relativeSemiMajorAxis")(1);
    telem.("Deputy 2 Mean EROE.relativeLongitude")(1);
    telem.("Deputy 2 Mean EROE.relativeEccentricityX")(1);
    telem.("Deputy 2 Mean EROE.relativeEccentricityY")(1);
    telem.("Deputy 2 Mean EROE.relativeInclinationX")(1);
    telem.("Deputy 2 Mean EROE.relativeInclinationY")(1);
];
[EROE2j2,~,~] = propJ2(OE0,EROE0,...
    environment.marsProperties.J2,...
    environment.marsProperties.radius_m,...
    environment.marsProperties.gravitationalParameter_m3_s2,...
    time);

Bchief = chief.properties.SRPcoefficient*chief.properties.area_m2/chief.properties.dryMass_kg;
Bdep = deputy2.properties.SRPcoefficient*deputy2.properties.area_m2/deputy2.properties.dryMass_kg;
dB = Bdep - Bchief;
[EROE2j2srp,~,~] = propJ2plusSRP(OE0,EROE0,SunOE,...
    environment.marsProperties.J2,...
    environment.marsProperties.radius_m,...
    environment.marsProperties.gravitationalParameter_m3_s2,...
    environment.constants,...
    dB,...
    time);
if J2_flag && srp_flag
    EROE2 = EROE2j2srp;
elseif J2_flag
    EROE2 = EROE2j2;
end

figure
a = chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
set(gcf,'Position',[100 100 1200 800])
subplot(3,2,1)
title("Relative Semi-Major Axis")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 2 Mean EROE.relativeSemiMajorAxis"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 2 Osculating EROE.relativeSemiMajorAxis"),LineWidth=2)
plot(time/3600,a*EROE2(1,:),LineWidth=2,LineStyle="--")
legend(["Osculating","Mean Linear"])
xlabel("t [hr]")
ylabel('$a\delta a$ [m]','Interpreter','latex',"FontSize",20)

subplot(3,2,2)
title("Relative Longitude")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 2 Mean EROE.relativeLongitude"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 2 Osculating EROE.relativeLongitude"),LineWidth=2)
plot(time/3600,a*EROE2(2,:),LineWidth=2,LineStyle="--")
legend(["Osculating","Mean Linear"])
xlabel("t [hr]")
ylabel("$a\delta \lambda$ [m]",'Interpreter','latex',"FontSize",20)

subplot(3,2,3)
title("Relative Eccentricity X")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 2 Mean EROE.relativeEccentricityX"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 2 Osculating EROE.relativeEccentricityX"),LineWidth=2)
plot(time/3600,a*EROE2(3,:),LineWidth=2,LineStyle="--")
legend(["Osculating","Mean Linear"])
xlabel("t [hr]")
ylabel("$a\delta e_x$ [m]",'Interpreter','latex',"FontSize",20)

subplot(3,2,4)
title("Relative Eccentricity Y")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 2 Mean EROE.relativeEccentricityY"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 2 Osculating EROE.relativeEccentricityY"),LineWidth=2)
plot(time/3600,a*EROE2(4,:),LineWidth=2,LineStyle="--")
legend(["Osculating","Mean Linear"])
xlabel("t [hr]")
ylabel("$a\delta e_y$",'Interpreter','latex',"FontSize",20)

subplot(3,2,5)
title("Relative Inclination X")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 2 Mean EROE.relativeInclinationX"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 2 Osculating EROE.relativeInclinationX"),LineWidth=2)
plot(time/3600,a*EROE2(5,:),LineWidth=2,LineStyle="--")
legend(["Osculating","Mean Linear"])
xlabel("t [hr]")
ylabel("$a\delta i_x$",'Interpreter','latex',"FontSize",20)

subplot(3,2,6)
title("Relative Inclination Y")
grid on;
hold on;
% plot(time/3600,a*telem.("Deputy 2 Mean EROE.relativeInclinationY"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 2 Osculating EROE.relativeInclinationY"),LineWidth=2)
plot(time/3600,a*EROE2(6,:),LineWidth=2,LineStyle="--")
legend(["Osculating","Mean Linear"])
xlabel("t [hr]")
ylabel("$a\delta i_y$",'Interpreter','latex',"FontSize",20)
clear a