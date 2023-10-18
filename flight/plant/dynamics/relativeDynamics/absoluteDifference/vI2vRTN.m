function relativeState_rtn = vI2vRTN(relativeState_I, theta0_dot, R_eci2rtn)
% Function takes as input the relative state with respect to the intertial
% frame and convert it to the RTN frame

% Transform position and velocity into RTN coordinates
relativeState_rtn = zeros(6,1);
relativeState_rtn(1:3,1) = R_eci2rtn * relativeState_I(1:3, 1);
relativeState_rtn(4:6,1) = R_eci2rtn * relativeState_I(4:6, 1);
% Transform velocity
w_I2rtn = [0; 0; -theta0_dot];
relativeState_rtn(4:6,1) = relativeState_rtn(4:6,1) + cross(w_I2rtn, relativeState_rtn(1:3,1));

end
