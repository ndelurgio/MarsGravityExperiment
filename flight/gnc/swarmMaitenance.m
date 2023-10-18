function [M,dv,cmd,DeltaEROE] = swarmMaitenance(EROE,OE,mu,controlWindows, command_complete, dt)
persistent curr_cmd M_cmd dv_cmd t curr_cmd_prev
if isempty(curr_cmd) || isempty(M_cmd) || isempty(dv_cmd)
    curr_cmd = false;
    curr_cmd_prev = false;
    M_cmd = zeros(1,3);
    dv_cmd = zeros(3,3);
    t = 0;
end
de_min=controlWindows.de_min;
de_max=controlWindows.de_max;
% psi_nom=controlWindows.psi_nom;
psi_min=controlWindows.psi_min;
psi_max=controlWindows.psi_max;
diy_max=controlWindows.diy_max;
diy_min=controlWindows.diy_min;
dlam_min=controlWindows.dlam_min;
dlam_max=controlWindows.dlam_max;

da = EROE(1);
dlam = EROE(2);
dex = EROE(3);
dey = EROE(4);
dix = EROE(5);
diy = EROE(6);
DeltaEROE = zeros(6,1);
t = t + dt;
if t > 600
    if command_complete
        curr_cmd = false;
    end
    if curr_cmd == false && curr_cmd_prev == false
        if norm([dex,dey]) > de_max || norm([dex,dey]) < de_min || wrapTo2Pi(atan2(dey,dex)) < psi_min
            DeltaEROE(1:6,1) = [0-da;0;(de_min+de_max)/2*cos(psi_max)-dex;(de_min+de_max)/2*sin(psi_max)-dey;0;0];
            curr_cmd = true;
        elseif dlam < dlam_min*1.01
            DeltaEROE(1:6,1) = [0-da;dlam_max-dlam;0;0;0;0];
            curr_cmd = true;
        elseif dlam > dlam_max*1.01
            DeltaEROE(1:6,1) = [0-da;dlam_min-dlam;0;0;0;0];
            curr_cmd = true;
        elseif diy < diy_min*1.01
            DeltaEROE(1:6,1) = [0;0;0;0;0-dix;diy_max-diy];
            curr_cmd = true;
        elseif diy > diy_max/1.01
            DeltaEROE(1:6,1) = [0;0;0;0;0-dix;diy_min-diy];
            curr_cmd = true;
        end
    end
    
    if curr_cmd && norm(DeltaEROE) > 0
        if norm(DeltaEROE(1:4,1)) > 0
            [~, M_cmd, dv_cmd, ~] = computeInPlaneManeuver(DeltaEROE,OE,mu);
        elseif norm(DeltaEROE(5:6,1)) > 0
            [~, M_cmd, dv_cmd, ~] = computeOutOfPlaneManeuver(DeltaEROE,OE,mu);
        end
    end
end
M = zeros(3,1);
dv = zeros(3,3);
M(1:3,1) = M_cmd';
dv(1:3,1:3) = dv_cmd;
if curr_cmd == true
    cmd = 1;
else
    cmd = 0;
end
curr_cmd_prev = curr_cmd;
% cmd = double(curr_cmd);

end

