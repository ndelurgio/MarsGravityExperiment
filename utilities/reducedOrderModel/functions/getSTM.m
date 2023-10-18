function STM = getSTM(dM)

STM = eye(6);
STM(2,1) = -3/2*dM;

end

