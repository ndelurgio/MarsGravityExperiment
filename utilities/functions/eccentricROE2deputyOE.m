function deputyOE = eccentricROE2deputyOE(ROE,chiefOE)

a = chiefOE(1);
e = chiefOE(2);
i = chiefOE(3);
O = chiefOE(4);
w = chiefOE(5);
M = chiefOE(6);

eta = sqrt(1-e^2);
b = [eta^2;
    M/eta + eta^2*(w+O*cos(i));
    e*cos(w) + e*sin(w)*M/eta;
    e*sin(w) - e*cos(w)*M/eta;
    eta^2*i;
    eta^2*O*sin(i)];

b = ROE + b;
A = [
    eta^2/a, 0, 0, 0, 0, 0;
    0, 0, 0, eta^2*cos(i), eta^2, 1/eta;
    0, cos(w), 0, 0, 0, e*sin(w)/eta;
    0, sin(w), 0, 0, 0, -e*cos(w)/eta;
    0, 0, eta^2, 0, 0, 0;
    0, 0, 0, eta^2*sin(i), 0, 0
];

deputyOE = inv(A)*b;
end

