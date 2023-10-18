function [cartesianState_rtn, R_eci2rtn] = eci2rtn(cartesianState_eci)

r_eci = cartesianState_eci(1:3,1)/norm(cartesianState_eci(1:3,1));
v_eci = cartesianState_eci(4:6,1)/norm(cartesianState_eci(4:6,1));

R = r_eci / norm(r_eci);
N = cross(r_eci,v_eci) / norm(cross(r_eci,v_eci));
T = cross(N,R) / norm(cross(N,R));

X = [1;0;0];
Y = [0;1;0];
Z = [0;0;1];

R_eci2rtn = [
    dot(R,X), dot(R,Y), dot(R,Z)
    dot(T,X), dot(T,Y), dot(T,Z)
    dot(N,X), dot(N,Y), dot(N,Z)
];
cartesianState_rtn = zeros(6,1);
cartesianState_rtn(1:3,1) = R_eci2rtn*cartesianState_eci(1:3,1);
cartesianState_rtn(4:6,1) = R_eci2rtn*cartesianState_eci(4:6,1);

end