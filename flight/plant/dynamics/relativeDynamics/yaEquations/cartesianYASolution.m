function matrixYA = cartesianYASolution(a, e, nu, t, mu)
% The matrix-vector solution to Yamanaka-Ankersen (YA) equations

n = meanMotion(mu, a);
eta = sqrt(1 - e^2);

I_matrix = [a * eta^2 * eye(3), zeros(3);
            zeros(3), a * n / eta * eye(3)];

k = 1 + e * cos(nu);
k_prime = -e * sin(nu);
tau = n * t / eta^3;

psi_x1 = 1/k + 3/2 * k_prime * tau;
psi_x2 = sin(nu);
psi_x3 = cos(nu);

psi_y1 = -3/2 * k * tau;
psi_y2 = (1 + 1/k) * cos(nu);
psi_y3 = -(1 + 1/k) * sin(nu);
psi_y4 = 1/k;

psi_z5 = 1/k * sin(nu);
psi_z6 = 1/k * cos(nu);

psi_dx1 = k_prime/2 - 3/2 * k^2 * (k - 1) * tau;
psi_dx2 = k^2 * cos(nu);
psi_dx3 = -k^2 * sin(nu);

psi_dy1 = -3/2 * (k + k^2 * k_prime * tau);
psi_dy2 = -(k^2 + 1) * sin(nu);
psi_dy3 = -e - (k^2 + 1) * cos(nu);
psi_dy4 = -k_prime;                                 

psi_dz5 = e + cos(nu);
psi_dz6 = -sin(nu);

psi_matrix = [psi_x1, psi_x2, psi_x3, 0, 0, 0;
              psi_y1, psi_y2, psi_y3, psi_y4, 0, 0;
              0, 0, 0, 0, psi_z5, psi_z6;
              psi_dx1, psi_dx2, psi_dx3, 0, 0, 0;
              psi_dy1, psi_dy2, psi_dy3, psi_dy4, 0, 0;
              0, 0, 0, 0, psi_dz5, psi_dz6];
matrixYA = I_matrix * psi_matrix;

end
