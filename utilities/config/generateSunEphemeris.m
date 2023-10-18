function [sunState,time] = generateSunEphemeris(t_epoch,t_final,time_step)

% CREATE SUN EPHEMERIS USING SPICE (Kernals:
% https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/aa_summaries.txt)
cspice_furnsh('kernals/de432s.bsp')
cspice_furnsh('kernals/naif0012.tls')

frame = 'ECLIPJ2000';
abcorr = 'NONE';
t_epoch = convertTo(t_epoch,'epochtime', 'Epoch','2000-01-01');
t_final = convertTo(t_final,'epochtime', 'Epoch','2000-01-01');
time = double(t_epoch):time_step:double(t_final);
[sunState,~] = cspice_spkezr('SUN',time,frame,abcorr,'MARS BARYCENTER');
sunState = sunState*1000;
time = double(time - double(t_epoch));
end

