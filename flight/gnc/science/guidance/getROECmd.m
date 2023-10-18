function roe_cmd = getROECmd(roe_data,time_data,t)
time_data = [time_data; time_data(end)+1];
if t > max(time_data)
    roe_cmd = zeros(6,1);
else
    da = interp1(time_data,roe_data(1,:),t);
    dlam = interp1(time_data,roe_data(2,:),t);
    dex = interp1(time_data,roe_data(3,:),t);
    dey = interp1(time_data,roe_data(4,:),t);
    dix = interp1(time_data,roe_data(3,:),t);
    diy = interp1(time_data,roe_data(4,:),t);
    roe_cmd = [da;dlam;dex;dey;dix;diy];
end

end