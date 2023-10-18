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
[~,~,cartesianStateJ2] = propJ2(OE0,EROE0,...
    environment.marsProperties.J2,...
    environment.marsProperties.radius_m,...
    environment.marsProperties.gravitationalParameter_m3_s2,...
    time);

SunOE = [
    telem.("Sun OE.semiMajorAxis_m")(1); 
    telem.("Sun OE.eccentricity")(1); 
    telem.("Sun OE.inclination_rad")(1); 
    telem.("Sun OE.longitudeAscendingNode_rad")(1); 
    telem.("Sun OE.argumentPerigee_rad")(1); 
    telem.("Sun OE.MeanAnomaly_rad")(1)
];
Bchief = chief.properties.SRPcoefficient*chief.properties.area_m2/chief.properties.dryMass_kg;
Bdep = deputy1.properties.SRPcoefficient*deputy1.properties.area_m2/deputy1.properties.dryMass_kg;
dB = Bdep - Bchief;
[~,~,cartesianStateJ2plusSRP] = propJ2plusSRP(OE0,EROE0,SunOE,...
    environment.marsProperties.J2,...
    environment.marsProperties.radius_m,...
    environment.marsProperties.gravitationalParameter_m3_s2,...
    environment.constants,...
    dB,...
    time);
cartesianStateYA = propYA(OE0,EROE0,environment.marsProperties.gravitationalParameter_m3_s2,time);

EROE_true = zeros(6,length(time));
EROE_true(1,:) = telem.("Deputy 1 Mean EROE.relativeSemiMajorAxis")';
EROE_true(2,:) = telem.("Deputy 1 Mean EROE.relativeLongitude")';
EROE_true(3,:) = telem.("Deputy 1 Mean EROE.relativeEccentricityX")';
EROE_true(4,:) = telem.("Deputy 1 Mean EROE.relativeEccentricityY")';
EROE_true(5,:) = telem.("Deputy 1 Mean EROE.relativeInclinationX")';
EROE_true(6,:) = telem.("Deputy 1 Mean EROE.relativeInclinationY")';
cartesianStateTrue = zeros(6,length(time));
for i = 1:length(time)
    STM = cartesianGuffantiSolution(OE(:,i),0,environment.marsProperties.gravitationalParameter_m3_s2);
    cartesianStateTrue(:,i) = STM*EROE_true(:,i);
end

osc = 0;
if osc
    x_err_j2 = cartesianStateJ2(1,:) - telem.("Deputy 1 Relative Cartesian State.positionX_RTN_m")';
    y_err_j2 = cartesianStateJ2(2,:) - telem.("Deputy 1 Relative Cartesian State.positionY_RTN_m")';
    z_err_j2 = cartesianStateJ2(3,:) - telem.("Deputy 1 Relative Cartesian State.positionZ_RTN_m")';

    x_err_j2_srp = cartesianStateJ2plusSRP(1,:) - telem.("Deputy 1 Relative Cartesian State.positionX_RTN_m")';
    y_err_j2_srp = cartesianStateJ2plusSRP(2,:) - telem.("Deputy 1 Relative Cartesian State.positionY_RTN_m")';
    z_err_j2_srp = cartesianStateJ2plusSRP(3,:) - telem.("Deputy 1 Relative Cartesian State.positionZ_RTN_m")';

    x_err_ya = cartesianStateYA(1,:) - telem.("Deputy 1 Relative Cartesian State.positionX_RTN_m")';
    y_err_ya = cartesianStateYA(2,:) - telem.("Deputy 1 Relative Cartesian State.positionY_RTN_m")';
    z_err_ya = cartesianStateYA(3,:) - telem.("Deputy 1 Relative Cartesian State.positionZ_RTN_m")';
else
    x_err_j2 = cartesianStateJ2(1,:) - cartesianStateTrue(1,:);
    y_err_j2 = cartesianStateJ2(2,:) - cartesianStateTrue(2,:);
    z_err_j2 = cartesianStateJ2(3,:) - cartesianStateTrue(3,:);

    x_err_j2_srp = cartesianStateJ2plusSRP(1,:) - cartesianStateTrue(1,:);
    y_err_j2_srp = cartesianStateJ2plusSRP(2,:) - cartesianStateTrue(2,:);
    z_err_j2_srp = cartesianStateJ2plusSRP(3,:) - cartesianStateTrue(3,:);

    x_err_ya = cartesianStateYA(1,:) - cartesianStateTrue(1,:);
    y_err_ya = cartesianStateYA(2,:) - cartesianStateTrue(2,:);
    z_err_ya = cartesianStateYA(3,:) - cartesianStateTrue(3,:);
end
pos_err_j2 = sqrt(x_err_j2.^2+y_err_j2.^2+z_err_j2.^2);
pos_err_j2_srp = sqrt(x_err_j2_srp.^2+y_err_j2_srp.^2+z_err_j2_srp.^2);
pos_err_ya = sqrt(x_err_ya.^2+y_err_ya.^2+z_err_ya.^2);

% pos_err_j2 = pos_err_j2 - pos_err_j2(1);
% pos_err_j2_srp = pos_err_j2_srp - pos_err_j2_srp(1);
% pos_err_ya = pos_err_ya - pos_err_ya(1);

h = figure;
hold on;
plot(time/3600,movmean(pos_err_ya,1),"LineWidth",2)
plot(time/3600,movmean(pos_err_j2,1),"LineWidth",2)
plot(time/3600,movmean(pos_err_j2_srp,1),"LineWidth",2)
legend(["Yamanaka-Ankersen","EROE J2 STM","EROE J2+SRP STM"],'Location','southeast')
xlabel("Time [hr]")
xlim([0,time(end)/3600])
ylabel("Position Error [m]")
set(gca, 'YScale', 'log')
fontsize(gcf,scale=1.5)

hifi = 1;
if hifi
    saveas(h,figurepath + "sim_pos_err.eps",'epsc');
else
    saveas(h,figurepath + "sim_pos_err_mean.eps",'epsc');
end