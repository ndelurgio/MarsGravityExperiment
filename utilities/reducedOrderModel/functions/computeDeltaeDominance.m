function [nu, dv_min] = computeDeltaeDominance(Delta_dex,Delta_dey, e, a, mu)
% Inputs:   Δδex, Δδey
%           OE 6x1 = [ a, e, i, Ω, ω, M ]
% Outputs:  True Anomaly Locations of the Maneuver (nu1, nu2), delta-v minimum
%
% This function assumes the spacecraft only uses tangential maneuvers.

n = meanMotion(mu,a);

% Find disconnected region
nu_dis = pi + acos(e);
nu_rec = pi - acos(e);

nu = [];
eta = sqrt(1-e^2);
if Delta_dex == 0 % zero dex special case
    nu = [acos((eta-1)/e)];
    if nu(1) < 0
        nu(1) = nu(1) + 2*pi;
    end
    nu = [nu, 2*pi-nu(1)];
    Delta_dey_max = 1/(n*a) * eta/e * sin(nu(1)) * (2+e*cos(nu(1)))/(1+e*cos(nu(1)));
    dv_min = abs(Delta_dey/Delta_dey_max);
elseif Delta_dey == 0 % zero dey special case
    nu = [0.0];
    if nu(1) < 0
        nu(1) = nu(1) + 2*pi;
    end
    Delta_dex_max = 1/(n*a) * eta*(e+cos(nu(1))*(2+e*cos(nu(1))))/(1+e*cos(nu(1)));
    dv_min = abs(Delta_dex/Delta_dex_max);
else
    % Implement Chernick closed-form tangential solution
    f = e*Delta_dey/Delta_dex - e^2*Delta_dey/Delta_dex;
    g = Delta_dey/Delta_dex*e^2 + Delta_dey/Delta_dex*e;
    g1 = 27*f^2*(e+2)^4 + 27*g^2*(e-2)^4 - 192*e^2 + 48*e^4 -4*e^6 + ...
        256*f^3*g^3 - f^2*g^2*(192*e^2-768) - 6*f*g*(e^2-4)^2 + 256;
    g2 = f^2*(8*e+16) - 12*e + 6*e^2 - e^3 + 8;
    g3 = 256*f^3*g - 96*e - f^2*(64*e^2-256) + 72*e^2 - 24*e^3 + 3*e^4 + 48;
    g4 = 36*f - 36*g + 36*e*f + 36*e*g + 9*e^2*f - 9*e^2*g + sqrt(3)*f^3*sqrt(g1/f^6);
    g5 = g4/f^3;
    g6 = 2^(2/3) * 3^(4/3) * g5^(1/3) * (e-2)^2;
    g7 = 2^(1/3) * 3^(2/3) * g5^(2/3) - 24*g/f + 6*(e-2)*(e+2)/f^2 + g6/(4*f^2);
    g8 = 2^(2/3) * 3^(1/3) * sqrt(g7);
    g9 = 3*sqrt(2*g7)*g3;
    g10 = g6*sqrt(g7)/(sqrt(2)*f^2);
    g11 = 12*g5^(1/6)*g7^(1/4);
    g12 = g9/(32*f^4) - 2^(5/6) * 3^(2/3) * g5^(2/3) * sqrt(g7);
    g13 = 3*sqrt(6)*sqrt(3*g4/f^3)*g2/(2*f^3);
    g14 = 9*sqrt(2)*(e-2)^4*sqrt(g7)/(32*f^4);
    g15 = g12 - g14 + g10;
    
    % Four solutions
    sol = zeros(4,1);
    sol(1) = -2*atan( -(e-2)/(4*f) + g8/(12*g5^(1/6)) + 2^(5/12)*3^(1/3)*sqrt(g15+g13)/g11 );
    sol(2) =  2*atan(  (e-2)/(4*f) - g8/(12*g5^(1/6)) + 2^(5/12)*3^(1/3)*sqrt(g15+g13)/g11 );
    sol(3) =  2*atan(  (e-2)/(4*f) + g8/(12*g5^(1/6)) - 2^(5/12)*3^(1/3)*sqrt(g15-g13)/g11 );
    sol(4) =  2*atan(  (e-2)/(4*f) + g8/(12*g5^(1/6)) + 2^(5/12)*3^(1/3)*sqrt(g15-g13)/g11 );
    
    for i = 1:4
        % Find the real solutions
        if isreal(sol(i))
            nui = sol(i);
            if nui < 0
                nui = nui + 2*pi;
            end
            nu = [nu, nui];
            % Only compute min delta-v if not inside disconnected region
            if ~(nui > nu_dis || nui < nu_rec)
                Delta_de_max = 1/(n*a) * sqrt( (eta*(e+cos(nui)*(2+e*cos(nui)))/(1+e*cos(nui)))^2 + (eta/e * sin(nui) * (2+e*cos(nui))/(1+e*cos(nui)))^2 );
                dv_min = sqrt(Delta_dex^2 + Delta_dey^2)/Delta_de_max;
            end
        end
    end
end
% Verify that there is at least one solution. Should never hit this
% exception.
if isempty(nu)
    throw("Error: No solutions for nu found. Shouldn't Happen?")
end
end
