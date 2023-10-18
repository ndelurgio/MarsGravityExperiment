da = 0; % Required
a = 1;
dlam = 4;
de = 3;

x = [];
y = [];
for ang = 0:0.001:2*pi
x = [x, -a*de*cos(ang)];
y = [y, a*dlam + 2*a*de*sin(ang)];
end
d_numerical = sqrt(x.^2+y.^2);
disp('Min RT Sep Numerical  = ' + string(min(d_numerical)));
disp('Min RT Sep Analytical = ' + string(minSepRT(a,dlam,de)));

figure;
hold on;
plot(y,x)
scatter(0,0,'filled','black')
axis equal;
grid on;
xlabel("T")
ylabel("R")
title("RT Ellipse (Circular)")

function d_min = minSepRT(a,dlam,de)
    if abs(dlam) < 3/2*de
        d_min = a*sqrt(de^2-1/3*dlam^2);
    else
        d_min = a*abs(abs(dlam) - 2*de);
    end
end

