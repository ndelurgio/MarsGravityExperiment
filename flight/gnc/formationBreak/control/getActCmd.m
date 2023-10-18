function [actCmd,thrust_direction_out,t_out] = getActCmd(t, t_left, thrust_direction, thrust_direction_prev)

thrust_direction_out = [1;1;1];
if t_left > 0
    actCmd = 1;
    t_out = t_left;
    thrust_direction_out(1,1) = thrust_direction_prev(1);
    thrust_direction_out(2,1) = thrust_direction_prev(2);
    thrust_direction_out(3,1) = thrust_direction_prev(3);
elseif t > 0
    actCmd = 1;
    t_out = t;
    thrust_direction_out(1,1) = thrust_direction(1);
    thrust_direction_out(2,1) = thrust_direction(2);
    thrust_direction_out(3,1) = thrust_direction(3);
else
    actCmd = 0;
    t_out = 0;
    thrust_direction_out = [1;1;1];
end

end

