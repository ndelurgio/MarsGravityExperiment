function STM = getEROESTM(OE, mu, t)

a = OE(1);
e = OE(2);
e_x = OE(2) * cos(OE(5));
e_y = OE(2) * sin(OE(5));
eta = sqrt(1 - e^2);
n = meanMotion(mu, a);

STM = eye(6);
STM(2, 1) = -3/2 * n * t / eta^3;
STM(3, 1) = -3/2 * e_y * n * t / eta^3;
STM(4, 1) = 3/2 * e_x * n * t / eta^3;
end
