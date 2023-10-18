function H = getMatrixH(x,sunPos,Bsrp_c,Bsrp_d,AU,p_sr)
% Computation of the sensitivity matrix H

% Sun
r_sunx = sunPos(1,1);
r_suny = sunPos(2,1);
r_sunz = sunPos(3,1);

% Chief
rx_c = x(1, 1);
ry_c = x(2, 1);
rz_c = x(3, 1);
r_c = sqrt(rx_c^2+ry_c^2+rz_c^2);
rssx_c = r_sunx - rx_c;
rssy_c = r_suny - ry_c;
rssz_c = r_sunz - rz_c;
rss_c = sqrt(rssx_c^2+rssy_c^2+rssz_c^2);

K_c = -Bsrp_c*p_sr*AU^2;
L_c = [-(K_c*(rss_c^2 - 3*rssx_c^2))/(rss_c^2)^(5/2),         (3*K_c*rssx_c*rssy_c)/(rss_c^2)^(5/2),         (3*K_c*rssx_c*rssz_c)/(rss_c^2)^(5/2);
        (3*K_c*rssx_c*rssy_c)/(rss_c^2)^(5/2), -(K_c*(rss_c^2 - 3*rssy_c^2))/(rss_c^2)^(5/2),         (3*K_c*rssy_c*rssz_c)/(rss_c^2)^(5/2);
        (3*K_c*rssx_c*rssz_c)/(rss_c^2)^(5/2),         (3*K_c*rssy_c*rssz_c)/(rss_c^2)^(5/2), -(K_c*(rss_c^2 - 3*rssz_c^2))/(rss_c^2)^(5/2);
];

% Deputy
rx_d = x(7, 1);
ry_d = x(8, 1);
rz_d = x(9, 1);
r_d = sqrt(rx_d^2+ry_d^2+rz_d^2);
rssx_d = r_sunx - rx_d;
rssy_d = r_suny - ry_d;
rssz_d = r_sunz - rz_d;
rss_d = sqrt(rssx_d^2+rssy_d^2+rssz_d^2);

K_d = -Bsrp_d*p_sr*AU^2;
L_d = [-(K_d*(rss_d^2 - 3*rssx_d^2))/(rss_d^2)^(5/2),         (3*K_d*rssx_d*rssy_d)/(rss_d^2)^(5/2),         (3*K_d*rssx_d*rssz_d)/(rss_d^2)^(5/2);
        (3*K_d*rssx_d*rssy_d)/(rss_d^2)^(5/2), -(K_d*(rss_d^2 - 3*rssy_d^2))/(rss_d^2)^(5/2),         (3*K_d*rssy_d*rssz_d)/(rss_d^2)^(5/2);
        (3*K_d*rssx_d*rssz_d)/(rss_d^2)^(5/2),         (3*K_d*rssy_d*rssz_d)/(rss_d^2)^(5/2), -(K_d*(rss_d^2 - 3*rssz_d^2))/(rss_d^2)^(5/2);
];

H = [
    eye(6),          zeros(6, 6),       eye(6),      zeros(6, 6);
    L_c, zeros(3,3), zeros(3, 6),       zeros(3, 6), eye(3), zeros(3,3);
    zeros(6, 6),     eye(6),            eye(6),      zeros(6, 6);
    zeros(3, 6),     L_d, zeros(3,3),   zeros(3, 6), zeros(3, 3), eye(3);
];

end
