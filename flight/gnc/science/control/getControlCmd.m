function u = getControlCmd(u_data,time_data,t)

if t > max(time_data)
    u = [0;0;0];
else
    ux = interp1(time_data,u_data(1,:),t);
    uy = interp1(time_data,u_data(2,:),t);
    uz = interp1(time_data,u_data(3,:),t);
    u = [ux; uy; uz];
end

end