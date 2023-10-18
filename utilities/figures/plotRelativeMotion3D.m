function [] = plotRelativeMotion3D(telem)

% apogee_idx = 1;
% [~,perigee_idx] = min(abs(time-3.532572227135039e+04));

figure
set(gcf,'Position',[100 100 900 500])
% title("Relative Motion in RTN Plane")
subplot(1,2,1)
title("Relative 3D Position")
axis equal
hold on;
plot3(telem.("Deputy Relative Cartesian State RTN Nonlinear.positionX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN Nonlinear.positionY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN Nonlinear.positionZ_RTN_m")(2:end),LineWidth=1.5)
% plot3(telem.("Deputy Relative Cartesian State D'Amico ROE Map.positionX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State D'Amico ROE Map.positionY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State D'Amico ROE Map.positionZ_RTN_m")(2:end),LineWidth=1.5)
% plot3(telem.("Deputy Relative Cartesian State RTN YA.positionX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN YA.positionY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN YA.positionZ_RTN_m")(2:end),LineWidth=1.5)
% plot3(telem.("Deputy Relative Cartesian State RTN Nonlinear.positionX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN Nonlinear.positionY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN Nonlinear.positionZ_RTN_m")(2:end),LineWidth=1.5)
% plot3(telem.("Deputy Relative Cartesian State RTN HCW.positionX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN HCW.positionY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN HCW.positionZ_RTN_m")(2:end),LineWidth=1.5)


xlabel("\delta r_r [m]")
ylabel("\delta r_t [m]")
zlabel("\delta r_n [m]")
view(30,30)
% legend(["Nonlinear","Geometric","YA"])
% legend(["Nonlinear","YA"])
% legend(["Nonlinear","HCW"])
grid on;
subplot(1,2,2)
title("Relative 3D Velocity")
axis equal
hold on;
plot3(telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityZ_RTN_m")(2:end),LineWidth=1.5)
% plot3(telem.("Deputy Relative Cartesian State D'Amico ROE Map.velocityX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State D'Amico ROE Map.velocityY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State D'Amico ROE Map.velocityZ_RTN_m")(2:end),LineWidth=1.5)
plot3(telem.("Deputy Relative Cartesian State RTN YA.velocityX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN YA.velocityY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN YA.velocityZ_RTN_m")(2:end),LineWidth=1.5)
% plot3(telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN Nonlinear.velocityZ_RTN_m")(2:end),LineWidth=1.5)
% plot3(telem.("Deputy Relative Cartesian State RTN HCW.velocityX_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN HCW.velocityY_RTN_m")(2:end),telem.("Deputy Relative Cartesian State RTN HCW.velocityZ_RTN_m")(2:end),LineWidth=1.5)


xlabel("\delta v_r [m]")
ylabel("\delta v_t [m]")
zlabel("\delta v_n [m]")
view(30,30)
% legend(["Nonlinear","Geometric","YA"])
legend(["Nonlinear","YA"])
% legend(["Nonlinear","HCW"])
grid on;
end
