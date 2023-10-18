function d_min = minSepRN(a,de,di,k)
    d_min = sqrt(2)*a*abs(dot(de,di/k)) / ...
        sqrt((norm(de)^2+norm(di/k)^2+dot(abs(de+di/k), abs(de-di/k))));
end