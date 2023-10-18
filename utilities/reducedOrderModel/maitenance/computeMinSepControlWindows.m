function dr_min = computeMinSepControlWindows(a,e,de_min,psi_min,psi_max,dix,diy_min,diy_max)
psi = [psi_min,psi_max];
diy = [diy_min,diy_max];
dr_min = a;
for i = 1:length(psi)
    for j = 1:length(diy)
        dr_curr = minSepRN(a,[de_min*cos(psi(i)),de_min*sin(psi(i))],[dix,diy(j)],1+e);
        if dr_curr < dr_min
            dr_min = dr_curr;
        end
    end
end
end

