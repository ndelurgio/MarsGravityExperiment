rp = 170e3 + 3389.5e3;
Rcb = 3389.5e3;
mu = 4.2828372e13;
J2 = 0.001960454;
kappa = [];
evec = 0:0.001:0.99;
for e = evec
    kappa = [kappa, 3/4 * J2 * Rcb^2 * sqrt(mu) / ((rp/(1-e))^(7/2)*(1-e^2)^4)];
end

figure;
plot(evec, kappa)