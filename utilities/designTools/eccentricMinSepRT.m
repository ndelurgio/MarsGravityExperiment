da = 0; % Required
a = 1;
ex = 0.3;
ey = 0.2;
dlam = 4;
de = 3;

x = [];
y = [];
for ang = 0:0.001:2*pi
    k = 1+ex*cos(ang)+ey*sin(ang);
    x = [x, -a*de*cos(ang)];
    y = [y, a*dlam + (1/k+1)*a*de*sin(ang)];
end
d_numerical = sqrt(x.^2+y.^2);
disp('Min RT Sep True  = ' + string(min(d_numerical)));
disp('Min RT Sep Lower Bound = ' + string(minSepRT(a,dlam,de)));

figure;
hold on;
plot(y,x)
scatter(0,0,'filled','black')
axis equal;
grid on;
xlabel("T")
ylabel("R")
title("RT Ellipse")

function d_min = minSepRT(a,dlam,de)
    % d_min1 = a*sqrt()
    % if abs(dlam) < 3/2*de
    %     d_min = a*sqrt(de^2-1/3*dlam^2);
    % else
    %     d_min = a*abs(abs(dlam) - 2*de);
    % end
end

