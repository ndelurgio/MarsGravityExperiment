function ROE_control = guidance2controlROE(ROE_guidance,OE)
% Inputs:   Guidance ROE 6x1 = [ δa, δλ, δex, δey, δix, δiy ]
%           OE 6x1 = [ a, e, i, Ω, ω, M ]
% Outputs:  Control ROE 6x1 = [ δa, δλ, δex, δey, δix, δiy ]
e = OE(2);
w = OE(5);
ex = e*cos(w);
ey = e*sin(w);
eta = sqrt(1-e^2);

guidance2control = [
    1/eta^2,    0,          0,                  0,                  0,          0;
    0,          1/eta,      -ey/eta,            ex/eta,             0,          0;
    0,          0,          cos(w),             sin(w),             0,          0;
    0,          1/eta^2,    -sin(w)/(e*eta^2),  cos(w)/(e*eta^2),   0,          0;
    0,          0,          0,                  0,                  1/eta^2,    0;  
    0,          0,          0,                  0,                  0,          1/eta^2
];

ROE_control = guidance2control*ROE_guidance;

end

