figure
set(gcf,'Position',[100 100 700 700])
subplot(4,1,1)
grid on;
hold on;
title("X Solar Radiation Pressure")
plot(time/3600,telem.("SRP Perturbation")(:,1))
xlabel("t [hr]")
ylabel("X [m/s^2]")

subplot(4,1,2)
grid on;
hold on;
title("Y Solar Radiation Pressure")
plot(time/3600,telem.("SRP Perturbation")(:,2))
xlabel("t [hr]")
ylabel("Y [m/s^2]")

subplot(4,1,3)
grid on;
hold on;
title("Z Solar Radiation Pressure")
plot(time/3600,telem.("SRP Perturbation")(:,3))
xlabel("t [hr]")
ylabel("Z [m/s^2]")

subplot(4,1,4)
grid on;
hold on;
title("Eclipse Flag [0 = no eclipse, 1 = eclipse]")
plot(time/3600,telem.("Eclipse Flag"))
xlabel("t [hr]")
ylabel("Flag \in \{0, 1\}")
