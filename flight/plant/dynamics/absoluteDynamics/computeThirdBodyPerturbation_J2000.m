function accelThirdBodyJ2000_m_s2 = computeThirdBodyPerturbation_J2000(gravitationalParameter_m3_s2,thirdBodyPosition_m,spacecraftState)

% accelThirdBodyJ2000_m_s2 = -gravitationalParameter_m3_s2/norm(thirdBodyPosition_m)^3*thirdBodyPosition_m;
spacecraftPos_m = spacecraftState(1:3,1);
accelThirdBodyJ2000_m_s2 = gravitationalParameter_m3_s2*((thirdBodyPosition_m-spacecraftPos_m)/norm(thirdBodyPosition_m-spacecraftPos_m)^3 - thirdBodyPosition_m/norm(thirdBodyPosition_m)^3);


end

