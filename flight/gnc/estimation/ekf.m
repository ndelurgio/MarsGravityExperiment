function [mu,cov,mu_prefit] = ekf(mu_prev,cov_prev, y, u, Bsrp_c, Bsrp_d, sunPos, dt, Q, R)

% CONSTANTS
mu_earth = 3.986004419e14;
J2 = 0.108263e-2;
Re = 6.378e6;
AU = 1.496e11;
p_sr = 4.5344321e-6;

% Predict
mu = dynamicsModel(mu_prev,u,sunPos,Bsrp_c,Bsrp_d,dt,mu_earth,J2,Re,AU,p_sr);
mu_prefit = mu;
A = getA(mu_prev,u,sunPos,Bsrp_c,Bsrp_d,dt,mu_earth,J2,Re,AU,p_sr);
cov = A*cov_prev*A' + Q;
% Kalman Gain
H = getMatrixH(mu,sunPos,Bsrp_c,Bsrp_d,AU,p_sr);
S = H*cov*H'+R;  % innovation covariance
K = cov*H'*inv(S);
% Expected Measurement
Ey = measurementModel(mu,u,Bsrp_c,Bsrp_d,p_sr,sunPos,Re,AU);
mu = mu + K*(y-Ey);
cov = cov - K*S*K';
% cov = cov - K*H*cov;

end
