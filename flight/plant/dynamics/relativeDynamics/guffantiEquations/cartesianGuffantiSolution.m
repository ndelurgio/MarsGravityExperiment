function matrixGuffanti = cartesianGuffantiSolution(OE, t, mu)
% The matrix-vector solution to Guffanti equations
a = OE(1);
e = OE(2);
w = OE(5);
nu = M2nu(OE(6),e);

n = meanMotion(mu, a);
eta = sqrt(1 - e^2);

rho = 1 + e * cos(nu);
nud = n*rho^2/eta^3;
rhod = -e*sin(nu)*nud;
lambda = w + nu;

psi_x1 = 1/rho - 3/2*e/eta^3*sin(nu)*n*t;
psi_x3 = -cos(lambda);
psi_x4 = -sin(lambda);

psi_y1 = -3/2*rho/eta^3*n*t;
psi_y2 = 1/rho;
psi_y3 = (1/rho+1)*sin(lambda);
psi_y4 = -(1/rho+1)*cos(lambda);

psi_z5 = 1/rho * sin(lambda);
psi_z6 = -1/rho * cos(lambda);

psi_dx1 = -1/rho^2*rhod - 3/2*e/eta^3*cos(nu)*nud*n*t - 3/2*e/eta^3*sin(nu)*n;
psi_dx3 = sin(lambda)*nud;
psi_dx4 = -cos(lambda)*nud;

psi_dy1 = -3/2*rhod/eta^3*n*t - 3/2*rho/eta^3*n;
psi_dy2 = -1/rho^2*rhod;
psi_dy3 = -1/rho^2*rhod*sin(lambda) + (1/rho+1)*cos(lambda)*nud;
psi_dy4 = 1/rho^2*rhod*cos(lambda) + (1/rho+1)*sin(lambda)*nud;                                 

psi_dz5 = -1/rho^2*rhod*sin(lambda) + 1/rho*cos(lambda)*nud;
psi_dz6 = 1/rho^2*rhod*cos(lambda) + 1/rho*sin(lambda)*nud;

matrixGuffanti = a*[psi_x1, 0, psi_x3, psi_x4, 0, 0;
                  psi_y1, psi_y2, psi_y3, psi_y4, 0, 0;
                  0, 0, 0, 0, psi_z5, psi_z6;
                  psi_dx1, 0, psi_dx3, psi_dx4, 0, 0;
                  psi_dy1, psi_dy2, psi_dy3, psi_dy4, 0, 0;
                  0, 0, 0, 0, psi_dz5, psi_dz6];

end
