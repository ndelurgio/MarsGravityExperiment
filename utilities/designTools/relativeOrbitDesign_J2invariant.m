%Inputs
periapsis_altitude = 130e3;
r_periapsis = periapsis_altitude + 3389.5e3; % Radius of Mars
e = 0.4;
a = r_periapsis / (1-e);
y1 = 10e3;
y2 = -10e3;
w0 = deg2rad(188);
dr_min = 500;

ex0 = e*cos(w0);
ey0 = e*sin(w0);
y1plot = y1;
y2plot = y2;

% Deputy 1
ang1 = pi/2;
psi10 = w0 - ang1;
dlam1 = 0;
de1 = y1*(1+e)/(a*(2+e));
dex10 = de1*cos(psi10);
dey10 = de1*sin(psi10);
di1 = 0;
phi1 = 0;
dix1 = 0;
diy1 = 0;
ROE1 = a*[0,dlam1,dex10,dey10,dix1,diy1]

% Deputy 2
ang2 = -pi/2;
psi20 = w0 - ang2;
dlam2 = 0;
de2 = -y2*(1+e)/(a*(2+e));
dex20 = de2*cos(psi20);
dey20 = de2*sin(psi20);
di2 = 0;
phi2 = 0;
dix2 = 0;
diy2 = 0;
ROE2 = a*[0,dlam2,dex20,dey20,dix2,diy2]

x1 = [];
y1 = [];
z1 = [];
x2 = [];
y2 = [];
z2 = [];
for ang = 0:0.001:2*pi
    k = 1+ex0*cos(ang)+ey0*sin(ang);
    x1 = [x1, -a*norm(de1)*cos(ang-psi10)];
    y1 = [y1, a*dlam1/k + (1/k+1)*a*norm(de1)*sin(ang-psi10)];
    z1 = [z1, a*(1/k)*norm(di1)*sin(ang-phi1)];

    x2 = [x2, -a*norm(de2)*cos(ang-psi20)];
    y2 = [y2, a*dlam2/k + (1/k+1)*a*norm(de2)*sin(ang-psi20)];
    z2 = [z2, a*(1/k)*norm(di2)*sin(ang-phi2)];
end

h = figure;
hold on;
dr_min = dr_min/1000;
rectangle("Position",[-dr_min,-dr_min,2*dr_min,2*dr_min],"Curvature",[1,1],"FaceColor",[1,0,0,0.2],"EdgeColor",'w');
plot(y1/1000,x1/1000,"LineWidth",2)
plot(y2/1000,x2/1000,"LineWidth",2)
scatter(0,0,'filled','black')
scatter(y1plot/1000,0,128,'diamond','filled','magenta')
scatter(y2plot/1000,0,128,'diamond','filled','magenta')
legend(["Deputy 1", "Deputy 2","Chief","Periapsis"])
axis equal;
grid on;
xlabel("T [km]")
ylabel("R [km]")
% title("RT Ellipse")
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "design_2_rt.eps",'epsc')

