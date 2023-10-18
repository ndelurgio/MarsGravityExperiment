figure

subplot(3,1,1)
grid on;
hold on;
title("X Sun Position J2000")
plot(time/3600,telem.("Sun Position")(:,1)/plant.environment.constants.AU_m)
xlabel("t [hr]")
ylabel("X [AU]")

subplot(3,1,2)
grid on;
hold on;
title("Y Sun Position J2000")
plot(time/3600,telem.("Sun Position")(:,2)/plant.environment.constants.AU_m)
xlabel("t [hr]")
ylabel("Y [AU]")

subplot(3,1,3)
grid on;
hold on;
title("Z Sun Position J2000")
plot(time/3600,telem.("Sun Position")(:,3)/plant.environment.constants.AU_m)
xlabel("t [hr]")
ylabel("Z [AU]")
