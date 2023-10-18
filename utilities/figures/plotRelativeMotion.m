function [] = plotRelativeMotion(time, telem, plot_type)
    % [~,maneuver_idx] = min(abs(time-3.532572227135039e+04));

    if plot_type == "solo"
        figure
        
        % set(gcf, 'position', [300, 300, 350, 500])
        
        subplot(2, 1, 1)
        hold on;
        title("Relative Motion in T-R Plane")
        plot(telem.("Deputy Relative Cartesian State RTN.positionY_RTN_m"),telem.("Deputy Relative Cartesian State RTN.positionX_RTN_m"))
        % scatter(telem.("Relative Cartesian State RTN")(1,2),telem.("Relative Cartesian State RTN")(1,1),"MarkerFaceColor","r")
        % scatter(telem.("Relative Cartesian State RTN")(maneuver_idx,2),telem.("Relative Cartesian State RTN")(maneuver_idx,1),"MarkerFaceColor","g")
        % legend("Deputy Trajectory","Start","Maneuver")
        axis equal;
        xlabel("\delta r_t [m]")
        ylabel("\delta r_r [m]")
        grid on;
        
        subplot(2, 1, 2)
        hold on;
        title("Relative Motion in N-R Plane")
        plot(telem.("Deputy Relative Cartesian State RTN.positionZ_RTN_m"),telem.("Deputy Relative Cartesian State RTN.positionX_RTN_m"))
        % scatter(telem.("Relative Cartesian State RTN")(1,3),telem.("Relative Cartesian State RTN")(1,1),"MarkerFaceColor","r")
        % scatter(telem.("Relative Cartesian State RTN")(maneuver_idx,3),telem.("Relative Cartesian State RTN")(maneuver_idx,1),"MarkerFaceColor","g")
        % legend("Deputy Trajectory","Start","Maneuver")
        % axis equal;
        xlabel("\delta r_n [m]")
        ylabel("\delta r_r [m]")
        grid on;
    else
    figure
    set(gcf,'position',[300,300,800,800])
    subplot(6,1,1)
    hold on;
    title("Relative X Position vs Time")
    % plot(time/3600,telem.("relativeState")(1:end,1),"LineWidth",1)
    plot(time/3600,telem.("Relative Cartesian State RTN")(1:end,1),"LineWidth",1)
    legend("Direct","Difference")
    xlabel("t [hr]")
    ylabel("\delta r_r [m]")
    grid on;
    
    subplot(6,1,2)
    hold on;
    title("Relative Y Position vs Time")
    % plot(time/3600,telem.("relativeState")(1:end,2),"LineWidth",1)
    plot(time/3600,telem.("Relative Cartesian State RTN")(1:end,2),"LineWidth",1)
    legend("Direct","Difference")
    xlabel("t [hr]")
    ylabel("\delta r_t [m]")
    grid on;
    
    subplot(6,1,3)
    hold on;
    title("Relative Z Position vs Time")
    % plot(time/3600,telem.("relativeState")(1:end,3),"LineWidth",1)
    plot(time/3600,telem.("Relative Cartesian State RTN")(1:end,3),"LineWidth",1)
    legend("Direct","Difference")
    xlabel("t [hr]")
    ylabel("\delta r_n [m]")
    grid on;
    
    subplot(6,1,4)
    hold on;
    title("Relative X Velocity vs Time")
    % plot(time/3600,telem.("relativeState")(1:end,4),"LineWidth",1)
    plot(time/3600,telem.("Relative Cartesian State RTN")(1:end,4),"LineWidth",1)
    legend("Direct","Difference")
    xlabel("t [hr]")
    ylabel("\delta v_r [m/s]")
    grid on;
    
    subplot(6,1,5)
    hold on;
    title("Relative Y Velocity vs Time")
    % plot(time/3600,telem.("relativeState")(1:end,5),"LineWidth",1)
    plot(time/3600,telem.("Relative Cartesian State RTN")(1:end,5),"LineWidth",1)
    legend("Direct","Difference")
    xlabel("t [hr]")
    ylabel("\delta v_t [m/s]")
    grid on;
    
    subplot(6,1,6)
    hold on;
    title("Relative Z Velocity vs Time")
    % plot(time/3600,telem.("relativeState")(1:end,6),"LineWidth",1)
    plot(time/3600,telem.("Relative Cartesian State RTN")(1:end,6),"LineWidth",1)
    legend("Direct","Difference")
    xlabel("t [hr]")
    ylabel("\delta v_n [m/s]")
    grid on;
    end
end