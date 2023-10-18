close all
figure
a = plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
set(gcf,'Position',[100 100 1200 800])
subplot(3,2,1)
title('$a\delta a$','Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time(telem.("Thrust Cmd") == 0)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeSemiMajorAxis")(telem.("Thrust Cmd") == 0),LineWidth=2)
scatter(time(telem.("Thrust Cmd") == 1)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeSemiMajorAxis")(telem.("Thrust Cmd") == 1),'filled',LineWidth=2)
legend(["Mean ROE", "Maneuver"])
xlim([0, 10])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,2)
title("$a\delta \lambda$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time(telem.("Thrust Cmd") == 0)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeLongitude")(telem.("Thrust Cmd") == 0),LineWidth=2)
scatter(time(telem.("Thrust Cmd") == 1)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeLongitude")(telem.("Thrust Cmd") == 1),'filled',LineWidth=2)
legend(["Mean ROE", "Maneuver"])
xlim([0, 10])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,3)
title("$a\delta e_x$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time(telem.("Thrust Cmd") == 0)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeEccentricityX")(telem.("Thrust Cmd") == 0),LineWidth=2)
scatter(time(telem.("Thrust Cmd") == 1)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeEccentricityX")(telem.("Thrust Cmd") == 1),'filled',LineWidth=2)
legend(["Mean ROE", "Maneuver"])
xlim([0, 10])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,4)
title("$a\delta e_y$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time(telem.("Thrust Cmd") == 0)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeEccentricityY")(telem.("Thrust Cmd") == 0),LineWidth=2)
scatter(time(telem.("Thrust Cmd") == 1)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeEccentricityY")(telem.("Thrust Cmd") == 1),'filled',LineWidth=2)
legend(["Mean ROE", "Maneuver"])
xlim([0, 10])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,5)
title("$a\delta i_x$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time(telem.("Thrust Cmd") == 0)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeInclinationX")(telem.("Thrust Cmd") == 0),LineWidth=2)
scatter(time(telem.("Thrust Cmd") == 1)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeInclinationX")(telem.("Thrust Cmd") == 1),'filled',LineWidth=2)
legend(["Mean ROE", "Maneuver"])
xlim([0, 10])
xlabel("t [hr]")
ylabel("[m]")

subplot(3,2,6)
title("$a\delta i_y$",'Interpreter','latex',"FontSize",20)
grid on;
hold on;
plot(time(telem.("Thrust Cmd") == 0)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeInclinationY")(telem.("Thrust Cmd") == 0),LineWidth=2)
scatter(time(telem.("Thrust Cmd") == 1)/3600,a*telem.("Mean Eccentric Singular ROE True.relativeInclinationY")(telem.("Thrust Cmd") == 1),'filled',LineWidth=2)
legend(["Mean ROE", "Maneuver"])
xlim([0, 10])
xlabel("t [hr]")
ylabel("[m]")

clear a