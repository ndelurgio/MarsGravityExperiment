function [t,sign_de] = de_time(OE,EROE,de_min,de_max,cb)
    t_high = seconds(years(1));
    t_low = 1000;
    tol = 1;
    sign_de = 0;
    while abs(t_high-t_low) > tol
        c = (t_high+t_low)/2;
        STM_low = computeEccentricROE_STM(OE,cb.J2,cb.radius_m,cb.gravitationalParameter_m3_s2,t_low);
        STM_mid = computeEccentricROE_STM(OE,cb.J2,cb.radius_m,cb.gravitationalParameter_m3_s2,c);
        if sign(f(STM_low,EROE,de_max)) ~= sign(f(STM_mid,EROE,de_max))
            t_high = c;
            sign_de = 1;
        elseif sign(f(STM_low,EROE,de_min)) ~= sign(f(STM_mid,EROE,de_min))
            t_high = c;
            sign_de = -1;
        else
            t_low = c;
        end
    end
    t = (t_high+t_low)/2;
end

function y = f(STM,EROE,de_max)
    y = norm(STM(3:4,:)*EROE) - de_max;
end