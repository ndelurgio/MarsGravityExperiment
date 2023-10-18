%% Simulation Settings
J2_flag = 1;
srp_flag = 1;
sun_grav_flag = 1;
t_epoch = datetime(2024,6,1);
orbits = 3;
figurepath = "/Users/ndelurgio/Dropbox/Apps/Overleaf/IEEE Paper/figures/";

%% Simulation Parameters

% Chief Orbit
periapsis_altitude = 130e3;
r_periapsis = periapsis_altitude + 3389.5e3; % Radius of Mars
e = 0.4;
a = r_periapsis / (1-e);
n = meanMotion(4.2828372e13,a); % GM of Mars
i = deg2rad(99.5);
% chiefOE = [a, e, i, deg2rad(75), deg2rad(188), deg2rad(180.1)];
% chiefOE = [a, e, i, deg2rad(75), deg2rad(188), 1.77816];
chiefOE = [a, e, i, deg2rad(75), deg2rad(188), pi]; % Switch back to 188 deg
clear periapsis_altitude r_periapsis e a i

% Deputy 1 Relative Orbit
% Design 1
% EROE = [0;0;-8.236775362942656e+02;5.860770202756232e+03;0;0]/chiefOE(1);
% Design 2
% EROE = [0;1.45e+04;0;750;0;-1.0875e+03]/chiefOE(1);
% Design 3
% EROE = [0, 0, 0, 5.9e3, 0, -0.77e3]'/chiefOE(1);
EROE = [0, 0, 0, 5.8333e3, 0, -0.77e3]'/chiefOE(1);
EROE0 = EROE;
deputy1OE = eccentricROE2deputyOE(EROE, chiefOE);
da = EROE(1);
dlam = EROE(2);
dex = EROE(3);
dey = EROE(4);
dix = EROE(5);
diy = EROE(6);
% Control Windows
controlWindows.de_min = norm([dex,dey]);
controlWindows.de_max = 1.1*controlWindows.de_min;
controlWindows.psi_nom = wrapTo2Pi(atan2(dey,dex));
controlWindows.psi_min = controlWindows.psi_nom - deg2rad(10);
controlWindows.psi_max = controlWindows.psi_nom + deg2rad(10);
controlWindows.diy_max = diy;
controlWindows.diy_min = 2*diy;
controlWindows.dlam_min = -1000/chiefOE(1);
controlWindows.dlam_max = 1000/chiefOE(1);
controlWindowsBus = createBus(controlWindows);

% Deputy 2 Relative Orbit
% Design 1
% EROE = [0;0;8.236775362942656e+02;-5.860770202756232e+03;0;0]/chiefOE(1);
% Design 2
% EROE = [0;-1.45e+04;0;-750;0;1.0875e+03]/chiefOE(1);
% Design 3
EROE = [0, 0, 0, -0.55e3, 0, 7.0e3]'/chiefOE(1);
deputy2OE = eccentricROE2deputyOE(EROE, chiefOE);

delta_t = 6;

t_final = t_epoch + seconds(orbits*2*pi/n);
MarsGravityExperimentParameters;

%% Commands
EROEf = [0; 0; -812; 5777; 0; 0]/chiefOE(1);
DeltaEROE = EROEf - EROE0;
[maneuverTimes_ip, M_ip, dv_ip, ~] = computeInPlaneManeuver(DeltaEROE,chiefOE',4.2828372e13);
[maneuverTimes_op, M_op, dv_op, ~] = computeOutOfPlaneManeuver(DeltaEROE,chiefOE',4.2828372e13);
M_cmd = [M_ip, M_op(1)+2*pi];
dv_cmd = [dv_ip; dv_op(1,:)];
maneuverTimes = (M_cmd+2*pi - chiefOE(6))/n;
gnc_override = 1;

clear chiefOE deputy1OE deputy2OE EROE n