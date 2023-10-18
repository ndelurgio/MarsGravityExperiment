function [t, rate_sign] = diy_time(OE,EROE,diy_min,diy_max,cb)
a = OE(1);
e = OE(2);
i = OE(3);
w = OE(5);
de = norm(EROE(3:4,1));
psi = wrapTo2Pi(atan2(EROE(4,1),EROE(3,1)));
dix = EROE(5);
diy = EROE(6);
J2 = cb.J2;
r = cb.radius_m;
mu = cb.gravitationalParameter_m3_s2;
eta = sqrt(1-e^2);
k = 3/4*J2*r^2*sqrt(mu)/(a^(7/2)*eta^4);
diy_dot = -2*k*(2*e*sin(2*i)*de*cos(psi-w)-dix*sin(i)^2);
rate_sign = sign(diy_dot);
if rate_sign == 1
    t = (diy_max - diy)/diy_dot;
else
    t = (diy_min - diy)/diy_dot;
end
end