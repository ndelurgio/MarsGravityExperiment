function sunPos = sunOE_to_sunPos(sunOE)
a = sunOE(1,1);
e = sunOE(2,1);
i = sunOE(3,1);
Om = sunOE(4,1);
w = sunOE(5,1);
M = sunOE(6,1);
nu = M2nu(M,e);
lam = w + nu;

r = a*(1-e^2)/(1+e*cos(nu));
sunPos = ...
    r * [
    cos(Om)*cos(lam) - sin(Om)*sin(lam)*cos(i);
    sin(Om)*cos(lam) + cos(Om)*sin(lam)*cos(i);
    sin(lam)*sin(i)
    ];

end

