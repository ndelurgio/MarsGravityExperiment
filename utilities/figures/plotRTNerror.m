function plotRTNerror(time,telem)

figure
set(gcf,'Position',[100 100 700 700])
subplot(3, 1, 1)
grid on
hold on;
title("R Relative Position Error")
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State D'Amico ROE Map.positionX_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.positionX_RTN_m")(2:end)))
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State RTN YA.positionX_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.positionX_RTN_m")(2:end)))
legend(["Geometric Error","Y-A Error"])
xlabel("t [hr]")
ylabel("Error [m]")

subplot(3, 1, 2)
grid on
hold on;
title("T Relative Position Error")
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State D'Amico ROE Map.positionY_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.positionY_RTN_m")(2:end)))
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State RTN YA.positionY_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.positionY_RTN_m")(2:end)))
legend(["Geometric Error","Y-A Error"])
xlabel("t [hr]")
ylabel("Error [m]")

subplot(3, 1, 3)
grid on
hold on;
title("N Relative Position Error")
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State D'Amico ROE Map.positionZ_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.positionZ_RTN_m")(2:end)))
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State RTN YA.positionZ_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.positionZ_RTN_m")(2:end)))
legend(["Geometric Error","Y-A Error"])
xlabel("t [hr]")
ylabel("Error [m]")



figure
set(gcf,'Position',[100 100 700 700])
subplot(3, 1, 1)
grid on
hold on;
title("R Relative Velocity Error")
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State D'Amico ROE Map.velocityX_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityX_RTN_m")(2:end)))
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State RTN YA.velocityX_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityX_RTN_m")(2:end)))
legend(["Geometric Error","Y-A Error"])
xlabel("t [hr]")
ylabel("Error [m]")

subplot(3, 1, 2)
grid on
hold on;
title("T Relative Velocity Error")
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State D'Amico ROE Map.velocityY_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityY_RTN_m")(2:end)))
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State RTN YA.velocityY_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityY_RTN_m")(2:end)))
legend(["Geometric Error","Y-A Error"])
xlabel("t [hr]")
ylabel("Error [m]")

subplot(3, 1, 3)
grid on
hold on;
title("N Relative Velocity Error")
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State D'Amico ROE Map.velocityZ_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityZ_RTN_m")(2:end)))
plot(time(2:end)/3600, abs(telem.("Deputy Relative Cartesian State RTN YA.velocityZ_RTN_m")(2:end)-telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityZ_RTN_m")(2:end)))
legend(["Geometric Error","Y-A Error"])
xlabel("t [hr]")
ylabel("Error [m]")

end