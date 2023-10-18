% Assuming a timetable called telem with variables:
% a, e, i, Om, w and M

% Extract the variables and store as separate vectors
a = telem.("PerturbedOrbitElements")(:, 1)/1000; % Convert from m to km
e = telem.("PerturbedOrbitElements")(:, 2);
i = rad2deg(telem.("PerturbedOrbitElements")(:, 3)); % Convert to deg
Om = rad2deg(telem.("PerturbedOrbitElements")(:, 4)); % ''
w = rad2deg(telem.("PerturbedOrbitElements")(:, 5)); % ''
nu = telem.("PerturbedOrbitElements")(:, 6);
M = rad2deg(nu2M(nu, e)); % Convert to Mean Anomaly, and to degrees

a_mean = telem.("meanJ2OrbitElements.semiMajorAxis_m")/1000; % Convert from m to km
e_mean = telem.("meanJ2OrbitElements.eccentricity");
i_mean = rad2deg(telem.("meanJ2OrbitElements.inclination_rad")); % Convert to deg
Om_mean = rad2deg(telem.("meanJ2OrbitElements.longitudeAscendingNode_rad")); % ''
w_mean = rad2deg(telem.("meanJ2OrbitElements.argumentPerigee_rad")); % ''
M_mean = rad2deg(telem.("meanJ2OrbitElements.MeanAnomaly_rad")); % ''
t = time/3600; % Convert seconds to hours

% Create a 6x1 grid of subplots
figure;
set(gcf,'position',[300,300,800,800])
subplot(3, 2, 1);
plot(t, a, 'DisplayName', 'J2 Perturbed');
hold on;
plot(t, a_mean, 'DisplayName', 'Mean J2 Perturbed');
xlabel('t [hr]');
ylabel('a [km]');
title('Semi-Major Axis vs Time');
legend('show');

subplot(3, 2, 2);
plot(t, e, 'DisplayName', 'J2 Perturbed');
hold on;
plot(t, e_mean, 'DisplayName', 'Mean J2 Perturbed');
xlabel('t [hr]');
ylabel('e [-]');
title('Eccentricity vs Time');
legend('show');

subplot(3, 2, 3);
plot(t, i, 'DisplayName', 'J2 Perturbed');
hold on;
plot(t, i_mean, 'DisplayName', 'Mean J2 Perturbed');
xlabel('t [hr]');
ylabel('i [deg]');
title('Inclination vs Time');
legend('show');

subplot(3, 2, 4);
plot(t, Om, 'DisplayName', 'J2 Perturbed');
hold on;
plot(t, Om_mean, 'DisplayName', 'Mean J2 Perturbed');
xlabel('t [hr]');
ylabel('\Omega [deg]');
title('Longitude of Ascending Node vs Time');
legend('show');

subplot(3, 2, 5);
plot(t, w, 'DisplayName', 'J2 Perturbed');
hold on;
plot(t, w_mean, 'DisplayName', 'Mean J2 Perturbed');
xlabel('t [hr]');
ylabel('\omega [deg]');
title('Argument of Periapsis vs Time');
legend('show');

subplot(3, 2, 6);
plot(t, M, 'DisplayName', 'J2 Perturbed');
hold on;
plot(t, M_mean, 'DisplayName', 'Mean J2 Perturbed');
xlabel('t [hr]');
ylabel('M [deg]');
title('Mean Anomaly vs Time');
legend('show');

% Adjust the layout to improve spacing between subplots
% sgtitle('Mean Orbital Elements vs Time');
saveas(gcf, 'results/HW1/J2_mean_orbital_elements_vs_time.png');
