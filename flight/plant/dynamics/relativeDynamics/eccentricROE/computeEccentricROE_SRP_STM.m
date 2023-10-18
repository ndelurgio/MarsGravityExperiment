function STM = computeEccentricROE_SRP_STM(OE, sunOE, mu, constants, t)
a = OE(1,1);
e = OE(2,1);
i = OE(3,1);
Om = OE(4,1);
w = OE(5,1);
M = OE(6,1);
eta = sqrt(1-e^2);
ex = e*cos(w);
ey = e*sin(w);

a_sun = sunOE(1,1);
e_sun = sunOE(2,1);
i_sun = sunOE(3,1);
Om_sun = sunOE(4,1);
w_sun = sunOE(5,1);
M_sun = sunOE(6,1);
lam_sun = w_sun + M2nu(M_sun,e_sun);

A = cos(Om-Om_sun)*cos(lam_sun) + cos(i_sun)*sin(lam_sun)*sin(Om-Om_sun);
B = cos(i)*(-sin(Om-Om_sun)*cos(lam_sun) + cos(i_sun)*sin(lam_sun)*cos(Om-Om_sun)) + sin(i)*sin(i_sun)*sin(lam_sun);
C = sin(i)*(sin(Om-Om_sun)*cos(lam_sun) - cos(i_sun)*sin(lam_sun)*cos(Om-Om_sun)) + cos(i)*sin(i_sun)*sin(lam_sun);

AU = constants.AU_m;
c = constants.c_mps;
r_sun = norm(sunOE_to_sunPos(sunOE));
solarflux = constants.solarflux;

alpha = 3/2/sqrt(mu) * solarflux/c * (AU/r_sun)^2;

phi_17 = alpha * sqrt(a) * 0;
phi_27 = alpha * sqrt(a) * -(eta+3/eta) * (A*ex + B*ey) * t;
phi_37 = alpha * sqrt(a) * -1/eta * (B*(eta^2+3*ey^2) + 3*A*ex*ey) * t;
phi_47 = alpha * sqrt(a) * 1/eta * (A*(eta^2+3*ex^2) + 3*B*ex*ey) * t;
phi_57 = alpha * sqrt(a) * C*eta*ex*t;
phi_67 = alpha * sqrt(a) * C*eta*ey*t;

STM = [
    1 0 0 0 0 0 phi_17;
    0 1 0 0 0 0 phi_27;
    0 0 1 0 0 0 phi_37;
    0 0 0 1 0 0 phi_47;
    0 0 0 0 1 0 phi_57;
    0 0 0 0 0 1 phi_67;
    0 0 0 0 0 0 1
];

end

