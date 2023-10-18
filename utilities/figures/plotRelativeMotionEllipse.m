x1 = telem.("Deputy 1 Relative Cartesian State.positionX_RTN_m");
y1 = telem.("Deputy 1 Relative Cartesian State.positionY_RTN_m");
z1 = telem.("Deputy 1 Relative Cartesian State.positionZ_RTN_m");

x2 = telem.("Deputy 2 Relative Cartesian State.positionX_RTN_m");
y2 = telem.("Deputy 2 Relative Cartesian State.positionY_RTN_m");
z2 = telem.("Deputy 2 Relative Cartesian State.positionZ_RTN_m");


figure;
hold on;
plot(y1,x1)
plot(y2,x2)
scatter(0,0,'filled','black')
legend(["Deputy 1", "Deputy 2","Chief"])
axis equal;
grid on;
xlabel("T")
ylabel("R")
title("RT Ellipse")
view(2)

figure;
hold on;
plot(z1,x1)
plot(z2,x2)
scatter(0,0,'filled','black')
legend(["Deputy 1", "Deputy 2","Chief"])
axis equal;
grid on;
xlabel("N")
ylabel("R")
title("RN Ellipse")
view(2)