close all
om_m_psi = [0,pi/4,pi/2,3*pi/4,pi];
e = [0, 0.3, 0.6];
nu = 0:0.001:2*pi;
h = figure;
tiledlayout(length(om_m_psi),length(e),'TileSpacing','none');
for i = 1:length(om_m_psi)
    for j = 1:length(e)
        nexttile;
        
        if j == 1
            text(-6,0.0,['$\omega - \psi$','$=' + string(om_m_psi(i)*180/pi) + '^{\circ}$'],'Interpreter','latex','FontSize',16)
        end
        if i == 1
            title('$e = ' + string(e(j)) + '$','Interpreter','latex','FontSize',16)
        end
        hold on;
        % Lower bounds
        k = 1+e(j);
        x = [];
        y = [];
        for f = 1:length(nu)
            x = [x, -cos(om_m_psi(i)+nu(f))];
            y = [y, (1/k+1)*sin(om_m_psi(i)+nu(f))];
        end
        plot(y,x,'--')
        % Upper bounds
        k = 1-e(j);
        x = [];
        y = [];
        for f = 1:length(nu)
            x = [x, -cos(om_m_psi(i)+nu(f))];
            y = [y, (1/k+1)*sin(om_m_psi(i)+nu(f))];
        end
        plot(y,x,'--')
        % True
        x = [];
        y = [];
        for f = 1:length(nu)
            k = 1+e(j)*cos(nu(f));
            x = [x, -cos(om_m_psi(i)+nu(f))];
            y = [y, (1/k+1)*sin(om_m_psi(i)+nu(f))];
        end
        plot(y,x,'black',"Linewidth",2)
        xlim([-1/(1-e(end))-1, 1/(1-e(end))+1])
        axis equal;
        axis off;
        hold off;
    end
        
end
saveas(h,figurepath + "in_plane_geometry_example.eps",'epsc')