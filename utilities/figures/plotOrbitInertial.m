x = telem.("Chief Cartesian State.positionX_J2000_m");
y = telem.("Chief Cartesian State.positionY_J2000_m");
z = telem.("Chief Cartesian State.positionZ_J2000_m");

x_sun = telem.("Sun Position")(:,1,1);
y_sun = telem.("Sun Position")(:,2,1);
z_sun = telem.("Sun Position")(:,3,1);
a = chief.initialConditions.meanOrbitElements.semiMajorAxis_m;
u_sun = a*[x_sun(1),y_sun(1),z_sun(1)]/norm([x_sun(1),y_sun(1),z_sun(1)]);

h = figure;
hold on;
% title("J2000 Orbit")
plot3(x/1000,y/1000,z/1000,'LineWidth',2)
quiver3(0,0,0,u_sun(1)/500,u_sun(2)/500,u_sun(3)/500,"magenta","LineWidth",6)
xlabel("X [km]")
ylabel("Y [km]")
zlabel("Z [km]")
axis equal;
grid on;
view(245,20)

I = imread("8k_mars.jpg");
r_mars = environment.marsProperties.radius_m/1000;
[x,y,z] = sphere;              % create a sphere 
s = surface(r_mars*x,r_mars*y,r_mars*z);            % plot spherical surface

s.FaceColor = 'texturemap';    % use texture mapping
s.CData = flipud(I);                % set color data to topographic data
s.EdgeColor = 'none';          % remove edges
s.FaceLighting = 'gouraud';    % preferred lighting for curved surfaces
s.SpecularStrength = 0.4;      % change the strength of the reflected light

light('Position',[-1 0 1])     % add a light
legend(["Chief Orbit","Sun Vector","Mars"],'Location','northeast')
fontsize(gcf,scale=1.5)
saveas(h,figurepath + "chief_orbit.png",'png')
clear s I r_mars x y z x_sun y_sun z_sun u_sun a