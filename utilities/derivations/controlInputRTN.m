syms a e w nu  n eta k theta

% a = OE(1);
% e = OE(2);
% w = OE(5);
% nu = M2nu(OE(6),e);
% 
% n = meanMotion(mu, a);
% eta = sqrt(1 - e^2);
% 
% k = 1 + e * cos(nu);
nud = n*k^2/eta^3;
kd = -e*sin(nu)*nud;
% theta = w + nu;

psi_x1 = 1/k - 3/2*e/eta^3*sin(nu)*n*t;
psi_x3 = -cos(theta);
psi_x4 = -sin(theta);

psi_y1 = -3/2*k/eta^3*n*t;
psi_y2 = 1/k;
psi_y3 = (1/k+1)*sin(theta);
psi_y4 = -(1/k+1)*cos(theta);

psi_z5 = 1/k * sin(theta);
psi_z6 = -1/k * cos(theta);

psi_dx1 = -1/k^2*kd - 3/2*e/eta^3*cos(nu)*nud*n*t - 3/2*e/eta^3*sin(nu)*n;
psi_dx3 = sin(theta)*nud;
psi_dx4 = -cos(theta)*nud;

psi_dy1 = -3/2*kd/eta^3*n*t - 3/2*k/eta^3*n;
psi_dy2 = -1/k^2*kd;
psi_dy3 = -1/k^2*kd*sin(theta) + (1/k+1)*cos(theta)*nud;
psi_dy4 = 1/k^2*kd*cos(theta) + (1/k+1)*sin(theta)*nud;                                 

psi_dz5 = -1/k^2*kd*sin(theta) + 1/k*cos(theta)*nud;
psi_dz6 = 1/k^2*kd*cos(theta) + 1/k*sin(theta)*nud;

matrixGuffanti = a*[psi_x1, 0, psi_x3, psi_x4, 0, 0;
                  psi_y1, psi_y2, psi_y3, psi_y4, 0, 0;
                  0, 0, 0, 0, psi_z5, psi_z6;
                  psi_dx1, 0, psi_dx3, psi_dx4, 0, 0;
                  psi_dy1, psi_dy2, psi_dy3, psi_dy4, 0, 0;
                  0, 0, 0, 0, psi_dz5, psi_dz6];

invMatrixGuffanti = inv(matrixGuffanti);
Gamma = simplify(invMatrixGuffanti(:,4:6));
Gamma = subs(Gamma,2*k + e^2*cos(nu)^2 - e^2 - k^2,eta^2);
Gamma = simplify(subs(Gamma,k,1+e*cos(nu)));
Gamma = simplify(subs(Gamma,e^2-1,-eta^2))