function [t,rate_sign] = dlam_time(OE,EROE,dlam_min,dlam_max,cb)
a = OE(1);
e = OE(2);
i = OE(3);
w = OE(5);
dlam = EROE(2);
de = norm(EROE(3:4,1));
psi = wrapTo2Pi(atan2(EROE(4,1),EROE(3,1)));
dix = EROE(5);
diy = EROE(6);
J2 = cb.J2;
r = cb.radius_m;
mu = cb.gravitationalParameter_m3_s2;
eta = sqrt(1-e^2);
k = 3/4*J2*r^2*sqrt(mu)/(a^(7/2)*eta^4);
C = 3*cos(i)^2-1;
N = 4*eta^2+3;
dlam_dot = k*N*(C*e*de*cos(psi-w)-dix*sin(2*i))/eta^2;
rate_sign = sign(dlam_dot);
if rate_sign == 1
    t = (dlam_max-dlam)/dlam_dot;
else
    t = (dlam_min - dlam)/dlam_dot;
end
end