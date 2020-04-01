%% Construction of the array "F_NodeType" which gives the nature of every node (core and boundaries) for mass (F-function)

% 0 : fluid
% 1 : solid wall
% 2 : periodic along X-direction
% 3 : periodic along Y-direction

F_NodeType = zeros(Nx+2,Ny+2);          % Default : all nodes are fluid. Exceptions are considered below.

switch Scenario
    case 'Obstacle'       % The shape & position of the obstacle is specified in 'Geometry.xlsm'
        F_NodeTypeXL = xlsread('Geometry.xlsm',1,XLstr{4,3});    % Le tableau Excel contient la nature des noeuds : 0,1,2,3 pour fluide, solide, périodique-x, périodique-y
        F_NodeType   = flipud(F_NodeTypeXL)';                    % Retournement pour tenir compte de l'orientation de la matrice Excel
    case 'VonKarman'      % Draw a disk (with position and diameter specified in 'Scenarii.m'
        for nx=1:Nx+2
            for ny=1:Ny+2
                nxc = floor(RelativeXPosition*(Nx+2));              % X-Index of disk center
                nyc = floor(RelativeYPosition*(Ny+2));              % Y-Index of disk center
                rc =  floor(RelativeDiameter*min([Nx+2 Ny+2])/2);   % Disk radius (in lattice units)
                if (nx-nxc)^2+(ny-nyc)^2 < rc^2
                    F_NodeType(nx,ny) = 1;
                end
            end
        end
end

if ~IsPeriodicAlongX && ~IsPeriodicAlongY           % Solid walls everywhere
    F_NodeType(1,:)         = 1;% to fill in
    F_NodeType(Nx+2,:)      = 1;% to fill in
    F_NodeType(:,1)         = 1;% to fill in
    F_NodeType(:,Ny+2)      = 1;% to fill in
end

if IsPeriodicAlongX && ~IsPeriodicAlongY           % Periodic along X and solid walls at top/bottom
    F_NodeType(1,2:Ny+1)    = 2;% to fill in
    F_NodeType(Nx+2,2:Ny+1) = 2;% to fill in
    F_NodeType(:,1)         = 1;% to fill in
    F_NodeType(:,Ny+2)      = 1;% to fill in
end

if ~IsPeriodicAlongX && IsPeriodicAlongY           % Periodic along Y and solid walls at left/right
    F_NodeType(1,:)         = 1;% to fill in
    F_NodeType(Nx+2,:)      = 1;% to fill in
    F_NodeType(2:Nx+1,1)    = 3;% to fill in
    F_NodeType(2:Nx+1,Ny+2) = 3;% to fill in
end

if IsPeriodicAlongX && IsPeriodicAlongY            % Periodic along X and Y directions
    F_NodeType(1,2:Ny+1)    = 2;% to fill in
    F_NodeType(Nx+2,2:Ny+1) = 2;% to fill in
    F_NodeType(:,1)         = 3;% to fill in
    F_NodeType(:,Ny+2)      = 3;% to fill in
end

CP='P1'; CheckPoints;                            % Check the construction of F_NodeType(Nx+2,Ny+2)

%% Filling of three arrays 
%  We adopt the "reception" point of view for the transfer.
%  Hence, the symbol 'nxsf' stands for "nx source f-function"

nxsf = zeros(Nx,Ny,Q);
nysf = zeros(Nx,Ny,Q);
i_sf = zeros(Nx,Ny,Q);

for ix = 1:Nx
    for iy = 1:Ny
        for iq = 1:Q
            ix_dest = ix - ciax(iq);
            iy_dest = iy - ciay(iq);
            check = F_NodeType(ix_dest + 1, iy_dest + 1);
            switch check
                case 0
                    nxsf(ix, iy, iq) = ix_dest;
                    nysf(ix, iy, iq) = iy_dest;
                    i_sf(ix, iy, iq) = iq;
                case 1
                    nxsf(ix, iy, iq) = ix;
                    nysf(ix, iy, iq) = iy;
                    i_sf(ix, iy, iq) = opp(iq);
                case 2
                    nxsf(ix, iy, iq) = Nx - (ix-1);
                    nysf(ix, iy, iq) = iy_dest;
                    i_sf(ix, iy, iq) = iq;
                case 3
                    nxsf(ix, iy, iq) = ix_dest;
                    nysf(ix, iy, iq) = Ny - (iy-1);
                    i_sf(ix, iy, iq) = iq;
            end
        end
    end
end


% nxsf = nxsf;% to fill in
% nysf = nysf;% to fill in
% i_sf = i_sf;% to fill in

CP='P2'; CheckPoints;                            % Check the construction of nxsf(Nx,Ny,Q)
CP='P3'; CheckPoints;                            % Check the construction of nysf(Nx,Ny,Q)
CP='P4'; CheckPoints;                            % Check the construction of i_sf(Nx,Ny,Q)



%% Construction of the array "G_NodeType" which gives the nature of every node (core and boundaries) for heat (G-function)

% 0 : fluid
% 1 : wall with temperature imposed (Dirichlet)
% 2 : wall with zero heat flux (adiabatic)

if IsWithHeatTransfer
    G_NodeType = zeros(Nx+2,Ny+2);                        % Default : all nodes are fluid. Exceptions are considered below.
    TC = ThermalConditions(2:5);                          % Vector of 4 numbers (0 or 1 each) defining the thermal boundary conditions
    
    if isequal(TC, [1 1 1 1])                           % Dirichlet walls everywhere
        G_NodeType(1,2:Ny+1)    = 1;% to fill in
        G_NodeType(Nx+2,2:Ny+1) = 1;% to fill in
        G_NodeType(:,1)         = 1;% to fill in
        G_NodeType(:,Ny+2)      = 1;% to fill in
    end
    
    if isequal(TC, [0 0 0 0])                           % Adiabatic walls everywhere
        G_NodeType(1,2:Ny+1)    = 2;% to fill in
        G_NodeType(Nx+2,2:Ny+1) = 2;% to fill in
        G_NodeType(:,1)         = 2;% to fill in
        G_NodeType(:,Ny+2)      = 2;% to fill in
    end
    
    if isequal(TC, [0 1 0 1])                           % Top/bottom are Dirichlet and Left/Right are adiabatic
        G_NodeType(1,:)         = 1;% to fill in
        G_NodeType(Nx+2,:)      = 1;% to fill in
        G_NodeType(2:Nx+1,1)    = 2;% to fill in
        G_NodeType(2:Nx+1,Ny+2) = 2;% to fill in
    end
    
    if isequal(TC, [1 0 1 0])                           % Top/bottom are adiabatic and Left/Right are Dirichlet
        G_NodeType(1,2:Ny+1)    = 2;% to fill in
        G_NodeType(Nx+2,2:Ny+1) = 2;% to fill in
        G_NodeType(:,1)         = 1;% to fill in
        G_NodeType(:,Ny+2)      = 1;% to fill in
    end
    
    %% Filling of four arrays :
    
    % Voir p18 pu poly
    
    SourceNodeType = zeros(Nx,Ny,Q_t);          % Nature of the source node (for heat)
    nxst = zeros(Nx,Ny,Q_t);                    % Abscissa of the source node (for heat)
    nyst = zeros(Nx,Ny,Q_t);                    % Ordinate of the source node (for heat)
    i_st = zeros(Nx,Ny,Q_t);                    % Direction associated to the source node (for heat)
   
        
%     SourceNodeType = % to fill in
%     nxst = % to fill in
%     nyst = % to fill in
%     i_st = % to fill in

for ix = 1:Nx
    for iy = 1:Ny
        for i = 1:Q_t
            ix_dest = ix + ciax_t(i);
            iy_dest = iy + ciay_t(i);
            check = G_NodeType(ix_dest + 1, iy_dest + 1);
            switch check
                case 0
                    nxst(ix, iy, i) = ix_dest;
                    nyst(ix, iy, i) = iy_dest;
                    i_st(ix, iy, i) = i;
                    SourceNodeType(ix, iy, i) = 0;
                case 1
                    nxst(ix, iy, i) = ix;
                    nyst(ix, iy, i) = iy;
                    i_st(ix, iy, i) = opp_t(i);
                    SourceNodeType(ix, iy, i) = 1;
                case 2
                    nxst(ix, iy, i) = ix;
                    nyst(ix, iy, i) = iy;
                    i_st(ix, iy, i) = opp_t(i);
                    SourceNodeType(ix, iy, i) = 2;
            end
        end
    end
end
end