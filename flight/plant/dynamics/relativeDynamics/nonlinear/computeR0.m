function [r0] = computeR0(cartesianPosition)

X0 = cartesianPosition(1);
Y0 = cartesianPosition(2);
Z0 = cartesianPosition(3);

r0 = sqrt(X0^2 + Y0^2 + Z0^2);

end
