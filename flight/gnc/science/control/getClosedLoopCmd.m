function u = getClosedLoopCmd(OE,ROE,ROE_ref,mu)

a = OE(1);
e = OE(2);
i = OE(3);
O = OE(4);
w = OE(5);
M = OE(6);

nu = M2nu(M,e);
theta = w + nu;

pROE = ROE - ROE_ref;
P = getMatrixP(pROE,theta);
B = getMatrixB(OE,mu);
A = getMatrixA(OE,mu);
u = -pinv(B)*(A*ROE + P*(ROE-ROE_ref));

end

