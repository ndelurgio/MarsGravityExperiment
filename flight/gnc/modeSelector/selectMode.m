function mode = selectMode(nu, scienceMode, formationBreakMode, passiveMode, formationAcquisitionMode)
% Select the correct mode based on the true anomaly (nu)
if scienceMode(1) < nu && nu < scienceMode(2)
    mode = "science";
elseif formationBreakMode(1) < nu && nu < formationBreakMode(2)
    mode = "formationBreak";
elseif nu > passiveMode(1) || nu < passiveMode(2)
    mode = "passive";
elseif formationAcquisitionMode(1) < nu && nu < formationAcquisitionMode(2)
    mode = "formationAcquisition";
else
    mode = "unknown";
end

end
