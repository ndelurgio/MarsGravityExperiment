close all;
%% Inputs:
periapsis_altitude = 130e3;
e = 0:0.01:0.7; % Any greater cause imaginary solutions

%% Constants
R_mars = 3389.5e3;
mu = 4.2828372e13;
J2 = 0.001960454;
T_mars = 686.980 * 86400; % Mars Orbit Period, in seconds
%% Calculations
dOmega_dt = 2*pi / T_mars; % Desired orbit precession rate
r_periapsis = periapsis_altitude + R_mars;
a = r_periapsis ./ (1-e);
T_orbit = 2*pi./sqrt(mu./a.^3);
eta = sqrt(1-e.^2);
kappa = 3/4 * J2 * R_mars^2 * sqrt(mu) ./ (a.^(7/2).*eta.^4);
i = acos(-1/2 * dOmega_dt ./ kappa); % Inclination needed to achieve ascending node precession rate
wdot = kappa.*(5*cos(i).^2-1);
energy = -mu./(2*a);

%% Plotting
h = figure;
colororder({'b','r'})
hold on;
yyaxis left
plot(e,rad2deg(i))
grid on;
% title("SSO Inclination for Periapsis Altitude = " + string(periapsis_altitude/1000) + " km")
xlabel("Eccentricity")
ylabel("Inclination [deg]")
yyaxis right
plot(e,rad2deg(wdot)*86400)
grid on;
ylabel('Periapsis Precession Rate [deg/day]')
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "sso_design.eps",'epsc')

h = figure;
plot(e,T_orbit/86400)
grid on;
% title("SSO Orbit Period for Periapsis Altitude = " + string(periapsis_altitude/1000) + " km")
xlabel("Eccentricity")
ylabel("Orbit Period [days]")
saveas(h,figurepath + "sso_orbit_period.eps",'epsc')

h = figure;
plot(e,energy)
grid on;
% title("SSO Orbit Energy for Periapsis Altitude = " + string(periapsis_altitude/1000) + " km")
xlabel("Eccentricity")
ylabel("Orbit Energy")
saveas(h,figurepath + "sso_orbit_energy.eps",'epsc')
