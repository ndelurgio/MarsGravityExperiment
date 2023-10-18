function [mu,cov,mu_prefit] = ukf(mu_prev,cov_prev, y, u, Bsrp_c, Bsrp_d, sunPos, dt, Q, R)

% CONSTANTS
mu_earth = 3.986004419e14;
J2 = 0.108263e-2;
Re = 6.378e6;
AU = 1.496e11;
p_sr = 4.5344321e-6;

n = length(mu_prev);
m = length(y);
[x,w] = UT(mu_prev,cov_prev);
% Predict
for i = 1:(2*n+1)
    x(:,i) = dynamicsModel(x(:,i),u,sunPos,Bsrp_c,Bsrp_d,dt,mu_earth,J2,Re,AU,p_sr);
end
[mu,cov] = UTinv(x,w);
mu_prefit = mu;
cov = cov + Q;
% Update
[x,w] = UT(mu,cov);
y_predict = zeros(m,2*n+1);
for i = 1:(2*n+1)
    y_predict(:,i) = measurementModel(x(:,i),u,Bsrp_c,Bsrp_d,p_sr,sunPos,Re,AU);
end
Ey = zeros(m,1);
for i = 1:(2*n+1)
    Ey = Ey + w(1,i)*y_predict(:,i);
end
cov_y = zeros(m,m);
for i = 1:(2*n+1)
    cov_y = cov_y + w(1,i)*(y_predict(:,i)-Ey)*(y_predict(:,i)-Ey)';
end
cov_y = cov_y + R;

cov_xy = zeros(n,m);
for i = 1:(2*n+1)
    cov_xy = cov_xy + w(1,i)*(x(:,i)-mu)*(y_predict(:,i)-Ey)';
end

mu = mu + cov_xy*inv(cov_y)*(y-Ey);
cov = cov - cov_xy*inv(cov_y)*cov_xy';

end

