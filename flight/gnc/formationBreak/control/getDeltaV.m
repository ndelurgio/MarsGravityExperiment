function [DeltaV,t] = getDeltaV(ROE,location,OE,mu,t_prev)
if norm(ROE) == 0
    DeltaV = [0,0,0];
    t = t_prev;
else
    % if isempty(location)
    %     DeltaV = [0,0,0];
    % else
    location = location(1);
    e = OE(2);
    M0 = OE(6);
    Mf = nu2M(location,e);
    n = meanMotion(mu,OE(1));
    t = (Mf-M0)/n;
    eta = sqrt(1-e^2);
    if ROE(1) ~= 0
        da = ROE(1);
        dvt = da*n*OE(1)/(eta*2*(1+e*cos(location)));
        DeltaV = [0,dvt,0];
    elseif norm(ROE(5:6)) > 0
        di = norm(ROE(5:6));
        dvn = di*n*OE(1)*(1+e*cos(location))/eta^3;
        DeltaV = [0,0,dvn];
    else
        DeltaV = [0,0,0];
    end
    % end
end

end

