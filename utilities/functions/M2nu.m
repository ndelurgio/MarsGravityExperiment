function nu = M2nu(M,e)
E = kepler(M,e);
nu = 2*atan(sqrt((1+e)/(1-e))*tan(E/2));
if nu < 0
    nu = nu + 2*pi;
end
end