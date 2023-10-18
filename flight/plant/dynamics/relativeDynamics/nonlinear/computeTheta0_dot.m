function theta0_dot = computeTheta0_dot(r0,mu,a0,e0)

p0 = a0*(1-e0^2);
h0 = sqrt(mu*p0);
theta0_dot = h0/r0^2;

end