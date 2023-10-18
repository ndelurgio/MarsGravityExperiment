close all
figure
a = plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
set(gcf,'Position',[100 100 1200 800])
subplot(3,2,1)
title('$a\delta a$','Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time/3600,a*telem.("Osculating Eccentric Singular ROE True.relativeSemiMajorAxis"),LineWidth=2)
plot(time/3600,a*telem.("Mean Eccentric Singular ROE True.relativeSemiMajorAxis"),LineWidth=2)
plot(time/3600,a*telem.("Eccentric ROE Secular J2.relativeSemiMajorAxis"),LineWidth=2,LineStyle="--")
legend(["Osculating Nonlinear","Mean Nonlinear","Mean Linear"])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,2)
title("$a\delta \lambda$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time/3600,a*telem.("Osculating Eccentric Singular ROE True.relativeLongitude"),LineWidth=2)
plot(time/3600,a*telem.("Mean Eccentric Singular ROE True.relativeLongitude"),LineWidth=2)
plot(time/3600,a*telem.("Eccentric ROE Secular J2.relativeLongitude"),LineWidth=2,LineStyle="--")
legend(["Osculating Nonlinear","Mean Nonlinear","Mean Linear"])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,3)
title("$a\delta e_x$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time/3600,a*telem.("Osculating Eccentric Singular ROE True.relativeEccentricityX"),LineWidth=2)
plot(time/3600,a*telem.("Mean Eccentric Singular ROE True.relativeEccentricityX"),LineWidth=2)
plot(time/3600,a*telem.("Eccentric ROE Secular J2.relativeEccentricityX"),LineWidth=2,LineStyle="--")
legend(["Osculating Nonlinear","Mean Nonlinear","Mean Linear"])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,4)
title("$a\delta e_y$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time/3600,a*telem.("Osculating Eccentric Singular ROE True.relativeEccentricityY"),LineWidth=2)
plot(time/3600,a*telem.("Mean Eccentric Singular ROE True.relativeEccentricityY"),LineWidth=2)
plot(time/3600,a*telem.("Eccentric ROE Secular J2.relativeEccentricityY"),LineWidth=2,LineStyle="--")
legend(["Osculating Nonlinear","Mean Nonlinear","Mean Linear"])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,5)
title("$a\delta i_x$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time/3600,a*telem.("Osculating Eccentric Singular ROE True.relativeInclinationX"),LineWidth=2)
plot(time/3600,a*telem.("Mean Eccentric Singular ROE True.relativeInclinationX"),LineWidth=2)
plot(time/3600,a*telem.("Eccentric ROE Secular J2.relativeInclinationX"),LineWidth=2,LineStyle="--")
legend(["Osculating Nonlinear","Mean Nonlinear","Mean Linear"])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,6)
title("$a\delta i_y$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time/3600,a*telem.("Osculating Eccentric Singular ROE True.relativeInclinationY"),LineWidth=2)
plot(time/3600,a*telem.("Mean Eccentric Singular ROE True.relativeInclinationY"),LineWidth=2)
plot(time/3600,a*telem.("Eccentric ROE Secular J2.relativeInclinationY"),LineWidth=2,LineStyle="--")
legend(["Osculating Nonlinear","Mean Nonlinear","Mean Linear"])
xlabel("t [hr]")
ylabel("[m]")

clear a