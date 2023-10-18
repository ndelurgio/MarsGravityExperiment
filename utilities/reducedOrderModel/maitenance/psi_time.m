function [t,rate_sign] = psi_time(OE,EROE,psi_min,psi_max,cb)
    a = OE(1);
    e = OE(2);
    i = OE(3);
    J2 = cb.J2;
    r = cb.radius_m;
    mu = cb.gravitationalParameter_m3_s2;
    eta = sqrt(1-e^2);
    k = 3/4*J2*r^2*sqrt(mu)/(a^(7/2)*eta^4);
    wdot = k*(5*cos(i)^2-1);
    rate_sign = sign(wdot);
    t_high = 5*(psi_max-psi_min)/abs(wdot);
    t_low = 0;
    tol = 1;
    while abs(t_high-t_low) > tol
        c = (t_high+t_low)/2;
        STM_low = computeEccentricROE_STM(OE,cb.J2,cb.radius_m,cb.gravitationalParameter_m3_s2,t_low);
        STM_mid = computeEccentricROE_STM(OE,cb.J2,cb.radius_m,cb.gravitationalParameter_m3_s2,c);
        if sign(f(STM_low,EROE,psi_min,psi_max,wdot)) ~= sign(f(STM_mid,EROE,psi_min,psi_max,wdot))
            t_high = c;
        else
            t_low = c;
        end
    end
    t = (t_high+t_low)/2;
    % Debug
    % STM = computeEccentricROE_STM(OE,cb.J2,cb.radius_m,cb.gravitationalParameter_m3_s2,t);
    % disp(wrapTo2Pi(atan2(STM(4,:)*EROE, STM(3,:)*EROE)))
end

function y = f(STM,EROE,psi_min,psi_max,wdot)
    if sign(wdot) == 1
        y = wrapTo2Pi(atan2(STM(4,:)*EROE, STM(3,:)*EROE)) - psi_max;
    else
        y = wrapTo2Pi(atan2(STM(4,:)*EROE, STM(3,:)*EROE)) - psi_min;
    end
    
end