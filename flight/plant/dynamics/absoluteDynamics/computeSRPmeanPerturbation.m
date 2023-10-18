function OEdot = computeSRPmeanPerturbation(Ball, OE, sunOE, mu, constants)

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

OEdot = alpha*Ball*sqrt(a) * [
    0;
    -eta*(-A*sin(w)+B*cos(w));
    ex/eta*C;
    ey/eta*C/sin(i);
    eta/e*(A*cos(w)+B*sin(w)) - ey/eta*cot(i)*C;
    -(3*e+eta^2/e)*(A*cos(w)+B*sin(w))
];

end

