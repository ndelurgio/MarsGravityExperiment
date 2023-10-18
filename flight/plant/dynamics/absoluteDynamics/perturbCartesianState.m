function [postCartesianState,maneuverFlag] = perturbCartesianState(preCartesianState,deltaV)
postCartesianState = preCartesianState;
if norm(deltaV) == 0
    maneuverFlag = 0;
else
    postCartesianState(4:6) = postCartesianState(4:6) + deltaV;
    maneuverFlag = 1;
end

end

