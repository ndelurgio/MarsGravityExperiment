function time = getManeuverTime(M_maneuver,M_curr, n)

% M_curr = nu2M(nu_curr, e);
% M_maneuver = nu2M(nu_maneuver, e);
if M_maneuver < M_curr
    throw("Error: maneuer location behind current location")
end
time = (M_maneuver - M_curr) / n;

end

