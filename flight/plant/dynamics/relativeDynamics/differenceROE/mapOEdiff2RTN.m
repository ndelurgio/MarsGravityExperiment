function relativeCartesianState = mapOEdiff2RTN(diffOE,OE,mu)
da = diffOE(1);
de = diffOE(2);
di = diffOE(3);
dO = diffOE(4);
dw = diffOE(5);
dM = diffOE(6);

a = OE(1);
e = OE(2);
i = OE(3);
O = OE(4);
w = OE(5);
nu = M2nu(OE(6),e);
u = w + nu;
n = meanMotion(mu,a);

k = 1 + e*cos(nu);
eta = sqrt(1-e^2);
r = a*eta^2/k;

dr = r/a*da - a*de*cos(nu) + a*e/eta*dM*sin(nu);
dt = a*(1+1/eta^2*r/a)*de*sin(nu)+a^2*eta/r*dM + r*(dw+dO*cos(i));
dn = r*(di*sin(u) - dO*sin(i)*cos(u));

dvr = -n*a*sin(nu)/eta*(e/(2*a)*da + a/r*de) - n*a^3/r^2*dM - n*a^2*eta/r*(dw+dO*cos(i));
dvt = n*a/eta*((e+cos(nu))/eta^2*de - eta^2/(2*r)*da + e*(dw+dO*cos(i))*sin(nu));
dvn = n*a/eta*((cos(u)+e*cos(w))*di + sin(i)*(sin(u)+e*sin(w))*dO);

relativeCartesianState = [dr, dt, dn, dvr, dvt, dvn];

end

