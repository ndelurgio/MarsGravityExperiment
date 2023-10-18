a = 6.4718e+06;
e = 0.45;
w = 188;
da = 0; % Required
adex = 500;
adey = 500;
adix = -500;
adiy = -500;

ex = e*cos(w);
ey = e*sin(w);
de = [adex, adey]/a;
di = [adix, adiy]/a;
psi = atan2(adey,adex);
phi = atan2(adiy,adix);

x = [];
z = [];
for ang = 0:0.001:2*pi
    k = 1+ex*cos(ang)+ey*sin(ang);
    x = [x, -a*norm(de)*cos(ang-psi)];
    z = [z, a*(1/k)*norm(di)*sin(ang-phi)];
end
d_numerical = sqrt(x.^2+z.^2);
disp('Min RN Sep True  = ' + string(min(d_numerical)));
disp('Min RN Sep Lower Bound = ' + string(minSepRN(a,de,di,1+e)));

figure;
hold on;
plot(z,x)
scatter(0,0,'filled','black')
axis equal;
grid on;
xlabel("N")
ylabel("R")
title("RN Ellipse")

function d_min = minSepRN(a,de,di,k)
    d_min = sqrt(2)*a*abs(dot(de,di/k)) / ...
        sqrt((norm(de)^2+norm(di/k)^2+dot(abs(de+di/k), abs(de-di/k))));
    S1 = (de(1)^2+de(2)^2+(di(1)/k)^2+(di(2)/k)^2);
    S2 = sqrt((norm(de)^2-norm(di/k)^2)^2 + 4*((de(1)*di(2) - de(2)*di(1))/k)^2);
    d_min = a*sqrt((S1-S2)/2);
end
