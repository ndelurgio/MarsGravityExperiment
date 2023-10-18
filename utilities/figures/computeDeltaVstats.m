dv_sim = vecnorm(telem.("DeltaV_cmd"),2,2);
dv_sim = dv_sim(1:find(time==t_duration));
dv_analytical = magnitudes(1:end-1);

dv_cum_error = abs(sum(dv_sim) - sum(dv_analytical));
dv_cum_error_pct = dv_cum_error/sum(dv_sim);

times_sim = time(dv_sim > 0.01);
dv_sim = dv_sim(dv_sim > 0.01);


dv_sim_combined = [];
times_sim_combined = [];
cnt = 1;
for i = 1:length(flags)-1
    disp(cnt)
    if flags(i) == "psi" || flags(i) == "dlam" || flags(i) == "de"
        dv_sim_combined = [dv_sim_combined, sum(dv_sim(cnt:cnt+2))];
        times_sim_combined = [times_sim_combined, times_sim(cnt)];
        cnt = cnt + 3;
    else
        dv_sim_combined = [dv_sim_combined, dv_sim(cnt)];
        times_sim_combined = [times_sim_combined, times_sim(cnt)];
        cnt = cnt + 1;
    end
end

dv_av_err = sum(abs(dv_sim_combined-dv_analytical))/length(dv_analytical);
dv_std_error = std(abs(dv_sim_combined-dv_analytical));
dv_av_err_pct = dv_av_err / mean(dv_analytical);
dv_std_error_pct = dv_std_error / mean(dv_analytical);

time_errors = abs(times_sim_combined-times(1:end-1))/3600;
mean_time_errors = mean(time_errors);
mean_time_errors_pct =  mean_time_errors / mean(times(1:end-1)/3600);
std_time_errors = std(time_errors);
std_time_errors_pct = std_time_errors / mean(times(1:end-1)/3600);

