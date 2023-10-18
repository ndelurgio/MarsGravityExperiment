a = chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
figure
set(gcf,'Position',[100 100 900 900])
subplot(2,2,1)
hold on;
plot(a*telem.("Deputy 1 Mean EROE.relativeLongitude"),a*telem.("Deputy 1 Mean EROE.relativeSemiMajorAxis"),'Color','blue',LineWidth=2)
plot(a*telem.("Deputy 2 Mean EROE.relativeLongitude"),a*telem.("Deputy 2 Mean EROE.relativeSemiMajorAxis"),'Color','red',LineWidth=2)
axis equal;
grid on;
ylabel('$a\delta a$ [m]','Interpreter','latex',"FontSize",20)
xlabel('$a\delta \lambda$ [m]','Interpreter','latex',"FontSize",20)
legend(["Deputy 1","Deputy 2"])

subplot(2,2,[3 4])
hold on;
plot(a*telem.("Deputy 1 Mean EROE.relativeEccentricityX"),a*telem.("Deputy 1 Mean EROE.relativeEccentricityY"),'Color','blue',LineWidth=2)
plot(a*telem.("Deputy 2 Mean EROE.relativeEccentricityX"),a*telem.("Deputy 2 Mean EROE.relativeEccentricityY"),'Color','red',LineWidth=2)
axis equal;
grid on;
ylabel('$a\delta e_y$ [m]','Interpreter','latex',"FontSize",20)
xlabel('$a\delta e_x$ [m]','Interpreter','latex',"FontSize",20)
legend(["Deputy 1","Deputy 2"])

subplot(2,2,2)
hold on;
plot(a*telem.("Deputy 1 Mean EROE.relativeInclinationX"),a*telem.("Deputy 1 Mean EROE.relativeInclinationY"),'Color','blue',LineWidth=2)
plot(a*telem.("Deputy 2 Mean EROE.relativeInclinationX"),a*telem.("Deputy 2 Mean EROE.relativeInclinationY"),'Color','red',LineWidth=2)
axis equal;
grid on;
ylabel('$a\delta i_y$ [m]','Interpreter','latex',"FontSize",20)
xlabel('$a\delta i_x$ [m]','Interpreter','latex',"FontSize",20)
legend(["Deputy 1","Deputy 2"])
