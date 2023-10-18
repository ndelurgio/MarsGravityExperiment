function Gamma = getChernickControlInputMatrix(OE, mu)
% Inputs:   OE 6x1 = [ a, e, i, Ω, ω, M ]
%           
% Outputs:  Control Input Matrix (6x3)

a = OE(1);
e = OE(2);
w = OE(5);
M = OE(6);
nu = M2nu(M,e);

n = meanMotion(mu,a);
eta = sqrt(1-e^2);

G11 = 2/eta*e*sin(nu);
G12 = 2/eta*(1+e*cos(nu));

G21 = -2*eta^2/(1+e*cos(nu));

G31 = eta*sin(nu);
G32 = eta*(e+cos(nu)*(2+e*cos(nu)))/(1+e*cos(nu));

G41 = -eta/e*cos(nu);
G42 = eta/e*sin(nu)*(2+e*cos(nu))/(1+e*cos(nu));

theta = nu + w;
G53 = eta*cos(theta)/(1+e*cos(nu));
G63 = eta*sin(theta)/(1+e*cos(nu));


Gamma = 1/(n*a)*[
    G11, G12, 0;
    G21, 0,   0;
    G31, G32, 0;
    G41, G42, 0;
    0,   0,   G53;
    0,   0,   G63
];

% G11 = 2/eta*e*sin(nu);
% G12 = 2/eta*(1+e*cos(nu));
% 
% G21 = -2*eta^2/(1+e*cos(nu));
% G22 = eta^2*(1-sin(nu))*(2+e*cos(nu))/(e*(1+e*cos(nu)));
% 
% G31 = eta*sin(nu);
% G32 = eta*(e+cos(nu)*(2+e*cos(nu)))/(1+e*cos(nu));
% 
% G41 = -eta/e*cos(nu);
% G42 = eta*(2+e*cos(nu))/(e*(1+e*cos(nu)));
% 
% theta = nu + w;
% G53 = eta*cos(theta)/(1+e*cos(nu));
% G63 = eta*sin(theta)/(1+e*cos(nu));


Gamma = 1/(n*a)*[
    G11, G12, 0;
    G21, 0,   0;
    G31, G32, 0;
    G41, G42, 0;
    0,   0,   G53;
    0,   0,   G63
];

end

