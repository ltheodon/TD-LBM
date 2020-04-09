%% Scenarios (mainly described by boolean variables)
% The choice of the "Scenario" influences on the 'typical velocity' and on the plots.
% The available scenarii are listed below.
%    'Hydrostatic'      : Hydrostatic pressure profile (no heat transfer)
%    'Poiseuille'       : Poiseuille (without heat transfer)
%    'LidDriven'        : Lid-driven cavity flow (without heat transfer)
%    'Obstacle'         : Hand-made obstacle in isothermal Poiseuille flow (shape in geometry.xlsm). Flow from left(low-X) to Right (high-X)
%    'VonKarman'        : Von Karman vortices behind a disk
%    'HeatConduction'   : Pure heat conduction (no gravity + fluid motion is disabled)
%    'SideHeatedCavity' : Free convection with 4 Dirichlet BC and lateral Delta_T
%    'Benard'           : Rayleigh-Bénard configuration (heated from below)
%    'BenardHR'         : High-resolution Rayleigh-Bénard configuration (heated from below)
%    'UserDefined1'     : scenario defined by the user
%    'Debugging'        : scenario to check if code is correct

Scenario = 'HeatConduction';    % WARNING : if 'UserDefined', please change below in this file', 'Postprocessing.m' and 'PlotResults.m'

%% Definition of the system size (rectangle)

ThermalConditions   = zeros(14,1);  % IsWithHeatTransfer IsRightDirichlet  IsTopDirichlet IsLeftDirichlet IsBottomDirichlet     T_d_0   Tright_d    Ttop_d      Tleft_d     Tbottom_d   qintop      qinbottom   qinleft     qinright  
KinematicConditions = zeros(14,1);  % IsPeriodicAlongX  IsPeriodicAlongY  vx_d_0  vy_d_0  vxtop_d     vxbottom_d    vyleft_d    vyright_d    vytop_d     vybottom_d    vxleft_d    vxright_d gx_d        gy_d
SpaceAndTime        = zeros(6,1);   % Lx_d    Ly_d    Nx      Ny      Nt      NumberOfFrames

switch Scenario
    
    case 'Hydrostatic'
        ThermalConditions   = [  0      1 1 1 1    300     300      305     300     295       0         0           0           0];
        KinematicConditions = [ 0 0        0       0       0        0       0       0         0 0 0 0  0         9.81];
        SpaceAndTime        = [ 0.001    0.001    20      20        200     100  ];
    
    case 'Poiseuille'   
        ThermalConditions   = [  0      1 1 1 1    300     300     305       300       295       0         0           0           0];
        KinematicConditions = [ 0 1        0       0       0       0         0         0         0 0 0 0    0         -9.81];
        SpaceAndTime        = [ 0.003    0.003    10      10       6000      50  ];         

    case 'Debugging'   
        ThermalConditions   = [  0      1 1 1 1    300     300     305       300       295       0         0           0           0];
        KinematicConditions = [ 0 1        0       0       0       0         0         0         0 0 0 0   0          -9.81];
        SpaceAndTime        = [ 0.003    0.003    4      3       100      50  ];       
        
    case 'LidDriven'
        ThermalConditions   = [  0      1 1 1 1    300     300     305       300       295       0         0           0           0];
        KinematicConditions = [ 0 0        0       0       1  0         0         0         0 0 0 0   0 0];
        SpaceAndTime        = [ 0.001567    0.001567    100      100      4000    200  ];
    
    case 'Obstacle'   
        [XLnum,XLstr]       = xlsread('Geometry.xlsm',1,'AP3:AW6');
        ThermalConditions   = [  0      1 1 1 1    300     300     305       300       295       0         0           0           0];
        KinematicConditions = [ XLnum(1,8) XLnum(2,8)        0       0       0       0         0         0         0 0 0 0    9.81 0];
        SpaceAndTime        = [ 0.003    0.003    XLnum(2,5) XLnum(3,5)     2500      50  ];
 
    case 'VonKarman'   
        ThermalConditions   = [  0      1 1 1 1    300     300     305       300       295       0         0           0           0];
        KinematicConditions = [ 0 1        0       0       0       0         0         0         0 0 0 0    0         -9.81];
        SpaceAndTime        = [ 0.006    0.03    20 100     20000      50  ];
        RelativeDiameter    = 0.2;            % Reference length is min(Lx,Ly)
        RelativeXPosition   = 0.5;            % Reference length is Lx
        RelativeYPosition   = 0.8;            % Reference length is Ly
  
    case 'HeatConduction'  
        ThermalConditions   = [ 1       0 1 0 1    300     300   302     300       301       0         0           0           0];
        KinematicConditions = [ 0 0        0       0       0       0       0         0       0 0 0 0   0 0];
        SpaceAndTime        = [ 0.01    0.01    10      10      1300    50  ];  
    
    case 'SideHeatedCavity'  
        ThermalConditions   = [ 1       1 0 1 0    300     300     295       305       300       0         0           0           0];
        KinematicConditions = [ 0 0        0       0       0       0         0         0         0 0 0 0   0 -9.81];
        SpaceAndTime        = [ 0.005    0.005    35      35      500     100  ];
    
    case 'Benard'  
        ThermalConditions   = [ 1       0 1 0 1    300    300     295        300       305       0         0           0           0];
        KinematicConditions = [ 0 0        0       0       0       0         0         0         0 0 0 0   0 -9.81];
        SpaceAndTime        = [ 0.02    0.01    40      20      1000    50  ];

    case 'BenardHR'  
        ThermalConditions   = [ 1       0 1 0 1     300      300     295        300       305      0         0           0           0];
        KinematicConditions = [ 0 0        0        0        0       0           0         0         0 0 0 0   0  -9.81 ];
        SpaceAndTime        = [ 0.05    0.01        100      20      2000        70  ];

    case 'UserDefined1'          
        ThermalConditions   = [ 1       1 1 1 1    300     300     295       305       300       0         0           0           0];
        KinematicConditions = [ 0 0        0       0       0       0         0         0         0 0 0 0   0 -9.81];
        SpaceAndTime        = [ 0.005    0.005    35      35      500     100  ];
        
    case 'Benard2'  
        ThermalConditions   = [ 1       0 1 0 1    300    300     298        300       305       0         0           0           0];
        KinematicConditions = [ 0 0        0       0       0       0         0         0         0 0 0 0   0 -9.81];
        SpaceAndTime        = [ 0.04    0.02    80      40      10000    50  ];

end

%% Space and time discretization

Lx_d               = SpaceAndTime(1);          % Dimension along X-direction [m]
Ly_d               = SpaceAndTime(2);          % Dimension along Y-direction [m]
Nx                 = SpaceAndTime(3);          % Columns number
Ny                 = SpaceAndTime(4);          % Rows number
Nt                 = SpaceAndTime(5);          % Timesteps number
NumberOfFrames     = SpaceAndTime(6);          % Number of plots displayed during the simulation (different from Movie frames)

%% Initial conditions and boundary conditions for heat transfers 

IsWithHeatTransfer = ThermalConditions(1);           % 1 if thermo-hydraulic coupling and 0 if only hydrodynamic
IsRightDirichlet   = ThermalConditions(2);           % 1 if Dirichlet BC (imposed temperature ) and 0 if Neumann BC (imposed flux)
IsTopDirichlet     = ThermalConditions(3);           % 1 if Dirichlet BC (imposed temperature ) and 0 if Neumann BC (imposed flux)
IsLeftDirichlet    = ThermalConditions(4);           % 1 if Dirichlet BC (imposed temperature ) and 0 if Neumann BC (imposed flux)
IsBottomDirichlet  = ThermalConditions(5);           % 1 if Dirichlet BC (imposed temperature ) and 0 if Neumann BC (imposed flux)
T_d_0              = ThermalConditions(6);           % Initial temperature of the fluid bulk             [K]
Tright_d           = ThermalConditions(7);           % Temperature at nx=Nx                              [K]
Ttop_d             = ThermalConditions(8);           % Temperature at ny=Ny                              [K]
Tleft_d            = ThermalConditions(9);           % Temperature at nx=1                               [K]
Tbottom_d          = ThermalConditions(10);          % Temperature at ny=1                               [K]
qinright           = ThermalConditions(11);          % Heat flux density coming in through nx=Nx         [W/m2]
qintop             = ThermalConditions(12);          % Heat flux density coming in through ny=Ny         [W/m2]
qinleft            = ThermalConditions(13);          % Heat flux density coming in through nx=1          [W/m2]
qinbottom          = ThermalConditions(14);          % Heat flux density coming in through ny=1          [W/m2]

%% Initial conditions and boundary conditions for kinematics

IsPeriodicAlongX   = KinematicConditions(1);            % 1 if boundaries are periodic along X-direction and 0 otherwise
IsPeriodicAlongY   = KinematicConditions(2);            % 1 if boundaries are periodic along Y-direction and 0 otherwise
vx_d_0             = KinematicConditions(3);            % Initial fluid velocity    (X-component)             [m/s]
vy_d_0             = KinematicConditions(4);            % Initial fluid velocity    (Y-component)             [m/s]
vxtop_d            = KinematicConditions(5);            % Velocity at ny=Ny         (X-component)             [m/s]
vxbottom_d         = KinematicConditions(6);            % Velocity at ny=1          (X-component)             [m/s]
vyleft_d           = KinematicConditions(7);            % Velocity at nx=1          (Y-component)             [m/s]
vyright_d          = KinematicConditions(8);            % Velocity at nx=Nx         (Y-component)             [m/s]
vytop_d            = KinematicConditions(9);            % Velocity at ny=Ny         (Y-component)             [m/s]
vybottom_d         = KinematicConditions(10);           % Velocity at ny=1          (Y-component)             [m/s]
vxleft_d           = KinematicConditions(11);           % Velocity at nx=1          (X-component)             [m/s]
vxright_d          = KinematicConditions(12);           % Velocity at nx=Nx         (X-component)             [m/s]
gx_d               = KinematicConditions(13);           % Body force per mass unit  (X-component)             [m/s^2]
gy_d               = KinematicConditions(14);           % Body force per mass unit  (Y-component)             [m/s^2]

%% Intermediate quantities 

Lmin_d          = min([Lx_d Ly_d]);                                         % Minimal system dimension      [m]                        [m]
Lmax_d          = max([Lx_d Ly_d]);                                         % Maximal system dimension      [m]                        [m]
Tmin_d          = min([Ttop_d Tbottom_d Tleft_d Tright_d]);                 % Minimal temperature           [K]                         [K]
Tmax_d          = max([Ttop_d Tbottom_d Tleft_d Tright_d]);                 % Maximal temperature           [K]                       [K]
DeltaT_d        = Tmax_d - Tmin_d;                                          % Temperature difference        [K]                     [K]
gmax_d          = max(abs([gx_d gy_d]));                                    % Maximal gravity               [m/s^2]                                 [m2/s]
vwallXmax_d     = max(abs([vxright_d vxtop_d vxleft_d vxbottom_d]));        % Maximal X-velocity            [m/s]
vwallYmax_d     = max(abs([vyright_d vytop_d vyleft_d vybottom_d]));        % Maximal Y-velocity            [m/s]
vwallmax_d      = max([vwallXmax_d vwallYmax_d]);                           % Maximal velocity              [m/s]

%% Compute a characteristic velocity for the chosen scenario

switch Scenario
    case {'Hydrostatic','Poiseuille','Obstacle','VonKarman','Debugging'}
        v1 = abs(gx_d)* Ly_d^2/(8*Viscosity_d);
        v2 = abs(gy_d)* Lx_d^2/(8*Viscosity_d);
        vtypic_d = max([v1 v2]);        
    case 'LidDriven'
        vtypic_d = vwallmax_d;  
    case 'HeatConduction'
        vtypic_d = 0.1;           % 0 in reality but around 0.1 to avoid division by 0
    case 'SideHeatedCavity'
        %vtypic_d = sqrt(beta_d*gy_d*Ly_d*DeltaT_d);        % Source : Nemati,2010
        vtypic_d = 0.1;
    case 'Benard'
        %vtypic_d = sqrt(beta_d*gy_d*Ly_d*DeltaT_d);        % Source : Nemati,2010
        vtypic_d = 0.1;
    case 'Benard2'
        %vtypic_d = sqrt(beta_d*gy_d*Ly_d*DeltaT_d);        % Source : Nemati,2010
        vtypic_d = 0.1;
    case 'BenardHR'
        %vtypic_d = sqrt(2*beta_d*gmax_d*Lmax_d*DeltaT_d);  
        v1 = abs(gx_d)* Ly_d^2/(8*Viscosity_d);
        v2 = abs(gy_d)* Lx_d^2/(8*Viscosity_d);
        vtypic_d = max([v1 v2]);  
        vtypic_d = 0.1;
    case 'UserDefined1'
        %vtypic_d = sqrt(beta_d*gy_d*Ly_d*DeltaT_d);        % Source : Nemati,2010
        vtypic_d = 0.1;
end
