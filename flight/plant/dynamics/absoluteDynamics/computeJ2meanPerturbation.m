function OEdot = computeJ2meanPerturbation(OE,gravitationalParameter_m3_s2,J2,radius_m)

a = OE(1);
e = OE(2);
i = OE(3);
Om = OE(4);
w = OE(5);
M = OE(6);

eta = sqrt(1-e^2);
kappa = 3/4 * J2*radius_m^2*sqrt(gravitationalParameter_m3_s2) / (a^(7/2)*eta^4);

OEdot = kappa*[
    0;
    0;
    0;
    -2*cos(i);
    5*cos(i)^2-1;
    eta*(3*cos(i)^2-1);
];
end