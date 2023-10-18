% function plotCartesianState(time,posx,posy,posz,velx,vely,velz,name)
figure
set(gcf,'position',[300,300,800,800])
% hold on;
subplot(6,1,1)
hold on;
title("X Position vs Time")
plot(time/3600,telem.("cartesianStateKepler.positionX_J2000_m")/1000,"LineWidth",1)
plot(time/3600,telem.("cartesianStateJ2.positionX_J2000_m")/1000,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("X [km]")
grid on;

subplot(6,1,2)
hold on;
title("Y Position vs Time")
plot(time/3600,telem.("cartesianStateKepler.positionY_J2000_m")/1000,"LineWidth",1)
plot(time/3600,telem.("cartesianStateJ2.positionY_J2000_m")/1000,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("Y [km]")
grid on;

subplot(6,1,3)
hold on;
title("Z Position vs Time")
plot(time/3600,telem.("cartesianStateKepler.positionZ_J2000_m")/1000,"LineWidth",1)
plot(time/3600,telem.("cartesianStateJ2.positionZ_J2000_m")/1000,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("Z [km]")
grid on;

subplot(6,1,4)
hold on;
title("X Velocity vs Time")
plot(time/3600,telem.("cartesianStateKepler.velocityX_J2000_m")/1000,"LineWidth",1)
plot(time/3600,telem.("cartesianStateJ2.velocityX_J2000_m")/1000,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("v_X [km/s]")
grid on;

subplot(6,1,5)
hold on;
title("Y Velocity vs Time")
plot(time/3600,telem.("cartesianStateKepler.velocityY_J2000_m")/1000,"LineWidth",1)
plot(time/3600,telem.("cartesianStateJ2.velocityY_J2000_m")/1000,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("v_Y [km/s]")
grid on;

subplot(6,1,6)
hold on;
title("Z Velocity vs Time")
plot(time/3600,telem.("cartesianStateKepler.velocityZ_J2000_m")/1000,"LineWidth",1)
plot(time/3600,telem.("cartesianStateJ2.velocityZ_J2000_m")/1000,"LineWidth",1)
legend("Unperturbed","J2 Perturbed")
xlabel("t [hr]")
ylabel("v_Z [km/s]")
grid on;
% hold off;

% end