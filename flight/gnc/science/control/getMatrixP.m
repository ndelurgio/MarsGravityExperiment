function P = getMatrixP(pseudoState, theta)
% Calculate the P matrix for Lyapunov control

k = 10;
N = 0;
oop_gain = 0.1;

delta_ex = pseudoState(3);
delta_ey = pseudoState(4);
theta_ip = atan2(delta_ey,delta_ex);

delta_ix = pseudoState(5);
delta_iy = pseudoState(6);
theta_oop = atan2(delta_iy,delta_ix);

Jp = theta - theta_ip;
Hp = theta - theta_oop;

P = 1/k * [cos(Jp)^N        0           0           0           0                           0;
           0             cos(Jp)^N      0           0           0                           0;
           0                0       cos(Jp)^N       0           0                           0;
           0                0           0       cos(Jp)^N       0                           0;
           0                0           0           0           oop_gain*cos(Hp)^N          0;
           0                0           0           0           0                           oop_gain*cos(Hp)^N;
];  

end
