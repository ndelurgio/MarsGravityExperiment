function [r0_dot] = computeR0_dot(oe0, n0, r0)

a0 = oe0(1);
e0 = oe0(2);
i0 = oe0(3);
Om0 = oe0(4);
w0 = oe0(5);
nu0 = oe0(6);

p0 = a0 * (1 - e0^2);

r0_prime = p0 * e0 * sin(nu0) / (1 + e0 * cos(nu0))^2;
f0_dot = n0 * a0^2 * sqrt(1 - e0^2) / r0^2;
r0_dot = r0_prime * f0_dot;

end
