function accelSRP_J2000_m_s2 = srp(cartesianState, Bsrp, p_sr, sunPosition, Re, AU)
% Compute the solar radiation pressure exerted on the spacecraft
% We assume a constant area regardless of orientation w.r.t. Sun and we
% assume that the rays are parallel to the Earth

r_sat_sun = sunPosition - cartesianState(1:3,1);
r_sat_sunx = r_sat_sun(1);
r_sat_suny = r_sat_sun(2);
r_sat_sunz = r_sat_sun(3);
relative_r = norm(r_sat_sun);

accelSRP_J2000_m_s2 = zeros(3,1);

% Calculate the eclipse condition
eclipseAngle = acos(dot(-sunPosition, cartesianState(1:3,1)) / (norm(sunPosition) * norm(cartesianState(1:3,1))));
eclipseCondition = norm(cartesianState) * sin(eclipseAngle) < Re;

if not(eclipseCondition)
    SRPfactor = -Bsrp * p_sr * (AU / relative_r)^2 / relative_r;
    accelSRP_J2000_m_s2(1, 1) = SRPfactor * r_sat_sunx;
    accelSRP_J2000_m_s2(2, 1) = SRPfactor * r_sat_suny;
    accelSRP_J2000_m_s2(3, 1) = SRPfactor * r_sat_sunz;
end

end
