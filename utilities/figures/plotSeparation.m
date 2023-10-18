true_diff_x = telem.("Deputy Cartesian State J2000.positionX_J2000_m") - telem.("Chief Cartesian State J2000.positionX_J2000_m");
true_diff_y = telem.("Deputy Cartesian State J2000.positionY_J2000_m") - telem.("Chief Cartesian State J2000.positionY_J2000_m");
true_diff_z = telem.("Deputy Cartesian State J2000.positionZ_J2000_m") - telem.("Chief Cartesian State J2000.positionZ_J2000_m");

sep = sqrt(true_diff_x.^2+true_diff_y.^2+true_diff_z.^2);
figure
plot(time/3600,sep,"LineWidth",2)
xlabel("Time [hr]")
ylabel("Separation [m]")