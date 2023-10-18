function relativeState_dot = computeRelativeDynamics(relativeState,r0,theta0_dot,theta0_ddot,mu)
% INPUT relativeState: 6x1 x,y,z,xdot,ydot,zdot
% OUTPUT relativeState_dot: 6x1 xdot,ydot,zdot,xddot,yddot,zddot
x = relativeState(1,1);
y = relativeState(2,1);
z = relativeState(3,1);
xdot = relativeState(4,1);
ydot = relativeState(5,1);
zdot = relativeState(6,1);

xddot = 2*theta0_dot*ydot + theta0_ddot*y + theta0_dot^2*x - mu*(r0+x)/(((r0+x)^2+y^2+z^2)^(3/2)) + mu/r0^2;
% xddot = 2*theta0_dot*ydot + theta0_ddot*y + theta0_dot^2*x + 2*mu*x/(((r0+x)^2+y^2+z^2)^(3/2));
yddot = -2*theta0_dot*xdot - theta0_ddot*x + theta0_dot^2*y - mu*y/(((r0+x)^2+y^2+z^2)^(3/2));
zddot = -mu*z/(((r0+x)^2+y^2+z^2)^(3/2));

relativeState_dot = [xdot;ydot;zdot;xddot;yddot;zddot];

end