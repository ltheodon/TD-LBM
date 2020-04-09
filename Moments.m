%% STEP 3 = COMPUTE THE MOMENTS

if IsWithHeatTransfer
    % Temperature-related moments
    T_a = zeros(Nx,Ny);
    for i=1:Q_t
        %T_a(:,:)  = % to fill in;
        T_a(:,:) = T_a(:,:) + G_a(:,:,i);
    end
    
%     for nx=1:Nx
%         for ny=1:Ny
%             for i=1:Q_t
%                 ixd = nxst(nx, ny, i);
%                 iyd = nyst(nx, ny, i);
%                 id = i_st(nx, ny, i);
%                 type = SourceNodeType(nx, ny, i);
%                 switch id
%                 	case 2
%                     	T_w = Tleft_a;
%                     	q_w = qinleft;
%                 	case 3
%                     	T_w = Tbottom_a;
%                     	q_w = qinbottom;
%                     case 4
%                     	T_w = Tright_a;
%                     	q_w = qinright;
%                 	case 1
%                     	T_w = Ttop_a;
%                     	q_w = qintop;
%                 end
%                 switch type
%                     case 0
%                         
%                     case 1
%                         T_a(ixd,iyd) = T_w;
%                     case 2
%                         T_w = T_a(ixd,iyd) + Deltax_d * q_w / (2*lambda_d);
%                         T_a(ixd,iyd) = T_w;                       
%                 end
%             end
%         end
%     end
    
    
    
    
    %BodyForce = % to fill in  
    % voir p19 du polycopié
    BodyForce = -(T_a - T_a_0*ones(Nx,Ny))*betaV_a;
else
    BodyForce = ones(Nx,Ny);
end

% Mass-related moments
% v = vitesse macroscopique du fluide
% c = vitesse micro
% rho = somme_1^Q f_i^(eq)
% rho*v_alpha = somme_1^Q c_i_alpha f_i^(eq)

% to fill in
rho_a(:,:)  = zeros(Nx,Ny); 
%rho_a(:,:) = sum(F_a,3);
vx_a(:,:)  = zeros(Nx,Ny);
vy_a(:,:)  = zeros(Nx,Ny); 
for i=1:Q
    rho_a(:,:) = rho_a(:,:) + F_a(:,:,i);
    vx_a(:,:) = vx_a(:,:) + F_a(:,:,i)*ciax(i);
    vy_a(:,:) = vy_a(:,:) + F_a(:,:,i)*ciay(i);
end
vx_a  = vx_a./rho_a + gx_a*Tauf_a*BodyForce;      % The second term accounts for body force
vy_a  = vy_a./rho_a + gy_a*Tauf_a*BodyForce;      % The second term accounts for body force

CP='M1'; CheckPoints;                             % Check the construction of the moments (especially rho_a)

% Four special resets to enforce the velocity of moving walls
% Cf. top left text of page 332 of Hou et al., 1995

if strcmp(Scenario,'LidDriven')
    for nx=1:Nx
        for ny=1:Ny
            if (nx==1)  && (ny~=1) && (ny~=Ny) , vx_a(nx,ny) = 0          ; vy_a(nx,ny) = vyleft_a;  end
            if (nx==Nx) && (ny~=1) && (ny~=Ny) , vx_a(nx,ny) = 0          ; vy_a(nx,ny) = vyright_a; end
            if (ny==1)  && (nx~=1) && (nx~=Nx) , vx_a(nx,ny) = vxbottom_a ; vy_a(nx,ny) = 0;         end
            if (ny==Ny) && (nx~=1) && (nx~=Nx) , vx_a(nx,ny) = vxtop_a    ; vy_a(nx,ny) = 0;         end
        end
    end
end

% =========================================================================================================================
% The following lines correpond to an unfinished attempt to compute the force exerted by the fluid on the solid obstacle.

if strcmp(Scenario,'Obstacle')
    
    % Computation of PI (momentum flux tensor ?)
    
    PI_xx = zeros(Nx,Ny);
    PI_xy = zeros(Nx,Ny);
    PI_yx = zeros(Nx,Ny);
    PI_yy = zeros(Nx,Ny);
    
    for i=1:Q
        PI_xx(:,:) = PI_xx(:,:) + F_a(:,:,i)*ciax(i)*ciax(i);
        PI_xy(:,:) = PI_xy(:,:) + F_a(:,:,i)*ciax(i)*ciay(i);
        PI_yx(:,:) = PI_yx(:,:) + F_a(:,:,i)*ciay(i)*ciax(i);
        PI_yy(:,:) = PI_yy(:,:) + F_a(:,:,i)*ciay(i)*ciay(i);
    end
    
    % Computation of sigma (stress tensor ?)
    
    sigma_xx = zeros(Nx,Ny);
    sigma_xy = zeros(Nx,Ny);
    sigma_yx = zeros(Nx,Ny);
    sigma_yy = zeros(Nx,Ny);
    
    sigma_xx = PI_xx - rho_a*vx_a*vx_a;
    sigma_xy = PI_xy - rho_a*vx_a*vy_a;
    sigma_yx = PI_yx - rho_a*vy_a*vx_a;
    sigma_yy = PI_yy - rho_a*vy_a*vy_a;
    
    % Identification of the fluid nodes directly in contact with solid obstacle
    
    FluidDomain = F_NodeType(2:Nx+1,2:Ny+1);
    DilatedFluidDomain = imdilate(FluidDomain,strel('disk',1));
    Interface = DilatedFluidDomain-FluidDomain;     % Equal to 1 for fluid nodes in contact with solid and 0 elsewhere
    
    % To be continued
   
end