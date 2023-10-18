function [dv_out, command_complete, command_bool, cmd_idx_out] = command(M_cmd,dv_cmd,OE, new_cmd, EROE, mu)
persistent M_prev cmd_idx command_complete_prev new_cmd_prev
if isempty(cmd_idx) || isempty(M_prev) || isempty(command_complete_prev)
    M_prev = 2*pi;
    cmd_idx = 4;
    command_complete_prev = true;
    new_cmd_prev = 0;
end
if new_cmd > 0.5 && new_cmd_prev < 0.5
    cmd_idx = 1;
end
M_curr = OE(6);
% dv_out = zeros(3,1);
if cmd_idx <= length(M_cmd) && M_prev < mod(M_cmd(cmd_idx,1),2*pi) && M_curr > mod(M_cmd(cmd_idx,1),2*pi)
    % dv_out(1:3,1) = dv_cmd(cmd_idx,:)';
    dv_out = [dv_cmd(cmd_idx,1); dv_cmd(cmd_idx,2); dv_cmd(cmd_idx,3)];
    % dv_out = dv_cmd(cmd_idx,2);
    % dv_out = dv_cmd(cmd_idx,3);
    cmd_idx = cmd_idx + 1;
elseif command_complete_prev && abs(EROE(1)) > 0.05/OE(1) && abs(EROE(1)) < 2/OE(1) && OE(6) < 5/3*pi && OE(6) > pi/3
    Gamma = getEROEControlMatrix(OE,mu);
    dv_out = [0; -EROE(1)/Gamma(1,2)/2; 0];
    % dv_out(1,1) = 0/2;
    % dv_out(2,1) = -EROE(1)/Gamma(1,2)/2;
    % dv_out(3,1) = 0/2;
else
    dv_out = zeros(3,1);
end
command_complete = false;
if cmd_idx == 4
    command_complete = true;
end
M_prev = M_curr;
command_complete_prev = command_complete;
if command_complete == true
    command_bool = 1;
else
    command_bool = 0;
end
new_cmd_prev = new_cmd;
cmd_idx_out = cmd_idx;
end

