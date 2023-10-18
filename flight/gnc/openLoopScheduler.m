function dv_out = openLoopScheduler(M_cmd,dv_cmd,OE)
persistent cmd_idx M_prev
if isempty(cmd_idx)
    cmd_idx = 1;
    M_prev = OE(6);
end
M_curr = OE(6);
dv_out = [0;0;0];
if cmd_idx <= length(M_cmd) && M_prev < mod(M_cmd(cmd_idx,1),2*pi) && M_curr > mod(M_cmd(cmd_idx,1),2*pi)
    dv_out = dv_cmd(cmd_idx,1:3)';
    cmd_idx = cmd_idx + 1;
end
M_prev = M_curr;


end

