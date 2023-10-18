runROMmaitenance;
plot(time/86400,cumsum(vecnorm(telem.("DeltaV_cmd"),2,2)),'Linewidth',2);
xlim([0,t_duration/86400])
legend(["Closed-Form Model","Numerical Simulation"],"Location","northwest")
saveas(h,figurepath + "DeltaV_comparison.eps",'epsc')
