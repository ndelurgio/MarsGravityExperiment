%% Init Bus & Struct
plantBus = Simulink.Bus;
plant = struct();
gncBus = Simulink.Bus;
gnc = struct();

%% Sim Config
dt = delta_t;
t_duration = seconds(t_final - t_epoch);

%% Environment
% Earth Properties 
plant.environment.earthProperties.radius_m = 6.378e6;
plant.environment.earthProperties.gravitationalParameter_m3_s2 = 3.986004419e14;
plant.environment.earthProperties.J2 = 0.108263e-2;
plant.environment.earthProperties.J2_flag = J2_flag;

% Sun Properties
plant.environment.sunProperties.radius_m = 696340e3;
plant.environment.sunProperties.gravitationalParameter_m3_s2 = 1.32712440042e20;
[plant.environment.sunProperties.position, plant.environment.sunProperties.time] = generateSunEphemeris(t_epoch,t_final,60);
plant.environment.sunProperties.solarPressure_N_m2 = 4.5344321e-6;
plant.environment.sunProperties.srp_flag = srp_flag;

plant.environment.constants.AU_m = 1.496e11;

%% Chief Properties
% Physical Properties
plant.chief.properties.SRPcoefficient = 1.29;
plant.chief.properties.area_m2 = 3.34;
plant.chief.properties.dryMass_kg = 327;

plant.chief.properties.actuators.thruster.thrust_N = 0.0143;
plant.chief.properties.actuators.thruster.isp_s = 68;

plant.chief.properties.sensors.imu.bias_mps2 = [0;0;0];
plant.chief.properties.sensors.imu.sensorCovariance_m2ps4 = 0.00014*eye(3);
plant.chief.properties.sensors.imu.sensorSqrtCovariance_mps2 = sqrtm(plant.chief.properties.sensors.imu.sensorCovariance_m2ps4);
plant.chief.properties.sensors.imu.processCovariance_m2ps9 = (1e-8)*eye(3);
plant.chief.properties.sensors.imu.processSqrtCovariance_mps3 = sqrtm(plant.chief.properties.sensors.imu.processCovariance_m2ps9);

plant.chief.properties.sensors.gps.positionBias_m = 10 * [1;1;1];
plant.chief.properties.sensors.gps.positionCovariance_m2 =100*eye(3);
plant.chief.properties.sensors.gps.positionSqrtCovariance_m = sqrtm(plant.chief.properties.sensors.gps.positionCovariance_m2);
plant.chief.properties.sensors.gps.velocityBias_mps = 10 * [1;1;1];
plant.chief.properties.sensors.gps.velocityCovariance_m2ps2 = 10*eye(3);
plant.chief.properties.sensors.gps.velocitySqrtCovariance_m2ps2 = sqrtm(plant.chief.properties.sensors.gps.velocityCovariance_m2ps2);

% Initial Conditions
plant.chief.initialConditions.mass_kg = 339;

plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m = chiefOE(1);
plant.chief.initialConditions.meanOrbitElements.eccentricity = chiefOE(2);
plant.chief.initialConditions.meanOrbitElements.inclination_rad = chiefOE(3);
plant.chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad = chiefOE(4);
plant.chief.initialConditions.meanOrbitElements.argumentPerigee_rad = chiefOE(5);
plant.chief.initialConditions.meanOrbitElements.MeanAnomaly_rad = chiefOE(6);

chiefOEqns = singular2quasiOE(chiefOE);
plant.chief.initialConditions.meanOrbitElementsQNS.semiMajorAxis_m = chiefOEqns(1);
plant.chief.initialConditions.meanOrbitElementsQNS.meanArgumentLatitude_rad = chiefOEqns(2);
plant.chief.initialConditions.meanOrbitElementsQNS.eccentricityX = chiefOEqns(3);
plant.chief.initialConditions.meanOrbitElementsQNS.eccentricityY = chiefOEqns(4);
plant.chief.initialConditions.meanOrbitElementsQNS.inclination_rad = chiefOEqns(5);
plant.chief.initialConditions.meanOrbitElementsQNS.longitudeAscendingNode_rad = chiefOEqns(6);
clear chiefOEqns

osc_oe = mean2osc([ ...
    plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    plant.chief.initialConditions.meanOrbitElements.eccentricity, ...
    plant.chief.initialConditions.meanOrbitElements.inclination_rad, ...
    plant.chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    plant.chief.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    plant.chief.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],plant.environment.earthProperties.J2_flag);

plant.chief.initialConditions.osculatingOrbitElements.semiMajorAxis_m = osc_oe(1);
plant.chief.initialConditions.osculatingOrbitElements.eccentricity = osc_oe(2);
plant.chief.initialConditions.osculatingOrbitElements.inclination_rad = osc_oe(3);
plant.chief.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad = osc_oe(4);
plant.chief.initialConditions.osculatingOrbitElements.argumentPerigee_rad = osc_oe(5);
plant.chief.initialConditions.osculatingOrbitElements.MeanAnomaly_rad = osc_oe(6);

chiefOEqns = singular2quasiOE(osc_oe);
plant.chief.initialConditions.osculatingOrbitElementsQNS.semiMajorAxis_m = chiefOEqns(1);
plant.chief.initialConditions.osculatingOrbitElementsQNS.meanArgumentLatitude_rad = chiefOEqns(2);
plant.chief.initialConditions.osculatingOrbitElementsQNS.eccentricityX = chiefOEqns(3);
plant.chief.initialConditions.osculatingOrbitElementsQNS.eccentricityY = chiefOEqns(4);
plant.chief.initialConditions.osculatingOrbitElementsQNS.inclination_rad = chiefOEqns(5);
plant.chief.initialConditions.osculatingOrbitElementsQNS.longitudeAscendingNode_rad = chiefOEqns(6);

[r_ijk,v_ijk] = oe2eci(...
    plant.chief.initialConditions.osculatingOrbitElements.semiMajorAxis_m,...
    plant.chief.initialConditions.osculatingOrbitElements.eccentricity,...
    plant.chief.initialConditions.osculatingOrbitElements.inclination_rad,...
    plant.chief.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad,...
    plant.chief.initialConditions.osculatingOrbitElements.argumentPerigee_rad,...
    M2nu(plant.chief.initialConditions.osculatingOrbitElements.MeanAnomaly_rad,plant.chief.initialConditions.osculatingOrbitElements.eccentricity),...
    plant.environment.earthProperties.gravitationalParameter_m3_s2);

plant.chief.initialConditions.cartesianState.positionX_J2000_m = r_ijk(1);
plant.chief.initialConditions.cartesianState.positionY_J2000_m = r_ijk(2);
plant.chief.initialConditions.cartesianState.positionZ_J2000_m = r_ijk(3);
plant.chief.initialConditions.cartesianState.velocityX_J2000_m = v_ijk(1);
plant.chief.initialConditions.cartesianState.velocityY_J2000_m = v_ijk(2);
plant.chief.initialConditions.cartesianState.velocityZ_J2000_m = v_ijk(3);
[~, R_eci2rtn] = eci2rtn([r_ijk; v_ijk]);
theta0_dot = computeTheta0_dot(norm(r_ijk),plant.environment.earthProperties.gravitationalParameter_m3_s2,plant.chief.initialConditions.osculatingOrbitElements.semiMajorAxis_m,plant.chief.initialConditions.osculatingOrbitElements.eccentricity);
% clear r_ijk v_ijk

%% Deputy Properties
% Physical Properties
plant.deputy.properties.SRPcoefficient = 1.90;
plant.deputy.properties.area_m2 = 1.77;
plant.deputy.properties.dryMass_kg = 190;

plant.deputy.properties.actuators.thruster.thrust_N = 2.1;
plant.deputy.properties.actuators.thruster.isp_s = 235;

plant.deputy.properties.sensors.imu.bias_mps2 = [0;0;0];
plant.deputy.properties.sensors.imu.sensorCovariance_m2ps4 = 0.00014*eye(3);
plant.deputy.properties.sensors.imu.sensorSqrtCovariance_mps2 = sqrtm(plant.deputy.properties.sensors.imu.sensorCovariance_m2ps4);
plant.deputy.properties.sensors.imu.processCovariance_m2ps9 = (1e-8)*eye(3);
plant.deputy.properties.sensors.imu.processSqrtCovariance_mps3 = sqrtm(plant.deputy.properties.sensors.imu.processCovariance_m2ps9);

plant.deputy.properties.sensors.gps.positionBias_m = 10 * [1;1;1];
plant.deputy.properties.sensors.gps.positionCovariance_m2 = 100*eye(3);
plant.deputy.properties.sensors.gps.positionSqrtCovariance_m = sqrtm(plant.deputy.properties.sensors.gps.positionCovariance_m2);
plant.deputy.properties.sensors.gps.velocityBias_mps = 10 * [1;1;1];
plant.deputy.properties.sensors.gps.velocityCovariance_m2ps2 = 10*eye(3);
plant.deputy.properties.sensors.gps.velocitySqrtCovariance_m2ps2 = sqrtm(plant.deputy.properties.sensors.gps.velocityCovariance_m2ps2);
% Initial Conditions
plant.deputy.initialConditions.mass_kg = 211;

plant.deputy.initialConditions.meanOrbitElements.semiMajorAxis_m = deputyOE(1);
plant.deputy.initialConditions.meanOrbitElements.eccentricity = deputyOE(2);
plant.deputy.initialConditions.meanOrbitElements.inclination_rad = deputyOE(3);
plant.deputy.initialConditions.meanOrbitElements.longitudeAscendingNode_rad = deputyOE(4);
plant.deputy.initialConditions.meanOrbitElements.argumentPerigee_rad = deputyOE(5);
plant.deputy.initialConditions.meanOrbitElements.MeanAnomaly_rad = deputyOE(6);

deputyOEqns = singular2quasiOE(deputyOE);
plant.deputy.initialConditions.meanOrbitElementsQNS.semiMajorAxis_m = deputyOEqns(1);
plant.deputy.initialConditions.meanOrbitElementsQNS.meanArgumentLatitude_rad = deputyOEqns(2);
plant.deputy.initialConditions.meanOrbitElementsQNS.eccentricityX = deputyOEqns(3);
plant.deputy.initialConditions.meanOrbitElementsQNS.eccentricityY = deputyOEqns(4);
plant.deputy.initialConditions.meanOrbitElementsQNS.inclination_rad = deputyOEqns(5);
plant.deputy.initialConditions.meanOrbitElementsQNS.longitudeAscendingNode_rad = deputyOEqns(6);

osc_oe = mean2osc([ ...
    plant.deputy.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    plant.deputy.initialConditions.meanOrbitElements.eccentricity, ...
    plant.deputy.initialConditions.meanOrbitElements.inclination_rad, ...
    plant.deputy.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    plant.deputy.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    plant.deputy.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],plant.environment.earthProperties.J2_flag);

plant.deputy.initialConditions.osculatingOrbitElements.semiMajorAxis_m = osc_oe(1);
plant.deputy.initialConditions.osculatingOrbitElements.eccentricity = osc_oe(2);
plant.deputy.initialConditions.osculatingOrbitElements.inclination_rad = osc_oe(3);
plant.deputy.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad = osc_oe(4);
plant.deputy.initialConditions.osculatingOrbitElements.argumentPerigee_rad = osc_oe(5);
plant.deputy.initialConditions.osculatingOrbitElements.MeanAnomaly_rad = osc_oe(6);

deputyOEqns = singular2quasiOE(osc_oe);
plant.deputy.initialConditions.osculatingOrbitElementsQNS.semiMajorAxis_m = deputyOEqns(1);
plant.deputy.initialConditions.osculatingOrbitElementsQNS.meanArgumentLatitude_rad = deputyOEqns(2);
plant.deputy.initialConditions.osculatingOrbitElementsQNS.eccentricityX = deputyOEqns(3);
plant.deputy.initialConditions.osculatingOrbitElementsQNS.eccentricityY = deputyOEqns(4);
plant.deputy.initialConditions.osculatingOrbitElementsQNS.inclination_rad = deputyOEqns(5);
plant.deputy.initialConditions.osculatingOrbitElementsQNS.longitudeAscendingNode_rad = deputyOEqns(6);
clear deputyOEqns

[r_ijk,v_ijk] = oe2eci(...
    plant.deputy.initialConditions.osculatingOrbitElements.semiMajorAxis_m,...
    plant.deputy.initialConditions.osculatingOrbitElements.eccentricity,...
    plant.deputy.initialConditions.osculatingOrbitElements.inclination_rad,...
    plant.deputy.initialConditions.osculatingOrbitElements.longitudeAscendingNode_rad,...
    plant.deputy.initialConditions.osculatingOrbitElements.argumentPerigee_rad,...
    M2nu(plant.deputy.initialConditions.osculatingOrbitElements.MeanAnomaly_rad,plant.deputy.initialConditions.osculatingOrbitElements.eccentricity),...
    plant.environment.earthProperties.gravitationalParameter_m3_s2);

plant.deputy.initialConditions.cartesianState.positionX_J2000_m = r_ijk(1);
plant.deputy.initialConditions.cartesianState.positionY_J2000_m = r_ijk(2);
plant.deputy.initialConditions.cartesianState.positionZ_J2000_m = r_ijk(3);
plant.deputy.initialConditions.cartesianState.velocityX_J2000_m = v_ijk(1);
plant.deputy.initialConditions.cartesianState.velocityY_J2000_m = v_ijk(2);
plant.deputy.initialConditions.cartesianState.velocityZ_J2000_m = v_ijk(3);
% clear r_ijk v_ijk
clear osc_oe mean_oe
%% Relative RTN States
relativeState(1, 1) = plant.deputy.initialConditions.cartesianState.positionX_J2000_m - plant.chief.initialConditions.cartesianState.positionX_J2000_m;
relativeState(2, 1) = plant.deputy.initialConditions.cartesianState.positionY_J2000_m - plant.chief.initialConditions.cartesianState.positionY_J2000_m;
relativeState(3, 1) = plant.deputy.initialConditions.cartesianState.positionZ_J2000_m - plant.chief.initialConditions.cartesianState.positionZ_J2000_m;
relativeState(4, 1) = plant.deputy.initialConditions.cartesianState.velocityX_J2000_m - plant.chief.initialConditions.cartesianState.velocityX_J2000_m;
relativeState(5, 1) = plant.deputy.initialConditions.cartesianState.velocityY_J2000_m - plant.chief.initialConditions.cartesianState.velocityY_J2000_m;
relativeState(6, 1) = plant.deputy.initialConditions.cartesianState.velocityZ_J2000_m - plant.chief.initialConditions.cartesianState.velocityZ_J2000_m;
relativeState = vI2vRTN(relativeState, theta0_dot, R_eci2rtn);
plant.deputy.initialConditions.relativeCartesianState.positionX_RTN_m = relativeState(1);
plant.deputy.initialConditions.relativeCartesianState.positionY_RTN_m = relativeState(2);
plant.deputy.initialConditions.relativeCartesianState.positionZ_RTN_m = relativeState(3);
plant.deputy.initialConditions.relativeCartesianState.velocityX_RTN_m = relativeState(4);
plant.deputy.initialConditions.relativeCartesianState.velocityY_RTN_m = relativeState(5);
plant.deputy.initialConditions.relativeCartesianState.velocityZ_RTN_m = relativeState(6);

plant.chief.initialConditions.relativeCartesianState.positionX_RTN_m = -relativeState(1);
plant.chief.initialConditions.relativeCartesianState.positionY_RTN_m = -relativeState(2);
plant.chief.initialConditions.relativeCartesianState.positionZ_RTN_m = -relativeState(3);
plant.chief.initialConditions.relativeCartesianState.velocityX_RTN_m = -relativeState(4);
plant.chief.initialConditions.relativeCartesianState.velocityY_RTN_m = -relativeState(5);
plant.chief.initialConditions.relativeCartesianState.velocityZ_RTN_m = -relativeState(6);

clear theta0_dot R_eci2rtn
%% Orbit Element Differences

plant.deputy.initialConditions.orbitElementDifferences.deltaSemiMajorAxis_m             = plant.deputy.initialConditions.meanOrbitElements.semiMajorAxis_m - plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
plant.deputy.initialConditions.orbitElementDifferences.deltaEccentricity                = plant.deputy.initialConditions.meanOrbitElements.eccentricity - plant.chief.initialConditions.meanOrbitElements.eccentricity;
plant.deputy.initialConditions.orbitElementDifferences.deltaInclination_rad             = plant.deputy.initialConditions.meanOrbitElements.inclination_rad - plant.chief.initialConditions.meanOrbitElements.inclination_rad;
plant.deputy.initialConditions.orbitElementDifferences.deltaLongitudeAscendingNode_rad  = plant.deputy.initialConditions.meanOrbitElements.longitudeAscendingNode_rad - plant.chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad;
plant.deputy.initialConditions.orbitElementDifferences.deltaArgumentPerigee_rad         = plant.deputy.initialConditions.meanOrbitElements.argumentPerigee_rad - plant.chief.initialConditions.meanOrbitElements.argumentPerigee_rad;
plant.deputy.initialConditions.orbitElementDifferences.deltaMeanAnomaly_rad             = plant.deputy.initialConditions.meanOrbitElements.MeanAnomaly_rad - plant.chief.initialConditions.meanOrbitElements.MeanAnomaly_rad;

plant.chief.initialConditions.orbitElementDifferences.deltaSemiMajorAxis_m             = -plant.deputy.initialConditions.orbitElementDifferences.deltaSemiMajorAxis_m;
plant.chief.initialConditions.orbitElementDifferences.deltaEccentricity                = -plant.deputy.initialConditions.orbitElementDifferences.deltaEccentricity;
plant.chief.initialConditions.orbitElementDifferences.deltaInclination_rad             = -plant.deputy.initialConditions.orbitElementDifferences.deltaInclination_rad;
plant.chief.initialConditions.orbitElementDifferences.deltaLongitudeAscendingNode_rad  = -plant.deputy.initialConditions.orbitElementDifferences.deltaLongitudeAscendingNode_rad;
plant.chief.initialConditions.orbitElementDifferences.deltaArgumentPerigee_rad         = -plant.deputy.initialConditions.orbitElementDifferences.deltaArgumentPerigee_rad;
plant.chief.initialConditions.orbitElementDifferences.deltaMeanAnomaly_rad             = -plant.deputy.initialConditions.orbitElementDifferences.deltaMeanAnomaly_rad;

%% HCW Integration Constants
% HCWIntConstantsDeputy = computeHCWIntConstants([plant.deputy.initialConditions.relativeCartesianState.positionX_RTN_m,plant.deputy.initialConditions.relativeCartesianState.positionY_RTN_m,plant.deputy.initialConditions.relativeCartesianState.positionZ_RTN_m,plant.deputy.initialConditions.relativeCartesianState.velocityX_RTN_m,plant.deputy.initialConditions.relativeCartesianState.velocityY_RTN_m,plant.deputy.initialConditions.relativeCartesianState.velocityZ_RTN_m]',plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m,plant.environment.earthProperties.gravitationalParameter_m3_s2);
% HCWIntConstantsChief  = computeHCWIntConstants([plant.chief.initialConditions.relativeCartesianState.positionX_RTN_m,plant.chief.initialConditions.relativeCartesianState.positionY_RTN_m,plant.chief.initialConditions.relativeCartesianState.positionZ_RTN_m,plant.chief.initialConditions.relativeCartesianState.velocityX_RTN_m,plant.chief.initialConditions.relativeCartesianState.velocityY_RTN_m,plant.chief.initialConditions.relativeCartesianState.velocityZ_RTN_m]',plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m,plant.environment.earthProperties.gravitationalParameter_m3_s2);
% 
% 
% plant.deputy.initialConditions.integrationConstants_HCW.K1 = HCWIntConstantsDeputy(1);
% plant.deputy.initialConditions.integrationConstants_HCW.K2 = HCWIntConstantsDeputy(2);
% plant.deputy.initialConditions.integrationConstants_HCW.K3 = HCWIntConstantsDeputy(3);
% plant.deputy.initialConditions.integrationConstants_HCW.K4 = HCWIntConstantsDeputy(4);
% plant.deputy.initialConditions.integrationConstants_HCW.K5 = HCWIntConstantsDeputy(5);
% plant.deputy.initialConditions.integrationConstants_HCW.K6 = HCWIntConstantsDeputy(6);
% 
% plant.chief.initialConditions.integrationConstants_HCW.K1 = HCWIntConstantsChief(1);
% plant.chief.initialConditions.integrationConstants_HCW.K2 = HCWIntConstantsChief(2);
% plant.chief.initialConditions.integrationConstants_HCW.K3 = HCWIntConstantsChief(3);
% plant.chief.initialConditions.integrationConstants_HCW.K4 = HCWIntConstantsChief(4);
% plant.chief.initialConditions.integrationConstants_HCW.K5 = HCWIntConstantsChief(5);
% plant.chief.initialConditions.integrationConstants_HCW.K6 = HCWIntConstantsChief(6);

% clear HCWIntConstantsDeputy HCWIntConstantsChief
%% YA Integration Constants
% nuChief = M2nu(plant.chief.initialConditions.meanOrbitElements.MeanAnomaly_rad, plant.chief.initialConditions.meanOrbitElements.eccentricity);
% nuDeputy = M2nu(plant.deputy.initialConditions.meanOrbitElements.MeanAnomaly_rad, plant.deputy.initialConditions.meanOrbitElements.eccentricity);
% 
% YAIntConstantsDeputy = computeYAIntConstants(relativeState,plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m,plant.chief.initialConditions.meanOrbitElements.eccentricity,nuChief,plant.environment.earthProperties.gravitationalParameter_m3_s2);
% YAIntConstantsChief  = computeYAIntConstants(relativeState,plant.deputy.initialConditions.meanOrbitElements.semiMajorAxis_m,plant.deputy.initialConditions.meanOrbitElements.eccentricity,nuDeputy,plant.environment.earthProperties.gravitationalParameter_m3_s2);
% 
% plant.deputy.initialConditions.integrationConstants_YA.K1 = YAIntConstantsDeputy(1);
% plant.deputy.initialConditions.integrationConstants_YA.K2 = YAIntConstantsDeputy(2);
% plant.deputy.initialConditions.integrationConstants_YA.K3 = YAIntConstantsDeputy(3);
% plant.deputy.initialConditions.integrationConstants_YA.K4 = YAIntConstantsDeputy(4);
% plant.deputy.initialConditions.integrationConstants_YA.K5 = YAIntConstantsDeputy(5);
% plant.deputy.initialConditions.integrationConstants_YA.K6 = YAIntConstantsDeputy(6);
% 
% plant.chief.initialConditions.integrationConstants_YA.K1 = YAIntConstantsChief(1);
% plant.chief.initialConditions.integrationConstants_YA.K2 = YAIntConstantsChief(2);
% plant.chief.initialConditions.integrationConstants_YA.K3 = YAIntConstantsChief(3);
% plant.chief.initialConditions.integrationConstants_YA.K4 = YAIntConstantsChief(4);
% plant.chief.initialConditions.integrationConstants_YA.K5 = YAIntConstantsChief(5);
% plant.chief.initialConditions.integrationConstants_YA.K6 = YAIntConstantsChief(6);

% clear YAIntConstantsDeputy YAIntConstantsChief nuChief nuDeputy
% 
% clear relativeState

%% Eccentric Singular Relative Orbit Elements
eccentricSingularROE = computeEccentricSingularROE([ ...
    plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    plant.chief.initialConditions.meanOrbitElements.eccentricity, ...
    plant.chief.initialConditions.meanOrbitElements.inclination_rad, ...
    plant.chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    plant.chief.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    plant.chief.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],[ ...
    plant.deputy.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    plant.deputy.initialConditions.meanOrbitElements.eccentricity, ...
    plant.deputy.initialConditions.meanOrbitElements.inclination_rad, ...
    plant.deputy.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    plant.deputy.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    plant.deputy.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ]);
plant.deputy.initialConditions.eccentricSingularROE.relativeSemiMajorAxis = eccentricSingularROE(1);
plant.deputy.initialConditions.eccentricSingularROE.relativeLongitude = eccentricSingularROE(2);
plant.deputy.initialConditions.eccentricSingularROE.relativeEccentricityX = eccentricSingularROE(3);
plant.deputy.initialConditions.eccentricSingularROE.relativeEccentricityY = eccentricSingularROE(4);
plant.deputy.initialConditions.eccentricSingularROE.relativeInclinationX = eccentricSingularROE(5);
plant.deputy.initialConditions.eccentricSingularROE.relativeInclinationY = eccentricSingularROE(6);

plant.chief.initialConditions.eccentricSingularROE.relativeSemiMajorAxis = -eccentricSingularROE(1);
plant.chief.initialConditions.eccentricSingularROE.relativeLongitude = -eccentricSingularROE(2);
plant.chief.initialConditions.eccentricSingularROE.relativeEccentricityX = -eccentricSingularROE(3);
plant.chief.initialConditions.eccentricSingularROE.relativeEccentricityY = -eccentricSingularROE(4);
plant.chief.initialConditions.eccentricSingularROE.relativeInclinationX = -eccentricSingularROE(5);
plant.chief.initialConditions.eccentricSingularROE.relativeInclinationY = -eccentricSingularROE(6);

%% Eccentric Quasi-Nonsingular Relative Orbit Elements
eccentricQNSROE = computeEccentricQNSROE([ ...
    plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    plant.chief.initialConditions.meanOrbitElements.eccentricity, ...
    plant.chief.initialConditions.meanOrbitElements.inclination_rad, ...
    plant.chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    plant.chief.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    plant.chief.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ],[ ...
    plant.deputy.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
    plant.deputy.initialConditions.meanOrbitElements.eccentricity, ...
    plant.deputy.initialConditions.meanOrbitElements.inclination_rad, ...
    plant.deputy.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
    plant.deputy.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
    plant.deputy.initialConditions.meanOrbitElements.MeanAnomaly_rad...
    ]);
plant.deputy.initialConditions.eccentricQuasiNonsingularROE.relativeSemiMajorAxis = eccentricQNSROE(1);
plant.deputy.initialConditions.eccentricQuasiNonsingularROE.relativeLongitude = eccentricQNSROE(2);
plant.deputy.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityX = eccentricQNSROE(3);
plant.deputy.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityY = eccentricQNSROE(4);
plant.deputy.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationX = eccentricQNSROE(5);
plant.deputy.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationY = eccentricQNSROE(6);

plant.chief.initialConditions.eccentricQuasiNonsingularROE.relativeSemiMajorAxis = -eccentricQNSROE(1);
plant.chief.initialConditions.eccentricQuasiNonsingularROE.relativeLongitude = -eccentricQNSROE(2);
plant.chief.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityX = -eccentricQNSROE(3);
plant.chief.initialConditions.eccentricQuasiNonsingularROE.relativeEccentricityY = -eccentricQNSROE(4);
plant.chief.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationX = -eccentricQNSROE(5);
plant.chief.initialConditions.eccentricQuasiNonsingularROE.relativeInclinationY = -eccentricQNSROE(6);

clear eccentricQNSROE
%% D'Amico Relative Orbit Elements
% damicoROE = computeROE_damico([ ...
%     plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
%     plant.chief.initialConditions.meanOrbitElements.eccentricity, ...
%     plant.chief.initialConditions.meanOrbitElements.inclination_rad, ...
%     plant.chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
%     plant.chief.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
%     plant.chief.initialConditions.meanOrbitElements.MeanAnomaly_rad...
%     ],[ ...
%     plant.deputy.initialConditions.meanOrbitElements.semiMajorAxis_m, ...
%     plant.deputy.initialConditions.meanOrbitElements.eccentricity, ...
%     plant.deputy.initialConditions.meanOrbitElements.inclination_rad, ...
%     plant.deputy.initialConditions.meanOrbitElements.longitudeAscendingNode_rad, ...
%     plant.deputy.initialConditions.meanOrbitElements.argumentPerigee_rad, ...
%     plant.deputy.initialConditions.meanOrbitElements.MeanAnomaly_rad...
%     ]);
% plant.deputy.initialConditions.damicoROE.relativeSemiMajorAxis = damicoROE(1);
% plant.deputy.initialConditions.damicoROE.relativeLongitude = damicoROE(2);
% plant.deputy.initialConditions.damicoROE.relativeEccentricityX = damicoROE(3);
% plant.deputy.initialConditions.damicoROE.relativeEccentricityY = damicoROE(4);
% plant.deputy.initialConditions.damicoROE.relativeInclinationX = damicoROE(5);
% plant.deputy.initialConditions.damicoROE.relativeInclinationY = damicoROE(6);
% 
% plant.chief.initialConditions.damicoROE.relativeSemiMajorAxis = -damicoROE(1);
% plant.chief.initialConditions.damicoROE.relativeLongitude = -damicoROE(2);
% plant.chief.initialConditions.damicoROE.relativeEccentricityX = -damicoROE(3);
% plant.chief.initialConditions.damicoROE.relativeEccentricityY = -damicoROE(4);
% plant.chief.initialConditions.damicoROE.relativeInclinationX = -damicoROE(5);
% plant.chief.initialConditions.damicoROE.relativeInclinationY = -damicoROE(6);
% 
% clear damicoROE

%% GNC
% gnc.modes.science = deg2rad([170, 190]);
% gnc.modes.formationBreak = deg2rad([190, 192.2]);
% gnc.modes.passive = deg2rad([192.2, 163.6]);
% gnc.modes.formationAcquisition = deg2rad([163.6, 170]);
% plant.chief.initialConditions.cartesianState
% gnc.navigation.stateInit = [
%     plant.chief.initialConditions.cartesianState.positionX_J2000_m;
%     plant.chief.initialConditions.cartesianState.positionY_J2000_m;
%     plant.chief.initialConditions.cartesianState.positionZ_J2000_m;
%     plant.chief.initialConditions.cartesianState.velocityX_J2000_m;
%     plant.chief.initialConditions.cartesianState.velocityY_J2000_m;
%     plant.chief.initialConditions.cartesianState.velocityZ_J2000_m;
% 
%     plant.deputy.initialConditions.cartesianState.positionX_J2000_m;
%     plant.deputy.initialConditions.cartesianState.positionY_J2000_m;
%     plant.deputy.initialConditions.cartesianState.positionZ_J2000_m;
%     plant.deputy.initialConditions.cartesianState.velocityX_J2000_m;
%     plant.deputy.initialConditions.cartesianState.velocityY_J2000_m;
%     plant.deputy.initialConditions.cartesianState.velocityZ_J2000_m;
% 
%     plant.chief.properties.sensors.gps.positionBias_m;
%     plant.chief.properties.sensors.gps.velocityBias_mps;
% 
%     plant.chief.properties.sensors.imu.bias_mps2;
%     plant.deputy.properties.sensors.imu.bias_mps2
% ];
% gnc.navigation.measurementInit = [
%     plant.chief.initialConditions.cartesianState.positionX_J2000_m + plant.chief.properties.sensors.gps.positionBias_m(1);
%     plant.chief.initialConditions.cartesianState.positionY_J2000_m + plant.chief.properties.sensors.gps.positionBias_m(2);
%     plant.chief.initialConditions.cartesianState.positionZ_J2000_m + plant.chief.properties.sensors.gps.positionBias_m(3);
%     plant.chief.initialConditions.cartesianState.velocityX_J2000_m + plant.chief.properties.sensors.gps.velocityBias_mps(1);
%     plant.chief.initialConditions.cartesianState.velocityY_J2000_m + plant.chief.properties.sensors.gps.velocityBias_mps(2);
%     plant.chief.initialConditions.cartesianState.velocityZ_J2000_m + plant.chief.properties.sensors.gps.velocityBias_mps(3);
%     zeros(3,1);
% 
%     plant.deputy.initialConditions.cartesianState.positionX_J2000_m + plant.deputy.properties.sensors.gps.positionBias_m(1);
%     plant.deputy.initialConditions.cartesianState.positionY_J2000_m + plant.deputy.properties.sensors.gps.positionBias_m(2);
%     plant.deputy.initialConditions.cartesianState.positionZ_J2000_m + plant.deputy.properties.sensors.gps.positionBias_m(3);
%     plant.deputy.initialConditions.cartesianState.velocityX_J2000_m + plant.deputy.properties.sensors.gps.velocityBias_mps(1);
%     plant.deputy.initialConditions.cartesianState.velocityY_J2000_m + plant.deputy.properties.sensors.gps.velocityBias_mps(2);
%     plant.deputy.initialConditions.cartesianState.velocityZ_J2000_m + plant.deputy.properties.sensors.gps.velocityBias_mps(3);
%     zeros(3,1);
% 
% ];
% 
% covInit = eye(length(gnc.navigation.stateInit));
% covInit(19:24,19:24) = 0.01*eye(6);
% gnc.navigation.covarianceInit = covInit;
% 
% R = zeros(18,18);
% R(1:3,1:3) = plant.chief.properties.sensors.gps.positionCovariance_m2;
% R(4:6,4:6) = plant.chief.properties.sensors.gps.velocityCovariance_m2ps2;
% R(7:9,7:9) = plant.chief.properties.sensors.imu.sensorCovariance_m2ps4;
% R(10:12,10:12) = plant.deputy.properties.sensors.gps.positionCovariance_m2;
% R(13:15,13:15) = plant.deputy.properties.sensors.gps.velocityCovariance_m2ps2;
% R(16:18,16:18) = plant.deputy.properties.sensors.imu.sensorCovariance_m2ps4;
% gnc.navigation.R = R;
% 
% Q = eye(24);
% Q(4:6,4:6) = 0.1*eye(3);
% Q(10:12,10:12) = 0.1*eye(3);
% Q(13:24,13:24) = (1e-8)*eye(12);
% gnc.navigation.Q = Q;
% 
% enableGNC = 1;
% UKF = 1;

%% Generate GNC Bus
% modes               = createBus(gnc.modes);
% navigation          = createBus(gnc.navigation);
% gncBus              = addToBus(gncBus, "modes", "bus");
% gncBus              = addToBus(gncBus, "navigation", "bus");

%% Generate Plant Bus
% Environment
environment         = createBus(plant.environment);
constants           = createBus(plant.environment.constants);
earthProperties     = createBus(plant.environment.earthProperties);
sunProperties       = createBus(plant.environment.sunProperties);
environment         = addToBus(environment,"constants","bus");
environment         = addToBus(environment,"earthProperties","bus");
environment         = addToBus(environment,"sunProperties","bus");
plantBus            = addToBus(plantBus,"environment","bus");

% Chief
chief               = createBus(plant.chief);
actuators           = createBus(plant.chief.properties.actuators);
thruster            = createBus(plant.chief.properties.actuators.thruster);
actuators           = addToBus(actuators,"thruster","bus");

sensors             = createBus(plant.chief.properties.sensors);
imu                 = createBus(plant.chief.properties.sensors.imu);
gps                 = createBus(plant.chief.properties.sensors.gps);
sensors             = addToBus(sensors,"imu","bus");
sensors             = addToBus(sensors,"gps","bus");

properties          = createBus(plant.chief.properties);
properties          = addToBus(properties,"actuators","bus");
properties          = addToBus(properties,"sensors","bus");


meanOrbitElements   = createBus(plant.chief.initialConditions.meanOrbitElements);
meanOrbitElementsQNS = createBus(plant.chief.initialConditions.meanOrbitElementsQNS);
osculatingOrbitElements   = createBus(plant.chief.initialConditions.osculatingOrbitElements);
osculatingOrbitElementsQNS   = createBus(plant.chief.initialConditions.osculatingOrbitElementsQNS);
cartesianState      = createBus(plant.chief.initialConditions.cartesianState);
relativeCartesianState = createBus(plant.chief.initialConditions.relativeCartesianState);
orbitElementDifferences = createBus(plant.chief.initialConditions.orbitElementDifferences);
integrationConstants_HCW = createBus(plant.chief.initialConditions.integrationConstants_HCW);
integrationConstants_YA = createBus(plant.chief.initialConditions.integrationConstants_YA);
eccentricSingularROE = createBus(plant.chief.initialConditions.eccentricSingularROE);
eccentricQuasiNonsingularROE = createBus(plant.chief.initialConditions.eccentricQuasiNonsingularROE);
damicoROE = createBus(plant.chief.initialConditions.damicoROE);

initialConditions   = createBus(plant.chief.initialConditions);
initialConditions   = addToBus(initialConditions,"meanOrbitElements","bus");
initialConditions   = addToBus(initialConditions,"meanOrbitElementsQNS","bus");
initialConditions   = addToBus(initialConditions,"osculatingOrbitElements","bus");
initialConditions   = addToBus(initialConditions,"osculatingOrbitElementsQNS","bus");
initialConditions   = addToBus(initialConditions,"cartesianState","bus");
initialConditions   = addToBus(initialConditions, "relativeCartesianState", "bus");
initialConditions   = addToBus(initialConditions,"orbitElementDifferences","bus");
initialConditions   = addToBus(initialConditions,"integrationConstants_HCW","bus");
initialConditions   = addToBus(initialConditions,"integrationConstants_YA","bus");
initialConditions   = addToBus(initialConditions,"eccentricSingularROE","bus");
initialConditions   = addToBus(initialConditions,"eccentricQuasiNonsingularROE","bus");
initialConditions   = addToBus(initialConditions,"damicoROE","bus");

chief               = addToBus(chief,"properties","bus");
chief               = addToBus(chief,"initialConditions","bus");
plantBus            = addToBus(plantBus,"chief","bus");

% Deputy
deputy              = createBus(plant.chief);
deputy              = addToBus(deputy, "properties","bus");
deputy              = addToBus(deputy,"initialConditions","bus");
plantBus            = addToBus(plantBus,"deputy","bus");
