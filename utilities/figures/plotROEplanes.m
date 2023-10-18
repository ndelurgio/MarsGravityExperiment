dex_window = controlWindows.de_min*cos(controlWindows.psi_min:0.0001:controlWindows.psi_max);
dex_window = [dex_window, cos(controlWindows.psi_max)*(controlWindows.de_min:0.0000001:controlWindows.de_max)];
dex_window = [dex_window, controlWindows.de_max*cos(controlWindows.psi_max:-0.0001:controlWindows.psi_min)];
dex_window = [dex_window, cos(controlWindows.psi_min)*(controlWindows.de_max:-0.0000001:controlWindows.de_min)];

dey_window = controlWindows.de_min*sin(controlWindows.psi_min:0.0001:controlWindows.psi_max);
dey_window = [dey_window, sin(controlWindows.psi_max)*(controlWindows.de_min:0.0000001:controlWindows.de_max)];
dey_window = [dey_window, controlWindows.de_max*sin(controlWindows.psi_max:-0.0001:controlWindows.psi_min)];
dey_window = [dey_window, sin(controlWindows.psi_min)*(controlWindows.de_max:-0.0000001:controlWindows.de_min)];

% dt = 100;
% EROE_plot = EROE_out(:,1);
% for i = 1:length(times)
%     time = times(i);
%     [EROE, OE, cartesianState] = propJ2plusSRP(OE,EROE,sunOE0,J2,r,mu,constants,dB,t);
% end

a = chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
figure
set(gcf,'Position',[100 100 900 900])
subplot(2,2,1)
hold on;
plot(medfilt1(a*telem.("Deputy 1 Mean EROE.relativeLongitude")(telem.("command_complete")==1),10),medfilt1(a*telem.("Deputy 1 Mean EROE.relativeSemiMajorAxis")(telem.("command_complete")==1),10),'Color','blue',LineWidth=2)
% scatter(a*EROE_out(2,:),a*EROE_out(1,:))
% plot(a*EROE_out(2,:),a*EROE_out(1,:),'Color','blue',LineWidth=2)
% plot(a*telem.("Deputy 2 Mean EROE.relativeLongitude"),a*telem.("Deputy 2 Mean EROE.relativeSemiMajorAxis"),'Color','red',LineWidth=2)
% axis equal;
grid on;
ylabel('$a\delta a$ [m]','Interpreter','latex',"FontSize",20)
xlabel('$a\delta \lambda$ [m]','Interpreter','latex',"FontSize",20)
% legend(["Deputy 1","Deputy 2"])

subplot(2,2,[3 4])
hold on;
adex = medfilt1(a*telem.("Deputy 1 Mean EROE.relativeEccentricityX")(telem.("command_complete")==1),10);
adey = medfilt1(a*telem.("Deputy 1 Mean EROE.relativeEccentricityY")(telem.("command_complete")==1),10);
plot(adex(2:end),adey(2:end),'Color','blue',LineWidth=2)
% scatter(a*EROE_out(3,:),a*EROE_out(4,:))
% plot(a*EROE_out(3,:),a*EROE_out(4,:),'Color','blue',LineWidth=2)
plot(a*dex_window,a*dey_window,'Color','red',LineWidth=2)
% plot(a*telem.("Deputy 2 Mean EROE.relativeEccentricityX"),a*telem.("Deputy 2 Mean EROE.relativeEccentricityY"),'Color','red',LineWidth=2)
axis equal;
grid on;
ylabel('$a\delta e_y$ [m]','Interpreter','latex',"FontSize",20)
xlabel('$a\delta e_x$ [m]','Interpreter','latex',"FontSize",20)
% legend(["Deputy 1","Deputy 2"])

subplot(2,2,2)
hold on;
% scatter(a*EROE_out(5,:),a*EROE_out(6,:))
plot(a*EROE_out(5,:),a*EROE_out(6,:),'Color','blue',LineWidth=2)
% plot(medfilt1(a*telem.("Deputy 1 Mean EROE.relativeInclinationX")(telem.("command_complete")==1),10),medfilt1(a*telem.("Deputy 1 Mean EROE.relativeInclinationY")(telem.("command_complete")==1),10),'Color','blue',LineWidth=2)
% plot(a*telem.("Deputy 2 Mean EROE.relativeInclinationX"),a*telem.("Deputy 2 Mean EROE.relativeInclinationY"),'Color','red',LineWidth=2)
axis equal;
grid on;
ylabel('$a\delta i_y$ [m]','Interpreter','latex',"FontSize",20)
xlabel('$a\delta i_x$ [m]','Interpreter','latex',"FontSize",20)
% legend(["Deputy 1","Deputy 2"])
%%
h = figure;
subplot(1,3,[1 2])
hold on;
adex = medfilt1(a*telem.("Deputy 1 Mean EROE.relativeEccentricityX")(telem.("command_complete")==1),10);
adey = medfilt1(a*telem.("Deputy 1 Mean EROE.relativeEccentricityY")(telem.("command_complete")==1),10);
plot(adex(abs(diff(adex)) < 20 & abs(diff(adey)) < 20),adey(abs(diff(adex)) < 20 & abs(diff(adey)) < 20),'Color','blue',LineWidth=2)
% scatter(adex(2:end),adey(2:end),10,'filled','bluex = ')
plot(a*dex_window,a*dey_window,'Color','red',LineWidth=2)
legend("Trajectory","Control Windows")
axis equal;
grid on;
ylabel('$a\delta e_y$ [m]','Interpreter','latex',"FontSize",20)
xlabel('$a\delta e_x$ [m]','Interpreter','latex',"FontSize",20)
% saveas(h,figurepath + "delta-e-parametric.eps",'epsc')

% h = figure;
subplot(1,3,3)
hold on;
adix = medfilt1(a*telem.("Deputy 1 Mean EROE.relativeInclinationX")(telem.("command_complete")==1),10);
adiy = medfilt1(a*telem.("Deputy 1 Mean EROE.relativeInclinationY")(telem.("command_complete")==1),10);
plot(adix(2:end),adiy(2:end),'Color','blue',LineWidth=2)
scatter([0,0],a*[controlWindows.diy_min,controlWindows.diy_max],'filled','red')
axis equal;
grid on;
ylabel('$a\delta i_y$ [m]','Interpreter','latex',"FontSize",20)
xlabel('$a\delta i_x$ [m]','Interpreter','latex',"FontSize",20)
ylim([-1600,-600])

saveas(h,figurepath + "delta-alpha-parametric.eps",'epsc')