% syms e nu theta k ex ey eta D k
% 
% Gamma_RTN = [
% 2*e*sin(nu), 2*k, 0;
% (k+1)*(k-1)/k, (k+1)*(sin(nu)-eta^2)/(e*k), 0;
% (k*sin(theta)-2*ey)/k, ((k+1)*cos(theta)+ex)/k, 0;
% -(k*cos(theta)-2*ex)/k, ((k+1)*sin(theta)+ey)/k, 0;
% 0, 0, eta^2*cos(theta)/k;
% 0, 0, eta^2*sin(theta)/k;
% ];
% 
% VNC2RTN = [
%     k/D, -e*sin(nu)/D, 0;
%     e*sin(nu)/D, k/D, 0;
%     0, 0, 1;
% ];
% 
% 
% Gamma_VNC = Gamma_RTN*VNC2RTN;
% Gamma_VNC = subs(Gamma_VNC, k, 1+e*cos(nu))
syms eta ad ed id wd Od Md a e i w O M

ROE = [
eta^2*(ad-a)/a,...
1/eta*(Md-M) + eta^2*(wd - w + (Od-O)*cos(i)),...
(ed-e)*cos(w) + e/eta*(Md-M)*sin(w),...
(ed-e)*sin(w) - e/eta*(Md-M)*cos(w),...
eta^2*(id-i),...
eta^2*(Od-O)*sin(i)
];
dROE_dad = jacobian(ROE,[ad,ed,id,Od,wd,Md])

ROE2 = [
eta^2*(ad-a)/a,...
1/eta*(Md-M) + eta^2*(wd - w + (Od-O)*cos(i)),...
(ed-e),...
e/eta*(Md-M),...
eta^2*(id-i),...
eta^2*(Od-O)*sin(i)
];
dROE2_dad = jacobian(ROE2,[ad,ed,id,Od,wd,Md])

ROE3 = [
eta^2*(ad-a)/a,...
eta^2*(wd - w + (Od-O)*cos(i)),...
(ed-e),...
e/eta*(Md-M),...
eta^2*(id-i),...
eta^2*(Od-O)*sin(i)
];
dROE3_dad = jacobian(ROE3,[ad,ed,id,Od,wd,Md])

syms v nu mu h r n k theta D
% GVE_VNC = [
% 0,  2*a^2*v/mu, 0;
% -r/(a*v)*sin(nu), 2/v*(e+cos(nu)),   0;
% 0,  0,  r*cos(w+nu);
% 0,  0,  r*sin(w+nu)/(h*sin(i));
% (2/v+r/(a*e*v)*cos(nu)),    2*sin(nu)/(e*v),    -r*cos(w+nu)*cot(i)/h
% eta/(e*v)*(r*cos(nu)/a),    -2/v*(eta/e+e*r/a),  0
% ]
h = n*a^2*eta;
r = a*eta^2/k;
GVE_VNC = [
0,  2*a^2*v/mu, 0;
-r/(a*v)*sin(nu), 2/v*(e+cos(nu)),   0;
0,  0,  r*cos(theta)/h;
0,  0,  r*sin(theta)/(h*sin(i));
(2/v+r/(a*e*v)*cos(nu)),    2*sin(nu)/(e*v),    -r*sin(theta)*cot(i)/h
-r*eta/(a*e*v)*cos(nu),    -2*eta/(e*v)*(1+e^2*r/(a*eta^2))*sin(nu),  0
]

Gamma = simplify(dROE_dad*GVE_VNC);
Gamma = simplify(subs(Gamma,eta, sqrt(1-e^2)));
Gamma = simplify(subs(Gamma,k, 1+e*cos(nu)));

Gamma2 = simplify(dROE2_dad*GVE_VNC);
Gamma2 = simplify(subs(Gamma2,eta, sqrt(1-e^2)));
Gamma2 = simplify(subs(Gamma2,k, 1+e*cos(nu)));
Gamma2 = simplify(subs(Gamma2,v,1/eta*n*a*D));
Gamma2 = simplify(subs(Gamma2,e^2-1,-eta^2));
Gamma2 = simplify(subs(Gamma2,a/mu,1/(a^2*n^2)))

Gamma3 = simplify(dROE3_dad*GVE_VNC);
Gamma3 = simplify(subs(Gamma3,eta, sqrt(1-e^2)));
Gamma3 = simplify(subs(Gamma3,k, 1+e*cos(nu)));
Gamma3 = simplify(subs(Gamma3,v,1/eta*n*a*D));
Gamma3 = simplify(subs(Gamma3,e^2-1,-eta^2));
Gamma3 = simplify(subs(Gamma3,a/mu,1/(a^2*n^2)))