figure
set(gcf,'position',[300,300,800,800])
% hold on;
subplot(3,2,1)
hold on;
title("Semi-Major Axis vs Time")
plot(time/3600,telem.("KeplerOrbitElements")(:,1)/1000,"LineWidth",1)
plot(time/3600,telem.("PerturbedOrbitElements")(:,1)/1000,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("a [km]")
grid on;

subplot(3,2,2)
hold on;
title("Eccentricity vs Time")
plot(time/3600,telem.("KeplerOrbitElements")(:,2),"LineWidth",1)
plot(time/3600,telem.("PerturbedOrbitElements")(:,2),"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("e")
grid on;

subplot(3,2,3)
hold on;
title("Inclination vs Time")
plot(time/3600,telem.("KeplerOrbitElements")(:,3)*180/pi,"LineWidth",1)
plot(time/3600,telem.("PerturbedOrbitElements")(:,3)*180/pi,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("i [deg]")
grid on;

subplot(3,2,4)
hold on;
title("Longitude of Ascending Node vs Time")
plot(time/3600,telem.("KeplerOrbitElements")(:,4)*180/pi,"LineWidth",1)
plot(time/3600,telem.("PerturbedOrbitElements")(:,4)*180/pi,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("\Omega [deg]")
grid on;

subplot(3,2,5)
hold on;
title("Argument of Perigee vs Time")
plot(time/3600,telem.("KeplerOrbitElements")(:,5)*180/pi,"LineWidth",1)
plot(time/3600,telem.("PerturbedOrbitElements")(:,5)*180/pi,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("\omega [deg]")
grid on;

subplot(3,2,6)
hold on;
title("True Anomaly vs Time")
plot(time/3600,telem.("KeplerOrbitElements")(:,6)*180/pi,"LineWidth",1)
plot(time/3600,telem.("PerturbedOrbitElements")(:,6)*180/pi,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("\nu [deg]")
grid on;