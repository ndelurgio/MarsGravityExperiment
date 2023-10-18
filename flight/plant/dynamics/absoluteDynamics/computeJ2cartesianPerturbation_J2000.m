function accelJ2_J2000_mps2 = computeJ2cartesianPerturbation_J2000(cartesianState,gravitationalParameter_m3_s2,J2,radius_m)

rvec = cartesianState(1:3,1);
rx = rvec(1);
ry = rvec(2);
rz = rvec(3);
r = norm(rvec);

accelJ2_J2000_mps2 = zeros(3,1);
accelJ2_J2000_mps2(1,1) = rx*(5*rz^2/r^2-1);
accelJ2_J2000_mps2(2,1) = ry*(5*rz^2/r^2-1);
accelJ2_J2000_mps2(3,1) = rz*(5*rz^2/r^2-3);

accelJ2_J2000_mps2 = 3/2*J2*gravitationalParameter_m3_s2*radius_m^2/r^5 * accelJ2_J2000_mps2;


end