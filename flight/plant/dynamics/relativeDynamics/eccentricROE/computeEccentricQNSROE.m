function eccentricQNSROE = computeEccentricQNSROE(chiefOE, deputyOE)

ac = chiefOE(1);
ec = chiefOE(2);
ic = chiefOE(3);
Oc = chiefOE(4);
wc = chiefOE(5);
Mc = chiefOE(6);
ecx = ec*cos(wc);
ecy = ec*sin(wc);
uc = wc+Mc;

ad = deputyOE(1);
ed = deputyOE(2);
id = deputyOE(3);
Od = deputyOE(4);
wd = deputyOE(5);
Md = deputyOE(6);
edx = ed*cos(wd);
edy = ed*sin(wd);
ud = wd+Md;

eta = sqrt(1-ec^2);
eccentricQNSROE = [
    eta^2*(ad-ac)/ac;
    (1+1/(eta^2+eta))*(ecy*edx-ecx*edy) + 1/eta*(ud-uc) + eta^2*(Od-Oc)*cos(ic);
    edx*(1+ecy^2/(eta^2+eta)) - ecx + 1/eta*ecy*(ud-uc-edy*ecx/(eta+1));
    edy*(1+ecx^2/(eta^2+eta)) - ecy - 1/eta*ecx*(ud-uc+edx*ecy/(eta+1));
    eta^2*(id-ic);
    eta^2*(Od-Oc)*sin(ic)
];

end

