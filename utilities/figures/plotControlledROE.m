h = figure;
a = chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
set(gcf,'Position',[100 100 600 800])
subplot(6,1,1)
grid on;
hold on;
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeSemiMajorAxis"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeSemiMajorAxis"),LineWidth=2)
xline(time(vecnorm(telem.("DeltaV_cmd"),2,2) > 0)/3600,'--',Color='black',LineWidth=2)
ylabel('$a\delta a$ [m]','Interpreter','latex',"FontSize",12)

subplot(6,1,2)
grid on;
hold on;
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeLongitude"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeLongitude"),LineWidth=2)
xline(time(vecnorm(telem.("DeltaV_cmd"),2,2) > 0)/3600,'--',Color='black',LineWidth=2)
legend(["Osculating","Mean","Maneuvers"],Location="northwest")
ylabel("$a\delta \lambda$ [m]",'Interpreter','latex',"FontSize",12)

subplot(6,1,3)
grid on;
hold on;
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeEccentricityX"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeEccentricityX"),LineWidth=2)
xline(time(vecnorm(telem.("DeltaV_cmd"),2,2) > 0)/3600,'--',Color='black',LineWidth=2)
ylabel("$a\delta e_x$ [m]",'Interpreter','latex',"FontSize",12)

subplot(6,1,4)
grid on;
hold on;
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeEccentricityY"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeEccentricityY"),LineWidth=2)
xline(time(vecnorm(telem.("DeltaV_cmd"),2,2) > 0)/3600,'--',Color='black',LineWidth=2)
ylabel("$a\delta e_y$ [m]",'Interpreter','latex',"FontSize",12)

subplot(6,1,5)
grid on;
hold on;
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeInclinationX"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeInclinationX"),LineWidth=2)
xline(time(vecnorm(telem.("DeltaV_cmd"),2,2) > 0)/3600,'--',Color='black',LineWidth=2)
ylabel("$a\delta i_x$ [m]",'Interpreter','latex',"FontSize",12)

subplot(6,1,6)
grid on;
hold on;
plot(time/3600,a*telem.("Deputy 1 Osculating EROE.relativeInclinationY"),LineWidth=2)
plot(time/3600,a*telem.("Deputy 1 Mean EROE.relativeInclinationY"),LineWidth=2)
xline(time(vecnorm(telem.("DeltaV_cmd"),2,2) > 0)/3600,'--',Color='black',LineWidth=2)
xlabel("Time [hr]")
ylabel("$a\delta i_y$ [m]",'Interpreter','latex',"FontSize",12)

fontsize(gcf,scale=1.5)
saveas(h,figurepath + "sim_eroe_control.eps",'epsc')
%%
OE0 = [
    chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
    chief.initialConditions.meanOrbitElements.eccentricity;
    chief.initialConditions.meanOrbitElements.inclination_rad;
    chief.initialConditions.meanOrbitElements.longitudeAscendingNode_rad;
    chief.initialConditions.meanOrbitElements.argumentPerigee_rad;
    chief.initialConditions.meanOrbitElements.MeanAnomaly_rad;
];
% G1 = getEROEControlMatrix([OE(1:5); MOpt(1)],mu);
% G2 = getEROEControlMatrix([OE(1:5); MOpt(2)],mu);
% G3 = getEROEControlMatrix([OE(1:5); MOpt(3)],mu);
% 
% STM1 = getEROESTM(OE,mu,maneuverTimes(3)-maneuverTimes(1));
% STM2 = getEROESTM(OE,mu,maneuverTimes(3)-maneuverTimes(2));
% STM3 = getEROESTM(OE,mu,maneuverTimes(3)-maneuverTimes(3));
% A = [STM1*G1(:,2), STM2*G2(:,2), STM3*G3(:,2)];
% disp(norm(A*dv_T-DeltaEROE))
mu = environment.marsProperties.gravitationalParameter_m3_s2;
EROE_cmd = EROE0;
n_maneuver = uint8(0);
for t = 0:dt:t_duration
    STM = getEROESTM(OE0,mu,t);
    if n_maneuver < 4 && t > maneuverTimes(n_maneuver+1)
        n_maneuver = n_maneuver + uint8(1);
    end
    EROE_next = STM*EROE0;
    for idx = 1:min(n_maneuver,4)
        EROE_next = EROE_next + getEROESTM(OE0,mu,t-maneuverTimes(idx))*getEROEControlMatrix([OE0(1:5); M_cmd(idx)],mu)*dv_cmd(idx,:)';
    end
    EROE_cmd = [EROE_cmd, EROE_next];
end

err_vec = [
    EROE_cmd(1,1:end-1) - telem.("Deputy 1 Mean EROE.relativeSemiMajorAxis")';
    EROE_cmd(2,1:end-1) - telem.("Deputy 1 Mean EROE.relativeLongitude")';
    EROE_cmd(3,1:end-1) - telem.("Deputy 1 Mean EROE.relativeEccentricityX")';
    EROE_cmd(4,1:end-1) - telem.("Deputy 1 Mean EROE.relativeEccentricityY")';
    EROE_cmd(5,1:end-1) - telem.("Deputy 1 Mean EROE.relativeInclinationX")';
    EROE_cmd(6,1:end-1) - telem.("Deputy 1 Mean EROE.relativeInclinationY")';
];

err = vecnorm(err_vec,2,1);

h = figure;
plot((0:dt:t_duration)/3600,movmedian(a*err,10),'LineWidth',2)
xline(time(vecnorm(telem.("DeltaV_cmd"),2,2) > 0)/3600,'--',Color='black',LineWidth=2)
legend(["Error","Maneuvers"],"Location","northwest")
xlabel('Time [hr]')
ylabel('Error [m]')
grid on;
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "eroe_control_error.eps",'epsc')
