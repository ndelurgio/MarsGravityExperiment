syms t A B eta V Q U dex dey dix C e w0 k i 

A = 3*C*e^2*k*cos(w0)^2;
B = 3/2*C*e^2*k*sin(2*w0);
Q = 3*C*e^2*k*sin(w0)^2;
U = -3*e*k*sin(2*i)*sin(w0);
V = -3*e*k*sin(2*i)*cos(w0);

eta2de2 = (t*A*dex+(t*B-eta^2)*dey+t*V*dix)^2+((t*B+eta^2)*dex+t*Q*dey+t*U*dix)^2;
de2 = simplify(simplifyFraction(eta2de2)/eta^2)
