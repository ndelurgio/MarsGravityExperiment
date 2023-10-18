figure
set(gcf,'position',[300,300,800,800])
% hold on;
subplot(3,2,1)
hold on;
title("Semi-Major Axis vs Time")
plot(time/3600,telem.("Mean quasi non-singular deputy OE.semiMajorAxis_m")/1000,"LineWidth",1)
xlabel("t [hr]")
ylabel("a [km]")
grid on;

subplot(3,2,2)
hold on;
title("Mean Argument of Latitude vs Time")
plot(time/3600,rad2deg(telem.("Mean quasi non-singular deputy OE.meanArgumentLatitude_rad")),"LineWidth",1)
xlabel("t [hr]")
ylabel("u [deg]")
grid on;

subplot(3,2,3)
hold on;
title("X Eccentricity vs Time")
plot(time/3600,telem.("Mean quasi non-singular deputy OE.eccentricityX"),"LineWidth",1)
xlabel("t [hr]")
ylabel("e_x")
grid on;

subplot(3,2,4)
hold on;
title("Y Eccentricity vs Time")
plot(time/3600,telem.("Mean quasi non-singular deputy OE.eccentricityY"),"LineWidth",1)
xlabel("t [hr]")
ylabel("e_y")
grid on;

subplot(3,2,5)
hold on;
title("Inclination vs Time")
plot(time/3600,rad2deg(telem.("Mean quasi non-singular deputy OE.inclination_rad")),"LineWidth",1)
xlabel("t [hr]")
ylabel("i [deg]")
grid on;

subplot(3,2,6)
hold on;
title("Longitude Ascending Node vs Time")
plot(time/3600,rad2deg(telem.("Mean quasi non-singular deputy OE.longitudeAscendingNode_rad")),"LineWidth",1)
xlabel("t [hr]")
ylabel("\Omega [deg]")
grid on;