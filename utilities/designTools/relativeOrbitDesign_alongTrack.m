%Inputs
dr_min = 500;
e = 0.45;
a = 6.471818181818182e+06;
y1 = 10e3;
y2 = -10e3;
w0 = deg2rad(188);
ex0 = e*cos(w0);
ey0 = e*sin(w0);

de_min = 1.0 * dr_min / a;
di_min = 1.0 * dr_min / a * (1+e);

di1 = di_min;
phi1 = deg2rad(270);
de1 = de_min;
psi1 = deg2rad(90);

di2 = di_min;
phi2 = deg2rad(90);
de2 = de_min;
psi2 = deg2rad(270);

% Deputy 1
dlam1 = (1+e)*y1/a;
dix1 = di1*cos(phi1);
diy1 = di1*sin(phi1);
dex1 = de1*cos(psi1);
dey1 = de1*sin(psi1);
disp("Deputy 1 Min RN Separation Lower Bound = " + string(minSepRN(a,[dex1;dey1],[dix1;diy1],1+e)))
aEROE1 = a*[0, dlam1, dex1, dey1, dix1, diy1];

% Deputy 2
dlam2 = (1+e)*y2/a;
dix2 = di2*cos(phi2);
diy2 = di2*sin(phi2);
dex2 = de2*cos(psi2);
dey2 = de2*sin(psi2);
disp("Deputy 2 Min RN Separation Lower Bound = " + string(minSepRN(a,[dex2;dey2],[dix2;diy2],1+e)))
aEROE2 = a*[0, dlam2, dex2, dey2, dix2, diy2];

x1 = [];
y1 = [];
z1 = [];
x2 = [];
y2 = [];
z2 = [];
for ang = 0:0.001:2*pi
    k = 1+ex0*cos(ang)+ey0*sin(ang);
    x1 = [x1, -a*norm(de1)*cos(ang-psi1)];
    y1 = [y1, a*dlam1/k + (1/k+1)*a*norm(de1)*sin(ang-psi1)];
    z1 = [z1, a*(1/k)*norm(di1)*sin(ang-phi1)];

    x2 = [x2, -a*norm(de2)*cos(ang-psi2)];
    y2 = [y2, a*dlam2/k + (1/k+1)*a*norm(de2)*sin(ang-psi2)];
    z2 = [z2, a*(1/k)*norm(di2)*sin(ang-phi2)];
end
disp("Deputy 1 Min RN Separation Numerical = " + string(min(sqrt(x1.^2+z1.^2))));
disp("Deputy 2 Min RN Separation Numerical = " + string(min(sqrt(x2.^2+z2.^2))));

h = figure;
hold on;
plot(y1/1000,x1/1000,"LineWidth",2)
plot(y2/1000,x2/1000,"LineWidth",2)
scatter(0,0,'filled','black')
legend(["Deputy 1", "Deputy 2","Chief"])
axis equal;
grid on;
xlabel("T [km]")
ylabel("R [km]")
% title("RT Ellipse")
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "design_1_rt.eps",'epsc')

h = figure;
hold on;
rectangle("Position",[-dr_min,-dr_min,2*dr_min,2*dr_min],"Curvature",[1,1],"FaceColor",[1,0,0,0.2],"EdgeColor",'w');
plot(z1,x1,"LineWidth",2)
plot(z2,x2,"LineWidth",2)
scatter(0,0,'filled','black')
legend(["Deputy 1", "Deputy 2","Chief","Keep-Out"])
axis equal;
grid on;
xlabel("N [m]")
ylabel("R [m]")
% title("RN Ellipse")
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "design_1_rn.png",'png')