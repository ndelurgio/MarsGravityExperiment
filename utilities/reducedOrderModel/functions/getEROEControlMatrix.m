function B = getEROEControlMatrix(OE,mu)
a = OE(1);
e = OE(2);
i = OE(3);
O = OE(4);
w = OE(5);
M = OE(6);
n = meanMotion(mu,a);
nu = M2nu(M,e);
theta = nu + w;
ex = e*cos(w);
ey = e*sin(w);
eta = sqrt(1-e^2);

G11 = 2*e*sin(nu);
G12 = 2*(1+e*cos(nu));

G21 = (e*cos(nu)+2)*(e*cos(nu)-1)/(1+e*cos(nu));
% G22 = -(2+e*cos(nu))*(sin(nu)-eta^2)/(e*(1+e*cos(nu)));
G22 = -e*sin(nu)*(2+e*cos(nu))/(1+e*cos(nu));

G31 = ((1+e*cos(nu))*sin(theta) - 2*ey)/(1+e*cos(nu));
G32 = ((2+e*cos(nu))*cos(theta) + ex)/(1+e*cos(nu));

G41 = -((1+e*cos(nu))*cos(theta) - 2*ex)/(1+e*cos(nu));
G42 = ((2+e*cos(nu))*sin(theta) + ey)/(1+e*cos(nu));

G53 = eta^2*cos(theta)/(1+e*cos(nu));
G63 = eta^2*sin(theta)/(1+e*cos(nu));



B = eta/(n*a)*[
    G11, G12, 0;
    G21, G22, 0;
    G31, G32, 0;
    G41, G42, 0;
    0  ,   0, G53;
    0  ,   0, G63
];
end