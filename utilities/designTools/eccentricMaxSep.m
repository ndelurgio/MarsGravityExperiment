a = 6.4718e+06;
e = 0.45;
w = 188;
da = 0; % Required
adlam = -200;
adex = 500;
adey = 500;
adix = -500;
adiy = -500;

ex = e*cos(w);
ey = e*sin(w);
dlam = adlam/a;
de = [adex, adey]/a;
di = [adix, adiy]/a;
psi = atan2(adey,adex);
phi = atan2(adiy,adix);

x = [];
y = [];
z = [];
for ang = 0:0.001:2*pi
    k = 1+ex*cos(ang)+ey*sin(ang);
    x = [x, -a*norm(de)*cos(ang-psi)];
    y = [y, a*dlam/k + (1/k+1)*a*norm(de)*sin(ang-psi)];
    z = [z, a*(1/k)*norm(di)*sin(ang-phi)];
end
d_numerical = sqrt(x.^2 + y.^2 + z.^2);
disp('Max Sep True  = ' + string(max(d_numerical)));
disp('Max Sep Upper Bound  = ' + string(maxSep(a,dlam,de,di,1-e)));

figure;
hold on;
plot3(y,z,x)
scatter(0,0,'filled','black')
axis equal;
grid on;
xlabel("T")
ylabel("N")
zlabel("R")
title("RTN Ellipse (Circular)")
view(30,30)

function d_max = maxSep(a,dlam,de,di,k)
    S1 = (de(1)^2+de(2)^2+(di(1)/k)^2+(di(2)/k)^2);
    S2 = sqrt((norm(de)^2-norm(di/k)^2)^2 + 4*((de(1)*di(2) - de(2)*di(1))/k)^2);
    d_max_RN = a*sqrt((S1+S2)/2);
    d_max_RT = a*max(abs(1/k * dlam + (1/k+1)*norm(de)),abs(1/k * dlam - (1/k+1)*norm(de)));
    % Works because R = 0, all in T
    d_max = sqrt(d_max_RT^2 + d_max_RN^2);
    %Relaxed Condition
    % d_max = a*sqrt(norm(de)^2 + (1/k*dlam + (1/k+1)*norm(de))^2 + 1/k*norm(di));
end