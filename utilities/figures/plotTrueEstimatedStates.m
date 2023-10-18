%% Plot true vs estimated position
figure
set(gcf,'Position',[100 100 700 700])
subplot(3, 1, 1)
grid on
hold on;
title("True and Estimated X Position")
plot(time(2:end-1, :)/3600, telem.("Chief Cartesian State J2000.positionX_J2000_m")(2:end-1, :), 'LineWidth', 3)
plot(time(3:end)/3600, (telem.("Mean EKF New")(3:end, 1)), '--', 'LineWidth', 2)
plot(time(3:end)/3600, (telem.("Mean UKF New")(3:end, 1)), '-.', 'LineWidth', 2)
legend("True", "EKF", "UKF")
xlabel("t [hr]")
ylabel("Position [m]")

subplot(3, 1, 2)
grid on
hold on;
title("True and Estimated Y Position")
plot(time(2:end-1)/3600, telem.("Chief Cartesian State J2000.positionY_J2000_m")(2:end-1), 'LineWidth', 3)
plot(time(3:end)/3600, (telem.("Mean EKF New")(3:end, 2)), '--', 'LineWidth', 2)
plot(time(3:end)/3600, (telem.("Mean UKF New")(3:end, 2)), '-.', 'LineWidth', 2)
legend("True", "EKF", "UKF")
xlabel("t [hr]")
ylabel("Position [m]")

subplot(3, 1, 3)
grid on
hold on;
title("True and Estimated Z Position")
plot(time(2:end-1)/3600, telem.("Chief Cartesian State J2000.positionZ_J2000_m")(2:end-1), 'LineWidth', 3)
plot(time(3:end)/3600, (telem.("Mean EKF New")(3:end, 3)), '--', 'LineWidth', 2)
plot(time(3:end)/3600, (telem.("Mean UKF New")(3:end, 3)), '-.', 'LineWidth', 2)
legend("True", "EKF", "UKF")
xlabel("t [hr]")
ylabel("Position [m]")

%% Plot true vs estimated velocity
figure
set(gcf,'Position',[100 100 700 700])
subplot(3, 1, 1)
grid on
hold on;
title("True and Estimated X Velocity")
plot(time(2:end-1)/3600, telem.("Chief Cartesian State J2000.velocityX_J2000_m")(2:end-1), 'LineWidth', 3)
plot(time(3:end)/3600, (telem.("Mean EKF New")(3:end, 4)), '--', 'LineWidth', 2)
plot(time(3:end)/3600, (telem.("Mean UKF New")(3:end, 4)), '-.', 'LineWidth', 2)
legend("True", "EKF", "UKF")
xlabel("t [hr]")
ylabel("Velocity [m/s]")

subplot(3, 1, 2)
grid on
hold on;
title("True and Estimated Y Velocity")
plot(time(2:end-1)/3600, telem.("Chief Cartesian State J2000.velocityY_J2000_m")(2:end-1), 'LineWidth', 3)
plot(time(3:end)/3600, (telem.("Mean EKF New")(3:end, 5)), '--', 'LineWidth', 2)
plot(time(3:end)/3600, (telem.("Mean UKF New")(3:end, 5)), '-.', 'LineWidth', 2)
legend("True", "EKF", "UKF")
xlabel("t [hr]")
ylabel("Velocity [m/s]")

subplot(3, 1, 3)
grid on
hold on;
title("True and Estimated Z Velocity")
plot(time(2:end-1)/3600, telem.("Chief Cartesian State J2000.velocityZ_J2000_m")(2:end-1), 'LineWidth', 3)
plot(time(3:end)/3600, (telem.("Mean EKF New")(3:end, 6)), '--', 'LineWidth', 2)
plot(time(3:end)/3600, (telem.("Mean UKF New")(3:end, 6)), '-.', 'LineWidth', 2)
legend("True", "EKF", "UKF")
xlabel("t [hr]")
ylabel("Velocity [m/s]")
