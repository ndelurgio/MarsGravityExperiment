function Rx = rotx(arg)
Rx = ...
[
1, 0, 0;
0, cos(arg), -sin(arg);
0, sin(arg), cos(arg);
];
end