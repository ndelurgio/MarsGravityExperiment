function [ r_eci , v_eci ] = oe2eci ( a , e , i , Om , w , v , mu)
% OE2ECI Converts orbital elements to r , v in ECI frame
%
% Notes :
% 1) This function assumes the central body to be Earth
% 2) In cases of equatorial and / or circular orbits , it is assumed
% that valid orbital elements are provided as inputs ( ie . there is
% no back - end validation )
%
% Inputs :
% a - semi - major axis of orbit [ m ]
% e - eccentricity of orbit
% i - inclination of orbit [ rad ]
% Om - right ascension of the ascending node [ rad ]
% w - argument of periapsis [ rad ]
% v - true anomaly [ rad ]
%
% Outputs :
% r_eci - 3 x1 vector of radius in ECI frame [ km ]
% v_eci - 3 x1 vector of velocity in ECI frame [ km / s ]
% mu = 3.986004419e14 ; % m ^3/ s ^2
n = sqrt(mu / a^3) ; % rad / s
E = nu2E(v, e ) ; % rad
% Compute radius and velocity of orbit in perifocal coordinates
rPeri = [ a *( cos( E ) - e ) ;
a * sqrt(1 - e^2) * sin( E ) ;
0];
vPeriComp = [ -sin( E ) ;
sqrt(1 - e^2) * cos( E ) ;
0];
vPeri = ( a * n ) /(1 - e * cos( E ) ) * vPeriComp ;
% Develop rotation matrix depending on orbit shape / inclination
if i == 0 && e ~= 0 % Equatorial + elliptical
rotPeri2ECI = rotationz ( w ) ;
elseif e == 0 && i ~= 0 % Circular + inclined
rotPeri2ECI = rotationz ( Om ) * rotationx ( i ) ;
elseif i == 0 && e == 0 % Equatorial + circular
rotPeri2ECI = 1;
else % Elliptical + inclined
rotPeri2ECI = rotationz ( Om ) * rotationx ( i ) * rotationz ( w ) ;
end
% Rotate vectors into ECI frame
r_eci = rotPeri2ECI * rPeri ;
v_eci = rotPeri2ECI * vPeri ;
end