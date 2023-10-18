%% Sim Config
dt = delta_t;
t_duration = seconds(t_final - t_epoch);

%% Environment
% Earth Properties 
environment.earthProperties.radius_m = 6.378e6;
environment.earthProperties.gravitationalParameter_m3_s2 = 3.986004419e14;
environment.earthProperties.J2 = 0.108263e-2;

% Mars Properties 
environment.marsProperties.radius_m = 3389.5e3;
environment.marsProperties.gravitationalParameter_m3_s2 = 4.2828372e13;
environment.marsProperties.J2 = 0.001960454;

% Sun Properties
environment.sunProperties.radius_m = 696340e3;
environment.sunProperties.gravitationalParameter_m3_s2 = 1.32712440042e20;
[environment.sunProperties.state, environment.sunProperties.time] = generateSunEphemeris(t_epoch,t_final+dt,60);
% environment.sunProperties.position = [0,0,0];
% environment.sunProperties.time = 0;
environment.sunProperties.solarPressure_N_m2 = 4.5344321e-6;

environment.constants.AU_m = 1.496e11;
environment.constants.c_mps = 299792458;
environment.constants.solarflux = 1367;

dt_sun = dt*floor(2*pi / meanMotion(environment.marsProperties.gravitationalParameter_m3_s2,chiefOE(1)) / dt);
% dt_sun = dt*100;

%% Chief Properties
% Physical Properties
chief.properties.SRPcoefficient = 1.29;
chief.properties.area_m2 = 3.34;
chief.properties.dryMass_kg = 327;

chief.properties.actuators.thruster.thrust_N = 0.0143;
chief.properties.actuators.thruster.isp_s = 68;

chief.properties.sensors.imu.bias_mps2 = [0;0;0];
chief.properties.sensors.imu.sensorCovariance_m2ps4 = 0.00014*eye(3);
chief.properties.sensors.imu.sensorSqrtCovariance_mps2 = sqrtm(chief.properties.sensors.imu.sensorCovariance_m2ps4);
chief.properties.sensors.imu.processCovariance_m2ps9 = (1e-8)*eye(3);
chief.properties.sensors.imu.processSqrtCovariance_mps3 = sqrtm(chief.properties.sensors.imu.processCovariance_m2ps9);

chief.properties.sensors.gps.positionBias_m = 10 * [1;1;1];
chief.properties.sensors.gps.positionCovariance_m2 =100*eye(3);
chief.properties.sensors.gps.positionSqrtCovariance_m = sqrtm(chief.properties.sensors.gps.positionCovariance_m2);
chief.properties.sensors.gps.velocityBias_mps = 10 * [1;1;1];
chief.properties.sensors.gps.velocityCovariance_m2ps2 = 10*eye(3);
chief.properties.sensors.gps.velocitySqrtCovariance_m2ps2 = sqrtm(chief.properties.sensors.gps.velocityCovariance_m2ps2);

% Initial Conditions
chief.initialConditions.mass_kg = 339;

chief.initialConditions.meanOrbitElements.semiMajorAxis_m = chiefOE(1);
chief.initialConditions.meanOrbitElements.eccentricity = chiefOE(2);
chief.initialConditions.meanOrbitElements.inclination_rad = chiefOE(3);
chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad = chiefOE(4);
chief.initialConditions.meanOrbitElements.argumentPerigee_rad = chiefOE(5);
chief.initialConditions.meanOrbitElements.MeanAnomaly_rad = chiefOE(6);

chiefOEqns = singular2quasiOE(chiefOE);
chief.initialConditions.meanOrbitElementsQNS.semiMajorAxis_m = chiefOEqns(1);
chief.initialConditions.meanOrbitElementsQNS.meanArgumentLatitude_rad = chiefOEqns(2);
chief.initialConditions.meanOrbitElementsQNS.eccentricityX = chiefOEqns(3);
chief.initialConditions.meanOrbitElementsQNS.eccentricityY = chiefOEqns(4);
chief.initialConditions.meanOrbitElementsQNS.inclination_rad = chiefOEqns(5);
chief.initialConditions.meanOrbitElementsQNS.longitudeAscendingNode_rad = chiefOEqns(6);
clear chiefOEqns

osc_oe = mean2osc([ ...
    chief.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    chief.initialConditions.meanOrbitElements.eccentricity, ...
    chief.initialConditions.meanOrbitElements.inclination_rad, ...
    chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    chief.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    chief.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],J2_flag,...
    environment.marsProperties.gravitationalParameter_m3_s2,...
    environment.marsProperties.J2,...
    environment.marsProperties.radius_m);

chief.initialConditions.osculatingOrbitElements.semiMajorAxis_m = osc_oe(1);
chief.initialConditions.osculatingOrbitElements.eccentricity = osc_oe(2);
chief.initialConditions.osculatingOrbitElements.inclination_rad = osc_oe(3);
chief.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad = osc_oe(4);
chief.initialConditions.osculatingOrbitElements.argumentPerigee_rad = osc_oe(5);
chief.initialConditions.osculatingOrbitElements.MeanAnomaly_rad = osc_oe(6);

chiefOEqns = singular2quasiOE(osc_oe);
chief.initialConditions.osculatingOrbitElementsQNS.semiMajorAxis_m = chiefOEqns(1);
chief.initialConditions.osculatingOrbitElementsQNS.meanArgumentLatitude_rad = chiefOEqns(2);
chief.initialConditions.osculatingOrbitElementsQNS.eccentricityX = chiefOEqns(3);
chief.initialConditions.osculatingOrbitElementsQNS.eccentricityY = chiefOEqns(4);
chief.initialConditions.osculatingOrbitElementsQNS.inclination_rad = chiefOEqns(5);
chief.initialConditions.osculatingOrbitElementsQNS.longitudeAscendingNode_rad = chiefOEqns(6);
clear chiefOEqns

[r_ijk,v_ijk] = oe2eci(...
    chief.initialConditions.osculatingOrbitElements.semiMajorAxis_m,...
    chief.initialConditions.osculatingOrbitElements.eccentricity,...
    chief.initialConditions.osculatingOrbitElements.inclination_rad,...
    chief.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad,...
    chief.initialConditions.osculatingOrbitElements.argumentPerigee_rad,...
    M2nu(chief.initialConditions.osculatingOrbitElements.MeanAnomaly_rad,chief.initialConditions.osculatingOrbitElements.eccentricity),...
    environment.marsProperties.gravitationalParameter_m3_s2);

chief.initialConditions.cartesianState.positionX_J2000_m = r_ijk(1);
chief.initialConditions.cartesianState.positionY_J2000_m = r_ijk(2);
chief.initialConditions.cartesianState.positionZ_J2000_m = r_ijk(3);
chief.initialConditions.cartesianState.velocityX_J2000_m = v_ijk(1);
chief.initialConditions.cartesianState.velocityY_J2000_m = v_ijk(2);
chief.initialConditions.cartesianState.velocityZ_J2000_m = v_ijk(3);
[~, R_eci2rtn] = eci2rtn([r_ijk; v_ijk]);
theta0_dot = computeTheta0_dot(norm(r_ijk),environment.earthProperties.gravitationalParameter_m3_s2,chief.initialConditions.osculatingOrbitElements.semiMajorAxis_m,chief.initialConditions.osculatingOrbitElements.eccentricity);
clear r_ijk v_ijk

%% Deputy 1 Properties
% Physical Properties
deputy1.properties.SRPcoefficient = 1.90;
deputy1.properties.area_m2 = 1.77;
deputy1.properties.dryMass_kg = 190;

deputy1.properties.actuators.thruster.thrust_N = 2.1;
deputy1.properties.actuators.thruster.isp_s = 235;

deputy1.properties.sensors.imu.bias_mps2 = [0;0;0];
deputy1.properties.sensors.imu.sensorCovariance_m2ps4 = 0.00014*eye(3);
deputy1.properties.sensors.imu.sensorSqrtCovariance_mps2 = sqrtm(deputy1.properties.sensors.imu.sensorCovariance_m2ps4);
deputy1.properties.sensors.imu.processCovariance_m2ps9 = (1e-8)*eye(3);
deputy1.properties.sensors.imu.processSqrtCovariance_mps3 = sqrtm(deputy1.properties.sensors.imu.processCovariance_m2ps9);

deputy1.properties.sensors.gps.positionBias_m = 10 * [1;1;1];
deputy1.properties.sensors.gps.positionCovariance_m2 = 100*eye(3);
deputy1.properties.sensors.gps.positionSqrtCovariance_m = sqrtm(deputy1.properties.sensors.gps.positionCovariance_m2);
deputy1.properties.sensors.gps.velocityBias_mps = 10 * [1;1;1];
deputy1.properties.sensors.gps.velocityCovariance_m2ps2 = 10*eye(3);
deputy1.properties.sensors.gps.velocitySqrtCovariance_m2ps2 = sqrtm(deputy1.properties.sensors.gps.velocityCovariance_m2ps2);
% Initial Conditions
deputy1.initialConditions.mass_kg = 211;

deputy1.initialConditions.meanOrbitElements.semiMajorAxis_m = deputy1OE(1);
deputy1.initialConditions.meanOrbitElements.eccentricity = deputy1OE(2);
deputy1.initialConditions.meanOrbitElements.inclination_rad = deputy1OE(3);
deputy1.initialConditions.meanOrbitElements.longitudeAscendingNode_rad = deputy1OE(4);
deputy1.initialConditions.meanOrbitElements.argumentPerigee_rad = deputy1OE(5);
deputy1.initialConditions.meanOrbitElements.MeanAnomaly_rad = deputy1OE(6);

deputyOEqns = singular2quasiOE(deputy1OE);
deputy1.initialConditions.meanOrbitElementsQNS.semiMajorAxis_m = deputyOEqns(1);
deputy1.initialConditions.meanOrbitElementsQNS.meanArgumentLatitude_rad = deputyOEqns(2);
deputy1.initialConditions.meanOrbitElementsQNS.eccentricityX = deputyOEqns(3);
deputy1.initialConditions.meanOrbitElementsQNS.eccentricityY = deputyOEqns(4);
deputy1.initialConditions.meanOrbitElementsQNS.inclination_rad = deputyOEqns(5);
deputy1.initialConditions.meanOrbitElementsQNS.longitudeAscendingNode_rad = deputyOEqns(6);

osc_oe = mean2osc([ ...
    deputy1.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    deputy1.initialConditions.meanOrbitElements.eccentricity, ...
    deputy1.initialConditions.meanOrbitElements.inclination_rad, ...
    deputy1.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    deputy1.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    deputy1.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],J2_flag,...
    environment.marsProperties.gravitationalParameter_m3_s2,...
    environment.marsProperties.J2,...
    environment.marsProperties.radius_m);

deputy1.initialConditions.osculatingOrbitElements.semiMajorAxis_m = osc_oe(1);
deputy1.initialConditions.osculatingOrbitElements.eccentricity = osc_oe(2);
deputy1.initialConditions.osculatingOrbitElements.inclination_rad = osc_oe(3);
deputy1.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad = osc_oe(4);
deputy1.initialConditions.osculatingOrbitElements.argumentPerigee_rad = osc_oe(5);
deputy1.initialConditions.osculatingOrbitElements.MeanAnomaly_rad = osc_oe(6);

deputyOEqns = singular2quasiOE(osc_oe);
deputy1.initialConditions.osculatingOrbitElementsQNS.semiMajorAxis_m = deputyOEqns(1);
deputy1.initialConditions.osculatingOrbitElementsQNS.meanArgumentLatitude_rad = deputyOEqns(2);
deputy1.initialConditions.osculatingOrbitElementsQNS.eccentricityX = deputyOEqns(3);
deputy1.initialConditions.osculatingOrbitElementsQNS.eccentricityY = deputyOEqns(4);
deputy1.initialConditions.osculatingOrbitElementsQNS.inclination_rad = deputyOEqns(5);
deputy1.initialConditions.osculatingOrbitElementsQNS.longitudeAscendingNode_rad = deputyOEqns(6);
clear deputyOEqns

[r_ijk,v_ijk] = oe2eci(...
    deputy1.initialConditions.osculatingOrbitElements.semiMajorAxis_m,...
    deputy1.initialConditions.osculatingOrbitElements.eccentricity,...
    deputy1.initialConditions.osculatingOrbitElements.inclination_rad,...
    deputy1.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad,...
    deputy1.initialConditions.osculatingOrbitElements.argumentPerigee_rad,...
    M2nu(deputy1.initialConditions.osculatingOrbitElements.MeanAnomaly_rad,deputy1.initialConditions.osculatingOrbitElements.eccentricity),...
    environment.marsProperties.gravitationalParameter_m3_s2);

deputy1.initialConditions.cartesianState.positionX_J2000_m = r_ijk(1);
deputy1.initialConditions.cartesianState.positionY_J2000_m = r_ijk(2);
deputy1.initialConditions.cartesianState.positionZ_J2000_m = r_ijk(3);
deputy1.initialConditions.cartesianState.velocityX_J2000_m = v_ijk(1);
deputy1.initialConditions.cartesianState.velocityY_J2000_m = v_ijk(2);
deputy1.initialConditions.cartesianState.velocityZ_J2000_m = v_ijk(3);
clear r_ijk v_ijk
clear osc_oe mean_oe

%% Deputy 2 Properties
% Physical Properties
deputy2.properties.SRPcoefficient = 1.90;
deputy2.properties.area_m2 = 1.77;
deputy2.properties.dryMass_kg = 190;

deputy2.properties.actuators.thruster.thrust_N = 2.1;
deputy2.properties.actuators.thruster.isp_s = 235;

deputy2.properties.sensors.imu.bias_mps2 = [0;0;0];
deputy2.properties.sensors.imu.sensorCovariance_m2ps4 = 0.00014*eye(3);
deputy2.properties.sensors.imu.sensorSqrtCovariance_mps2 = sqrtm(deputy2.properties.sensors.imu.sensorCovariance_m2ps4);
deputy2.properties.sensors.imu.processCovariance_m2ps9 = (1e-8)*eye(3);
deputy2.properties.sensors.imu.processSqrtCovariance_mps3 = sqrtm(deputy2.properties.sensors.imu.processCovariance_m2ps9);

deputy2.properties.sensors.gps.positionBias_m = 10 * [1;1;1];
deputy2.properties.sensors.gps.positionCovariance_m2 = 100*eye(3);
deputy2.properties.sensors.gps.positionSqrtCovariance_m = sqrtm(deputy2.properties.sensors.gps.positionCovariance_m2);
deputy2.properties.sensors.gps.velocityBias_mps = 10 * [1;1;1];
deputy2.properties.sensors.gps.velocityCovariance_m2ps2 = 10*eye(3);
deputy2.properties.sensors.gps.velocitySqrtCovariance_m2ps2 = sqrtm(deputy2.properties.sensors.gps.velocityCovariance_m2ps2);
% Initial Conditions
deputy2.initialConditions.mass_kg = 211;

deputy2.initialConditions.meanOrbitElements.semiMajorAxis_m = deputy2OE(1);
deputy2.initialConditions.meanOrbitElements.eccentricity = deputy2OE(2);
deputy2.initialConditions.meanOrbitElements.inclination_rad = deputy2OE(3);
deputy2.initialConditions.meanOrbitElements.longitudeAscendingNode_rad = deputy2OE(4);
deputy2.initialConditions.meanOrbitElements.argumentPerigee_rad = deputy2OE(5);
deputy2.initialConditions.meanOrbitElements.MeanAnomaly_rad = deputy2OE(6);

deputyOEqns = singular2quasiOE(deputy2OE);
deputy2.initialConditions.meanOrbitElementsQNS.semiMajorAxis_m = deputyOEqns(1);
deputy2.initialConditions.meanOrbitElementsQNS.meanArgumentLatitude_rad = deputyOEqns(2);
deputy2.initialConditions.meanOrbitElementsQNS.eccentricityX = deputyOEqns(3);
deputy2.initialConditions.meanOrbitElementsQNS.eccentricityY = deputyOEqns(4);
deputy2.initialConditions.meanOrbitElementsQNS.inclination_rad = deputyOEqns(5);
deputy2.initialConditions.meanOrbitElementsQNS.longitudeAscendingNode_rad = deputyOEqns(6);

osc_oe = mean2osc([ ...
    deputy2.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    deputy2.initialConditions.meanOrbitElements.eccentricity, ...
    deputy2.initialConditions.meanOrbitElements.inclination_rad, ...
    deputy2.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    deputy2.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    deputy2.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],J2_flag,...
    environment.marsProperties.gravitationalParameter_m3_s2,...
    environment.marsProperties.J2,...
    environment.marsProperties.radius_m);

deputy2.initialConditions.osculatingOrbitElements.semiMajorAxis_m = osc_oe(1);
deputy2.initialConditions.osculatingOrbitElements.eccentricity = osc_oe(2);
deputy2.initialConditions.osculatingOrbitElements.inclination_rad = osc_oe(3);
deputy2.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad = osc_oe(4);
deputy2.initialConditions.osculatingOrbitElements.argumentPerigee_rad = osc_oe(5);
deputy2.initialConditions.osculatingOrbitElements.MeanAnomaly_rad = osc_oe(6);

deputyOEqns = singular2quasiOE(osc_oe);
deputy2.initialConditions.osculatingOrbitElementsQNS.semiMajorAxis_m = deputyOEqns(1);
deputy2.initialConditions.osculatingOrbitElementsQNS.meanArgumentLatitude_rad = deputyOEqns(2);
deputy2.initialConditions.osculatingOrbitElementsQNS.eccentricityX = deputyOEqns(3);
deputy2.initialConditions.osculatingOrbitElementsQNS.eccentricityY = deputyOEqns(4);
deputy2.initialConditions.osculatingOrbitElementsQNS.inclination_rad = deputyOEqns(5);
deputy2.initialConditions.osculatingOrbitElementsQNS.longitudeAscendingNode_rad = deputyOEqns(6);
clear deputyOEqns

[r_ijk,v_ijk] = oe2eci(...
    deputy2.initialConditions.osculatingOrbitElements.semiMajorAxis_m,...
    deputy2.initialConditions.osculatingOrbitElements.eccentricity,...
    deputy2.initialConditions.osculatingOrbitElements.inclination_rad,...
    deputy2.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad,...
    deputy2.initialConditions.osculatingOrbitElements.argumentPerigee_rad,...
    M2nu(deputy2.initialConditions.osculatingOrbitElements.MeanAnomaly_rad,deputy2.initialConditions.osculatingOrbitElements.eccentricity),...
    environment.marsProperties.gravitationalParameter_m3_s2);

deputy2.initialConditions.cartesianState.positionX_J2000_m = r_ijk(1);
deputy2.initialConditions.cartesianState.positionY_J2000_m = r_ijk(2);
deputy2.initialConditions.cartesianState.positionZ_J2000_m = r_ijk(3);
deputy2.initialConditions.cartesianState.velocityX_J2000_m = v_ijk(1);
deputy2.initialConditions.cartesianState.velocityY_J2000_m = v_ijk(2);
deputy2.initialConditions.cartesianState.velocityZ_J2000_m = v_ijk(3);
clear r_ijk v_ijk
clear osc_oe mean_oe

%% Relative RTN States
% Deputy 1
relativeState(1, 1) = deputy1.initialConditions.cartesianState.positionX_J2000_m - chief.initialConditions.cartesianState.positionX_J2000_m;
relativeState(2, 1) = deputy1.initialConditions.cartesianState.positionY_J2000_m - chief.initialConditions.cartesianState.positionY_J2000_m;
relativeState(3, 1) = deputy1.initialConditions.cartesianState.positionZ_J2000_m - chief.initialConditions.cartesianState.positionZ_J2000_m;
relativeState(4, 1) = deputy1.initialConditions.cartesianState.velocityX_J2000_m - chief.initialConditions.cartesianState.velocityX_J2000_m;
relativeState(5, 1) = deputy1.initialConditions.cartesianState.velocityY_J2000_m - chief.initialConditions.cartesianState.velocityY_J2000_m;
relativeState(6, 1) = deputy1.initialConditions.cartesianState.velocityZ_J2000_m - chief.initialConditions.cartesianState.velocityZ_J2000_m;
relativeState = vI2vRTN(relativeState, theta0_dot, R_eci2rtn);
deputy1.initialConditions.relativeCartesianState.positionX_RTN_m = relativeState(1);
deputy1.initialConditions.relativeCartesianState.positionY_RTN_m = relativeState(2);
deputy1.initialConditions.relativeCartesianState.positionZ_RTN_m = relativeState(3);
deputy1.initialConditions.relativeCartesianState.velocityX_RTN_m = relativeState(4);
deputy1.initialConditions.relativeCartesianState.velocityY_RTN_m = relativeState(5);
deputy1.initialConditions.relativeCartesianState.velocityZ_RTN_m = relativeState(6);

chief.initialConditions.relativeCartesianState.positionX_RTN_m = -relativeState(1);
chief.initialConditions.relativeCartesianState.positionY_RTN_m = -relativeState(2);
chief.initialConditions.relativeCartesianState.positionZ_RTN_m = -relativeState(3);
chief.initialConditions.relativeCartesianState.velocityX_RTN_m = -relativeState(4);
chief.initialConditions.relativeCartesianState.velocityY_RTN_m = -relativeState(5);
chief.initialConditions.relativeCartesianState.velocityZ_RTN_m = -relativeState(6);

% Deputy 2
relativeState(1, 1) = deputy2.initialConditions.cartesianState.positionX_J2000_m - chief.initialConditions.cartesianState.positionX_J2000_m;
relativeState(2, 1) = deputy2.initialConditions.cartesianState.positionY_J2000_m - chief.initialConditions.cartesianState.positionY_J2000_m;
relativeState(3, 1) = deputy2.initialConditions.cartesianState.positionZ_J2000_m - chief.initialConditions.cartesianState.positionZ_J2000_m;
relativeState(4, 1) = deputy2.initialConditions.cartesianState.velocityX_J2000_m - chief.initialConditions.cartesianState.velocityX_J2000_m;
relativeState(5, 1) = deputy2.initialConditions.cartesianState.velocityY_J2000_m - chief.initialConditions.cartesianState.velocityY_J2000_m;
relativeState(6, 1) = deputy2.initialConditions.cartesianState.velocityZ_J2000_m - chief.initialConditions.cartesianState.velocityZ_J2000_m;
relativeState = vI2vRTN(relativeState, theta0_dot, R_eci2rtn);
deputy2.initialConditions.relativeCartesianState.positionX_RTN_m = relativeState(1);
deputy2.initialConditions.relativeCartesianState.positionY_RTN_m = relativeState(2);
deputy2.initialConditions.relativeCartesianState.positionZ_RTN_m = relativeState(3);
deputy2.initialConditions.relativeCartesianState.velocityX_RTN_m = relativeState(4);
deputy2.initialConditions.relativeCartesianState.velocityY_RTN_m = relativeState(5);
deputy2.initialConditions.relativeCartesianState.velocityZ_RTN_m = relativeState(6);

chief.initialConditions.relativeCartesianState.positionX_RTN_m = -relativeState(1);
chief.initialConditions.relativeCartesianState.positionY_RTN_m = -relativeState(2);
chief.initialConditions.relativeCartesianState.positionZ_RTN_m = -relativeState(3);
chief.initialConditions.relativeCartesianState.velocityX_RTN_m = -relativeState(4);
chief.initialConditions.relativeCartesianState.velocityY_RTN_m = -relativeState(5);
chief.initialConditions.relativeCartesianState.velocityZ_RTN_m = -relativeState(6);

clear theta0_dot R_eci2rtn
clear relativeState
%% Eccentric Singular Relative Orbit Elements
% Deputy 1
eccentricSingularROE = computeEccentricSingularROE([ ...
    chief.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    chief.initialConditions.meanOrbitElements.eccentricity, ...
    chief.initialConditions.meanOrbitElements.inclination_rad, ...
    chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    chief.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    chief.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],[ ...
    deputy1.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    deputy1.initialConditions.meanOrbitElements.eccentricity, ...
    deputy1.initialConditions.meanOrbitElements.inclination_rad, ...
    deputy1.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    deputy1.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    deputy1.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ]);
deputy1.initialConditions.eccentricSingularROE.relativeSemiMajorAxis = eccentricSingularROE(1);
deputy1.initialConditions.eccentricSingularROE.relativeLongitude = eccentricSingularROE(2);
deputy1.initialConditions.eccentricSingularROE.relativeEccentricityX = eccentricSingularROE(3);
deputy1.initialConditions.eccentricSingularROE.relativeEccentricityY = eccentricSingularROE(4);
deputy1.initialConditions.eccentricSingularROE.relativeInclinationX = eccentricSingularROE(5);
deputy1.initialConditions.eccentricSingularROE.relativeInclinationY = eccentricSingularROE(6);

% Deputy 2
eccentricSingularROE = computeEccentricSingularROE([ ...
    chief.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    chief.initialConditions.meanOrbitElements.eccentricity, ...
    chief.initialConditions.meanOrbitElements.inclination_rad, ...
    chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    chief.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    chief.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],[ ...
    deputy2.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    deputy2.initialConditions.meanOrbitElements.eccentricity, ...
    deputy2.initialConditions.meanOrbitElements.inclination_rad, ...
    deputy2.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    deputy2.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    deputy2.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ]);
deputy2.initialConditions.eccentricSingularROE.relativeSemiMajorAxis = eccentricSingularROE(1);
deputy2.initialConditions.eccentricSingularROE.relativeLongitude = eccentricSingularROE(2);
deputy2.initialConditions.eccentricSingularROE.relativeEccentricityX = eccentricSingularROE(3);
deputy2.initialConditions.eccentricSingularROE.relativeEccentricityY = eccentricSingularROE(4);
deputy2.initialConditions.eccentricSingularROE.relativeInclinationX = eccentricSingularROE(5);
deputy2.initialConditions.eccentricSingularROE.relativeInclinationY = eccentricSingularROE(6);

% Chief (Temp)
chief.initialConditions.eccentricSingularROE.relativeSemiMajorAxis = 0;
chief.initialConditions.eccentricSingularROE.relativeLongitude = 0;
chief.initialConditions.eccentricSingularROE.relativeEccentricityX = 0;
chief.initialConditions.eccentricSingularROE.relativeEccentricityY = 0;
chief.initialConditions.eccentricSingularROE.relativeInclinationX = 0;
chief.initialConditions.eccentricSingularROE.relativeInclinationY = 0;

%% Eccentric Quasi-Nonsingular Relative Orbit Elements
% Deputy 1
eccentricQNSROE = computeEccentricQNSROE([ ...
    chief.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    chief.initialConditions.meanOrbitElements.eccentricity, ...
    chief.initialConditions.meanOrbitElements.inclination_rad, ...
    chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    chief.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    chief.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],[ ...
    deputy1.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    deputy1.initialConditions.meanOrbitElements.eccentricity, ...
    deputy1.initialConditions.meanOrbitElements.inclination_rad, ...
    deputy1.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    deputy1.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    deputy1.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ]);
deputy1.initialConditions.eccentricQuasiNonsingularROE.relativeSemiMajorAxis = eccentricQNSROE(1);
deputy1.initialConditions.eccentricQuasiNonsingularROE.relativeLongitude = eccentricQNSROE(2);
deputy1.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityX = eccentricQNSROE(3);
deputy1.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityY = eccentricQNSROE(4);
deputy1.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationX = eccentricQNSROE(5);
deputy1.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationY = eccentricQNSROE(6);

% Deputy 2
eccentricQNSROE = computeEccentricQNSROE([ ...
    chief.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    chief.initialConditions.meanOrbitElements.eccentricity, ...
    chief.initialConditions.meanOrbitElements.inclination_rad, ...
    chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    chief.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    chief.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],[ ...
    deputy2.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    deputy2.initialConditions.meanOrbitElements.eccentricity, ...
    deputy2.initialConditions.meanOrbitElements.inclination_rad, ...
    deputy2.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    deputy2.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    deputy2.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ]);
deputy2.initialConditions.eccentricQuasiNonsingularROE.relativeSemiMajorAxis = eccentricQNSROE(1);
deputy2.initialConditions.eccentricQuasiNonsingularROE.relativeLongitude = eccentricQNSROE(2);
deputy2.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityX = eccentricQNSROE(3);
deputy2.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityY = eccentricQNSROE(4);
deputy2.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationX = eccentricQNSROE(5);
deputy2.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationY = eccentricQNSROE(6);

chief.initialConditions.eccentricQuasiNonsingularROE.relativeSemiMajorAxis = 0;
chief.initialConditions.eccentricQuasiNonsingularROE.relativeLongitude = 0;
chief.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityX = 0;
chief.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityY = 0;
chief.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationX = 0;
chief.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationY = 0;

clear eccentricQNSROE
%% Generate Environment Bus
% Environment
environmentBus          = createBus(environment);
constants               = createBus(environment.constants);
planetProperties         = createBus(environment.earthProperties);
earthProperties         = createBus(environment.earthProperties);
sunProperties           = createBus(environment.sunProperties);
marsProperties           = createBus(environment.marsProperties);
environmentBus          = addToBus(environmentBus,"constants","bus");
environmentBus          = addToBus(environmentBus,"earthProperties","bus");
environmentBus          = addToBus(environmentBus,"sunProperties","bus");
environmentBus          = addToBus(environmentBus,"marsProperties","bus");

%% Generate Chief Bus
chiefBus            = createBus(chief);
actuators           = createBus(chief.properties.actuators);
thruster            = createBus(chief.properties.actuators.thruster);
actuators           = addToBus(actuators,"thruster","bus");

sensors             = createBus(chief.properties.sensors);
imu                 = createBus(chief.properties.sensors.imu);
gps                 = createBus(chief.properties.sensors.gps);
sensors             = addToBus(sensors,"imu","bus");
sensors             = addToBus(sensors,"gps","bus");

properties          = createBus(chief.properties);
properties          = addToBus(properties,"actuators","bus");
properties          = addToBus(properties,"sensors","bus");


meanOrbitElements   = createBus(chief.initialConditions.meanOrbitElements);
meanOrbitElementsQNS = createBus(chief.initialConditions.meanOrbitElementsQNS);
osculatingOrbitElements   = createBus(chief.initialConditions.osculatingOrbitElements);
osculatingOrbitElementsQNS   = createBus(chief.initialConditions.osculatingOrbitElementsQNS);
cartesianState      = createBus(chief.initialConditions.cartesianState);
relativeCartesianState = createBus(chief.initialConditions.relativeCartesianState);
eccentricSingularROE = createBus(chief.initialConditions.eccentricSingularROE);
eccentricQuasiNonsingularROE = createBus(chief.initialConditions.eccentricQuasiNonsingularROE);

initialConditions   = createBus(chief.initialConditions);
initialConditions   = addToBus(initialConditions,"meanOrbitElements","bus");
initialConditions   = addToBus(initialConditions,"meanOrbitElementsQNS","bus");
initialConditions   = addToBus(initialConditions,"osculatingOrbitElements","bus");
initialConditions   = addToBus(initialConditions,"osculatingOrbitElementsQNS","bus");
initialConditions   = addToBus(initialConditions,"cartesianState","bus");
initialConditions   = addToBus(initialConditions, "relativeCartesianState", "bus");
initialConditions   = addToBus(initialConditions,"eccentricSingularROE","bus");
initialConditions   = addToBus(initialConditions,"eccentricQuasiNonsingularROE","bus");

chiefBus               = addToBus(chiefBus,"properties","bus");
chiefBus               = addToBus(chiefBus,"initialConditions","bus");

%% Generate Deputy 1 Bus
deputy1Bus            = createBus(chief);
deputy1Bus              = addToBus(deputy1Bus, "properties","bus");
deputy1Bus              = addToBus(deputy1Bus,"initialConditions","bus");

%% Generate Deputy 2 Bus
deputy2Bus            = createBus(chief);
deputy2Bus              = addToBus(deputy2Bus, "properties","bus");
deputy2Bus              = addToBus(deputy2Bus,"initialConditions","bus");

%% Generate GNC Buses
dt_gnc = dt;
deputy1state = Simulink.Bus;
deputy1state = addToBus(deputy1state,'cartesianState','bus');
deputy1state = addToBus(deputy1state,'relativeCartesianState','bus');
deputy1state = addToBus(deputy1state,'osculatingOrbitElements','bus');
osculatingEROE = eccentricSingularROE;
deputy1state = addToBus(deputy1state,'osculatingEROE','bus');
deputy1state = addToBus(deputy1state,'meanOrbitElements','bus');
meanEROE = eccentricSingularROE;
deputy1state = addToBus(deputy1state,'meanEROE','bus');
deputy2state = deputy1state;
deputystate = deputy1state;

chiefState = Simulink.Bus;
chiefState = addToBus(chiefState,'cartesianState','bus');
chiefState = addToBus(chiefState,'osculatingOrbitElements','bus');
chiefState = addToBus(chiefState,'meanOrbitElements','bus');

plant2gnc = Simulink.Bus;
plant2gnc = addToBus(plant2gnc,'chiefState','bus');
plant2gnc = addToBus(plant2gnc,'deputy1state','bus');
plant2gnc = addToBus(plant2gnc,'deputy2state','bus');

dv_default = [0;0;0];

gnc2plant = Simulink.Bus;
deltaVdeputy1 = dv_default;
deltaVdeputy2 = dv_default;
gnc2plant = addToBus(gnc2plant,'deltaVdeputy1','real');
gnc2plant = addToBus(gnc2plant,'deltaVdeputy2','real');