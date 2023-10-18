epsilon = 500;
beta = 1.1;
y_max = 10000;
z_max = 5000;

periapsis_altitude = 130e3;
r_periapsis = periapsis_altitude + 3389.5e3; % Radius of Mars
e = 0.4;
a = r_periapsis / (1-e);
n = meanMotion(4.2828372e13,a); % GM of Mars

de_min = beta*epsilon/a;
di_min = beta*epsilon/a*(1+e);

% Deputy 1: In-plane GG
di1 = di_min;
de1 = y_max / (a*(1/(1+e)+1));
phi1 = deg2rad(270); % Ensure dix = 0
psi1 = deg2rad(90); % Ensure maximum phase separation
EROE1 = [0, 0, de1*cos(psi1), de1*sin(psi1), di1*cos(phi1), di1*sin(phi1)];

% Deputy 2: Out-of-plane GG
de2 = de_min;
di2 = z_max / (a*(1/(1+e)));
phi2 = deg2rad(90); % Ensure dix = 0
psi2 = deg2rad(270); % Ensure maximum phase separation
EROE2 = [0, 0, de2*cos(psi2), de2*sin(psi2), di2*cos(phi2), di2*sin(phi2)];

close all;
% Plot relative geometry for a specifc perigee location
w0 = deg2rad(180);
nu = 0:0.001:2*pi;
x1 = -a*de1*cos(nu+w0-psi1);
y1 = a*(1./(1+e.*cos(nu))+1).*de1.*sin(nu+w0-psi1);
z1 = a*1./(1+e.*cos(nu)).*di1.*sin(nu+w0-phi1);
x2 = -a*de2*cos(nu+w0-psi2);
y2 = a*(1./(1+e*cos(nu))+1).*de2.*sin(nu+w0-psi2);
z2 = a*1./(1+e*cos(nu)).*di2.*sin(nu+w0-phi2);
disp("Deputy 1 Min RN Separation Numerical = " + string(min(sqrt(x1.^2+z1.^2))));
disp("Deputy 2 Min RN Separation Numerical = " + string(min(sqrt(x2.^2+z2.^2))));
disp("Inter-Deputy Min RN Separation Numerical = " + string(min(sqrt((x2-x1).^2+(z2-z1).^2))));
%% EROE Plots
h = figure;
hold on;
grid on;
scatter(a*EROE1(3)/1000,a*EROE1(4)/1000,80,'Marker','square','MarkerFaceColor','blue')
scatter(a*EROE1(5)/1000,a*EROE1(6)/1000,80,'filled','MarkerFaceColor','blue')
scatter(a*EROE2(3)/1000,a*EROE2(4)/1000,80,'Marker','square','MarkerFaceColor','red')
scatter(a*EROE2(5)/1000,a*EROE2(6)/1000,80,'filled','MarkerFaceColor','red')
legend(["Deputy 1 $a\delta \textbf{e}$","Deputy 1 $a\delta \textbf{i}$","Deputy 2 $a\delta \textbf{e}$","Deputy 2 $a\delta \textbf{i}$"],'Interpreter','latex','FontSize',12)
xlabel("$a\delta e_x, a\delta i_x$ [km]",'Interpreter','latex','FontSize',12)
ylabel("$a\delta e_y, a\delta i_y$ [km]",'Interpreter','latex','FontSize',12)
xlim([-8,8])
ylim([-8,8])
% axis equal
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "design_3_eroe.eps",'epsc')

%% Geometry Plots
h = figure;
hold on;
plot(y1/1000,x1/1000,"LineWidth",2,"Color","blue")
plot(y2/1000,x2/1000,"LineWidth",2,"Color","red")
scatter(0,0,'filled','black')
scatter(y1(1)/1000,x1(1)/1000,128,'diamond','filled','magenta')
scatter(y2(1)/1000,x2(1)/1000,128,'diamond','filled','magenta')
legend(["Deputy 1", "Deputy 2","Chief","Periapsis"])
axis equal;
grid on;
xlabel("T [km]")
ylabel("R [km]")
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "design_3_rt.eps",'epsc')

h = figure;
hold on;
rectangle("Position",[-epsilon,-epsilon,2*epsilon,2*epsilon]/1000,"Curvature",[1,1],"FaceColor",[1,0,0,0.2],"EdgeColor",'w');
plot(z1/1000,x1/1000,"LineWidth",2,"Color","blue")
plot(z2/1000,x2/1000,"LineWidth",2,"Color","red")
scatter(0,0,'filled','black')
scatter(z1(1)/1000,x1(1)/1000,128,'diamond','filled','magenta')
scatter(z2(1)/1000,x2(1)/1000,128,'diamond','filled','magenta')
legend(["Deputy 1", "Deputy 2","Chief","Periapsis"])
axis equal;
grid on;
xlabel("N [km]")
ylabel("R [km]")
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "design_3_rn.eps",'epsc')

%% Plot perigee location for varying periapsis location
w = 0:0.001:2*pi;
xp1 = -a*de1*cos(w-psi1);
yp1 = a*(1/(1+e)+1)*de1*sin(w-psi1);
zp1 = a/(1+e)*di1*sin(w-phi1);
xp2 = -a*de2*cos(w-psi2);
yp2 = a*(1/(1+e)+1)*de2*sin(w-psi2);
zp2 = a/(1+e)*di2*sin(w-phi2);

h = figure;
hold on;
plot(yp1/1000,xp1/1000,"LineWidth",2,"Color","blue")
plot(yp2/1000,xp2/1000,"LineWidth",2,"Color","red")
scatter(0,0,'filled','black')
% an1 = annotation('textarrow','String',"$\omega=0^{\circ}$",'Interpreter','latex',"FontSize",12);
% an1.Parent = gca;
% an1.Position = [yp1(1)/2000,xp1(1)/2000,yp1(1)/2000,xp1(1)/2000];
% annotation('line',[0,yp1(1)/1000]/h.Position(3),[0,xp1(1)/1000]/h.Position(3))
legend(["Deputy 1","Deputy 2","Chief"])
axis equal;
grid on;
xlabel("T [km]")
ylabel("R [km]")
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "design_3_rt_periapsis.eps",'epsc')

h = figure;
hold on;
rectangle("Position",[-epsilon,-epsilon,2*epsilon,2*epsilon]/1000,"Curvature",[1,1],"FaceColor",[1,0,0,0.2],"EdgeColor",'w');
plot(zp1/1000,xp1/1000,"LineWidth",2,"Color","blue")
plot(zp2/1000,xp2/1000,"LineWidth",2,"Color","red")
scatter(0,0,'filled','black')
legend(["Deputy 1", "Deputy 2","Chief"])
axis equal;
grid on;
xlabel("N [km]")
ylabel("R [km]")
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "design_3_rn_periapsis.eps",'epsc')

[X,Y,Z] = cylinder(epsilon/1000);
% X = [X, X];
% Y = [Y, Y];
Z = -15*ones(2,length(Z));
% Z = [-Z, Z];
%%
h = figure;
hold on;
% rectangle("Position",[-epsilon,-epsilon,2*epsilon,2*epsilon]/1000,"Curvature",[1,1],"FaceColor",[1,0,0,0.2],"EdgeColor",'w');
plot3(xp1/1000,15*ones(1,length(xp1)),zp1/1000,"LineWidth",2,"Color","blue")
plot3(xp1/1000,yp1/1000,-10*ones(1,length(xp1)),"LineWidth",2,"Color","blue")
plot3(xp2/1000,15*ones(1,length(xp2)),zp2/1000,"LineWidth",2,"Color","red")
plot3(xp2/1000,yp2/1000,-10*ones(1,length(xp2)),"LineWidth",2,"Color","red")
% plot3(xp2/1000,yp2/1000,zp2/1000,"LineWidth",2)
scatter3(0,0,-10,'filled','black')
scatter3(0,15,0,'filled','black')
% surf(X,Z,Y,'EdgeColor','none','FaceColor','red','FaceAlpha',0.2)
legend("Deputy 1", '',"Deputy 2",'',"Chief",'')
% legend(["Deputy 1", '', "Deputy 2", ''])
axis equal;
grid on;
xlabel("R [km]")
xlim([-15,15])
ylabel("T [km]")
ylim([-15,15])
zlabel("N [km]")
zlim([-10,10])
fontsize(gcf,scale=1.5)
view(-25,15)
hold off;
saveas(h,figurepath + "design_3_periapsis_3d.eps",'epsc')

%% Min Separation
w = 0:0.01:2*pi;
nu = 0:0.001:2*pi;
r1_min_numerical = [];
r2_min_numerical = [];
nu = 0:0.001:2*pi;
r1_min_analytical = [];
r2_min_analytical = [];
for i = 1:length(w)
    x1 = -a*de1*cos(nu+w(i)-psi1);
    y1 = a*(1./(1+e.*cos(nu))+1).*de1.*sin(nu+w(i)-psi1);
    z1 = a*1./(1+e.*cos(nu)).*di1.*sin(nu+w(i)-phi1);
    r1_min_numerical = [r1_min_numerical, min(sqrt(x1.^2+z1.^2))];
    r1_min_analytical = [r1_min_analytical, minSepRN(a,EROE1(3:4),EROE1(5:6),1+e)];

    x2 = -a*de2*cos(nu+w(i)-psi2);
    y2 = a*(1./(1+e*cos(nu))+1).*de2.*sin(nu+w(i)-psi2);
    z2 = a*1./(1+e*cos(nu)).*di2.*sin(nu+w(i)-phi2);
    r2_min_numerical = [r2_min_numerical, min(sqrt(x2.^2+z2.^2))];
    r2_min_analytical = [r2_min_analytical, minSepRN(a,EROE2(3:4),EROE2(5:6),1+e)];
end

h = figure;
hold on;
plot(rad2deg(w),r1_min_numerical,'LineWidth',2,'Color','blue');
plot(rad2deg(w),r2_min_numerical,'LineWidth',2,'Color','red');
plot(rad2deg(w),beta*epsilon.*ones(length(w)),'--','LineWidth',2,'Color','black');
grid on;
legend('Deputy 1 True','Deputy 2 True','Analytical Lower Bound','Location','southeast')
xlabel('\omega [deg/s]')
ylim([0,max([r1_min_numerical,r2_min_numerical])])
ylabel('Min RN Separation [m]')
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "design_3_rn_min_separation.eps",'epsc')