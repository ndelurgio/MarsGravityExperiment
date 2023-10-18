function STM = computeEccentricROE_STM(OE,J2,r,mu,t)
a = OE(1);
e = OE(2);
i = OE(3);
O = OE(4);
w = OE(5);
M = OE(6);

n = meanMotion(mu,a);
eta = sqrt(1-e^2);
k = 3/4*J2*r^2*sqrt(mu)/(a^(7/2)*eta^4);
wd = k*(5*cos(i)^2-1);

M = eta^3-eta-2;
C = 3*cos(i)^2-1;
N = 4*eta^2+3;
S = 3*sin(i)^2-2;
L = eta+2;
A = 3*C*e^2*k*cos(w)^2;
B = 3/2*C*e^2*k*sin(2*w);
Q = 3*C*e^2*k*sin(w)^2;
U = -3*e*k*sin(2*i)*sin(w);
V = -3*e*k*sin(2*i)*cos(w);

phi_11 = eta^2;

phi_21 = -t*(3*n-7*k*M*C)/(2*eta);
phi_22 = eta^2;
phi_23 = t*k*e*cos(w)*N*C;
phi_24 = t*k*e*sin(w)*N*C;
phi_25 = -t*k*sin(2*i)*N;

phi_31 = -t*e*(3*n+7*k*L*S)*sin(w + wd*t)/(2*eta);
phi_33 = t*A*sin(wd*t) + (t*B+eta^2)*cos(wd*t);
phi_34 = t*Q*cos(wd*t) + (t*B-eta^2)*sin(wd*t);
phi_35 = t*U*cos(wd*t) + t*V*sin(wd*t);

phi_41 = t*e*(3*n-7*k*L*C)*cos(w+wd*t)/(2*eta);
phi_43 = -t*A*cos(wd*t) + (t*B+eta^2)*sin(wd*t);
phi_44 = t*Q*sin(wd*t) - (t*B-eta^2)*cos(wd*t);
phi_45 = -t*V*cos(wd*t) + t*U*sin(wd*t);

phi_55 = eta^2;

phi_61 = 7/2*t*eta^2*k*sin(2*i);
phi_63 = -4*t*e*eta^2*k*sin(2*i)*cos(w);
phi_64 = -4*t*e*eta^2*k*sin(2*i)*sin(w);
phi_65 = 2*t*eta^2*k*sin(i)^2;
phi_66 = eta^2;

STM = 1/eta^2*[
    phi_11, 0, 0, 0, 0, 0
    phi_21, phi_22, phi_23, phi_24, phi_25, 0
    phi_31, 0, phi_33, phi_34, phi_35, 0
    phi_41, 0, phi_43, phi_44, phi_45, 0
    0, 0, 0, 0, phi_55, 0
    phi_61, 0, phi_63, phi_64, phi_65, phi_66
];

end

