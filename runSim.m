clear
close all;

default;
% out = sim('dynamics_mean');
out = sim('simulation');

time = out.tout;
telem = extractTimetable(out.logsout);

% Save the updated timetable as a .dat file
% writetimetable(telem, 'results/PS2/output_HW2.dat', 'Delimiter', '\t', 'FileType', 'text');
