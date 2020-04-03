%% Automatic generation of plots, according the the Scenario chosen in "NumericalValues.m"

if rem(nt,floor(Nt/NumberOfFrames))==0
    
    
    FigHandle = figure(1);
    set(FigHandle,'Position', [100, 0, 1000, 600],'NumberTitle', 'off');
    set(FigHandle,'Name',['Iteration : ' num2str(nt) ' out of ' num2str(Nt) ' (' num2str(floor(100*nt/Nt)) '%)      Remaining time : ' num2str(floor(toc*(Nt-nt)/(nt-1))) ' seconds              Scenario : ' Scenario]);
    
    %% Prepare data
    
    rho_d = rho_a(:,:)./Deltax_d^3;                           % Density [kg/m3]
    vx_d  = vx_a(:,:).*(Deltax_d/Deltat_d);                   % Velocity (X-component) [m/s]
    vy_d  = vy_a(:,:).*(Deltax_d/Deltat_d);                   % Velocity (Y-component) [m/s]
    T_d   = Tmin_d + T_a(:,:).*DeltaT_d;                      % Temperature
    
    %% Choose which plots to display for a given Scenario
    
    switch Scenario
        case 'Hydrostatic'
            Plots = {'Density'};
        case {'Poiseuille','Debugging'}
            Plots = {'Density', 'ParaboleY'};
        case 'LidDriven'
            Plots = {'Velocity3D', 'Density', 'Velocity2D', 'StreamLines', 'VelocityProfileForMidX', 'VelocityProfileForMidY'};
        case 'Obstacle'
            Plots = {'Density', 'ParaboleX', 'Velocity2D', 'StreamLines'};
        case 'VonKarman'
            Plots = {'Density', 'ParaboleY', 'Velocity2D', 'StreamLines'};
        case 'HeatConduction'
            Plots = {'Velocity3D', 'Density', 'Temperature3D', 'Temperature2D'};
        case 'SideHeatedCavity'
            Plots = {'Velocity2D', 'StreamLines', 'Density', 'Temperature3D', 'Temperature2D'};
        case 'Benard'
            Plots = {'Velocity2D', 'StreamLines', 'Density', 'Temperature3D', 'Temperature2D'};
        case 'Benard2'
            Plots = {'Velocity2D', 'StreamLines', 'Density', 'Temperature3D', 'Temperature2D'};
        case 'BenardHR'
            Plots = {};         % Special case (see at the end of this file)
        case 'UserDefined1'
            Plots = {'Velocity2D', 'StreamLines', 'Density', 'Temperature3D', 'Temperature2D'};
    end
    
    %% Build a library of plots
    
    for i = 1:length(Plots)
        switch Plots{i}
            
            case 'Density'
                subplot(2,3,i);
                mesh(1:Nx,1:Ny, rho_d(:,:)');
                xlabel('x');
                ylabel('y');
                title('Density [kg/m3]');
                
            case 'Velocity3D'
                subplot(2,3,i);
                u1 = vx_d(:,:);
                v1 = vy_d(:,:);
                u21 = sqrt(u1.^2 + v1.^2);
                mesh(1:Nx,1:Ny, u21(:,:)');
                xlabel('x');
                ylabel('y');
                title('Velocity [m/s]');
                
            case 'Velocity2D'
                subplot(2,3,i);
                u1 = vx_d(:,:);
                v1 = vy_d(:,:);
                NormOfV = (u1.^2 + v1.^2).^(1/2);
                NormOfV = padarray(NormOfV,[1 1],0,'post');            % We add zero to circumvene the erosion of 'pcolor'
                pcolor(NormOfV');
                shading flat;                                           % Chose among 'shading flat'   'shading interp'   or nothing
                set(gca, 'XTick', 1:Nx,   'XTickLabel', [1:Nx]')
                set(gca, 'YTick', 1:Ny,   'YTickLabel', [1:Ny])
                xlabel('x');
                ylabel('y');
                title('Velocity [m/s]');
                colorbar, %axis equal tight;
                hold off
                
            case 'StreamLines'
                if exist('hsl'),  cla(hsl);   end
                hsl = subplot(2,3,i);
                streamslice((1:Nx)',(1:Ny)',vx_d(:,:)',vy_d(:,:)','method','cubic');
                xlim([1 Nx]); %xlim([0 Lx_d]);%
                ylim([1 Ny]);
                % hold on;                plot([0.1 0.2],[0.3 0.3],'ro');
                hold off
                xlabel('x');
                ylabel('y');
                title('Streamlines');
                
            case 'VelocityProfileForMidY'
                subplot(2,3,i);
                position_index = 1:Nx;
                x_d             = (position_index-0.5)*Deltax_d;                  % Between 0 and Lx_d
                velocity        = vy_d(position_index,floor(Ny/2));
                %Data for Re=100 from Ghia 1982
                x_Ghia  = Lx_d*[0 0.0625 0.0703 0.0781 0.0938 0.1563 0.2266 0.2344 0.5 0.8047 0.8594 0.9063 0.9453 0.9531 0.9609 0.9688 1];
                vy_Ghia = [0 0.09233 0.10091 0.10890  0.12317 0.16077 0.17507 0.17527 0.05454 -0.24533 -0.22445 -0.16914 -0.10313 -0.08864 -0.07391 -0.05906 0];
                plot(x_Ghia',vy_Ghia','ro','MarkerFaceColor','r','MarkerSize',3);
                hold on;
                plot(x_d,velocity,'b--','LineWidth',1);
                title('Velocity profile');
                hold off
                xlim([0 Lx_d]);
                xlabel('x [m]');
                ylabel('v_y for y=mid [m/s]');
                
            case 'VelocityProfileForMidX'
                subplot(2,3,i);
                position_index = 1:Ny;
                y_d             = (position_index-0.5)*Deltay_d;                  % Between 0 and Ly_d
                velocity        = vx_d(floor(Nx/2),position_index);
                %Data for Re=100 from Ghia 1982
                y_Ghia  = Ly_d*[0 0.0547 0.0625 0.0703 0.1016 0.1719 0.2813 0.4531 0.5 0.6172 0.7344 0.8516 0.9531 0.9609 0.9688 0.9766 1];
                vx_Ghia = [0 -0.03717 -0.04192 -0.04775 -0.06434 -0.10150 -0.15662 -0.21690 -0.20581 -0.13641 0.00332 0.23151 0.68717 0.73722 0.78871 0.84123 1];
                plot(y_Ghia',vx_Ghia','ro','MarkerFaceColor','r','MarkerSize',3);
                hold on;
                plot(y_d,velocity,'b--','LineWidth',1);
                title('Velocity profile ');
                hold off
                xlim([0 Ly_d]);
                ylim([-1 1].*abs(vwallmax_d));
                xlabel('y [m]');
                ylabel('v_x for x=mid [m/s]');
                
            case 'ParaboleY'
                subplot(2,3,i);
                position_index     = 1:Nx;
                x_d                = (position_index-0.5)*Deltax_d;                  % Between 0 and Lx_d
                velocity           = vy_d(position_index,floor(Ny/2));
                plot(x_d,velocity,'o');
                hold on
                velocity_theo_max  = vtypic_d*sign(gy_d);
                x_d1               = linspace(0,Lx_d,20);
                velocity_theo      = velocity_theo_max.*(1 - ((x_d1-Lx_d/2)./(Lx_d/2)).^2);
                plot(x_d1,velocity_theo,'-k');
                title('Velocity profile');
                hold off
                xlim([0 Lx_d]);
                xlabel('x [m]');
                ylabel('v_y for y=mid [m/s]');
                
            case 'ParaboleX'
                subplot(2,3,i);
                position_index     = 1:Ny;
                y_d                = (position_index-0.5)*Deltay_d;                  % Between 0 and Ly_d
                velocity           = vx_d(floor(Nx/2),position_index);
                plot(velocity,y_d,'o');
                hold on
                velocity_theo_max  = vtypic_d*sign(gx_d);
                y_d1               = linspace(0,Ly_d,20);
                velocity_theo      = velocity_theo_max.*(1 - ((y_d1-Ly_d/2)./(Ly_d/2)).^2);
                plot(velocity_theo,y_d1,'-k');
                title('Velocity profile');
                hold off
                ylim([0 Ly_d]);
                ylabel('y [m]');
                xlabel('v_x for x=mid [m/s]');
                
            case 'Temperature3D'
                subplot(2,3,i);
                mesh(1:Nx,1:Ny, T_d(:,:)');
                xlabel('x');
                ylabel('y');
                title('Temperature [K]');
                
            case 'Temperature2D'
                subplot(2,3,i);
                [x1,y1] = meshgrid(1:Nx,1:Ny);
                contourf(x1',y1',T_a,7);
                xlabel('x');
                ylabel('y');
                title('Iso-temperature [K]');
                colormap(jet);
                
            case 'Velocity2DBis'
                subplot(2,3,i);
                [x1,y1] = meshgrid(1:Nx,1:Ny);
                u1 = vx_d(:,:);
                v1 = vy_d(:,:);
                u21 = sqrt(u1.^2 + v1.^2);
                contourf(x1',y1',u21,7);
                xlabel('x');
                ylabel('y');
                title('Iso-velocity [m/s]');
                
            case 'Temperature2DSpecialHR'   % to be checked
                subplot(2,3,i);
                [x1,y1] = meshgrid(1:Nx,1:Ny);
                hh1=contourf(x1',y1',T_a,7);
                xlabel('x');
                ylabel('y');
                title('Iso-temperature [K]');
                h = colorbar;
                caxis([0 1]);
                colormap(jet);
                %saveas(gcf,['Images/Test-' num2str(nt) '.jpg']);
                
        end
    end
    
    % Special case for High-Resolution Benard
    
    if strcmp(Scenario,'BenardHR')
        
        FigHandle2 = figure(2);
        set(FigHandle2,'Position', [0, 400, 1400, 280]);
        set(FigHandle2,'NumberTitle', 'off');
        set(FigHandle2,'Name',['Iteration : ' num2str(nt) ' out of ' num2str(Nt) ' (' num2str(floor(100*nt/Nt)) '%)      Remaining time : ' num2str(floor(toc*(Nt-nt)/(nt-1))) ' seconds              Scenario : ' Scenario]);
        
        [x1,y1] = meshgrid(1:Nx,1:Ny);
        hh1=contourf(x1',y1',T_a,7);
        xlabel('x');
        ylabel('y');
        title('Iso-temperature');
        h = colorbar;
        caxis([0 1]);
        colormap(jet);
        
        StopButton=uicontrol('Parent',FigHandle2,'Style','pushbutton','String','STOP and DELETE','Units','normalized','Position',[0.9 .95 0.1 0.05],'Visible','on');
        StopButton.Enable = 'Inactive';
        StopButton.ButtonDownFcn = 'KeepGoingOn=0; close(FigHandle2)';
        drawnow;
        
        %saveas(gcf,['Images/Test-' num2str(it) '.jpg']);
    end
    
    %% Terminate the main script if button 'STOP' is pressed
    
    StopButton=uicontrol('Parent',FigHandle,'Style','pushbutton','String','STOP and DELETE','Units','normalized','Position',[0.9 .95 0.1 0.05],'Visible','on');
    StopButton.Enable = 'Inactive';
    StopButton.ButtonDownFcn = 'KeepGoingOn=0; close(FigHandle)';
    drawnow;
    
end