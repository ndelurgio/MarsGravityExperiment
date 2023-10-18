figure
set(gcf,'position',[300,300,800,800])
% hold on;
subplot(3,1,1)
hold on;
title("X Eccentricity Component vs Time")
plot(time/3600,telem.("KeplerEccentricityVector")(:,1),"LineWidth",1)
plot(time/3600,telem.("PerturbedEccentricityVector")(:,1),"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("e_X")
grid on;

subplot(3,1,2)
hold on;
title("Y Eccentricity Component vs Time")
plot(time/3600,telem.("KeplerEccentricityVector")(:,2),"LineWidth",1)
plot(time/3600,telem.("PerturbedEccentricityVector")(:,2),"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("e_Y")
grid on;

subplot(3,1,3)
hold on;
title("Z Eccentricity Component vs Time")
plot(time/3600,telem.("KeplerEccentricityVector")(:,3),"LineWidth",1)
plot(time/3600,telem.("PerturbedEccentricityVector")(:,3),"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("e_Z")
grid on;