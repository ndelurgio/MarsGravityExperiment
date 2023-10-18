dex = telem.("Osculating Eccentric Singular ROE True.relativeEccentricityX");
dey = telem.("Osculating Eccentric Singular ROE True.relativeEccentricityY");
dix = telem.("Osculating Eccentric Singular ROE True.relativeInclinationX");
diy = telem.("Osculating Eccentric Singular ROE True.relativeInclinationY");
a = plant.chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
p = 1 + plant.chief.initialConditions.meanOrbitElements.eccentricity;

dr = [];
% for i = 1:length(dex)
n = length(time);
for i = 1:n
    de = [dex(i),dey(i)];
    di = [dix(i),diy(i)];
    min_sep = sqrt(2)*a*abs(dot(de,di/p)) / sqrt(norm(de)^2 + norm(di/p)^2 + dot(abs(de+di/p), abs(de-di/p)));
    dr = [dr, min_sep];
    rad2deg(subspace(de',di'))
end

figure
a1 = axes();
plot(a1, time(1:n)/3600, dr(1:n))
% xlim(a1, [0, 20])
% ylim(a1, [0, 80])
% scatter(a1, 2.9295, 2.8593, "filled")
xlabel("t [hr]")
ylabel("Minimum Seperation [m]")
% a2 = axes();
% a2.Position = [0.6 0.35 0.2 0.2]; % xlocation, ylocation, xsize, ysize
% plot(a2, time(100000:120000)/3600, dr(100000:120000)); axis tight
% annotation('ellipse',[0.2 0.1 0.075 0.075]) % xlocation, ylocation, xsize, ysize
% annotation('arrow',[0.55 0.25],[0.45 0.15]) % x0, xf, y0, yf
