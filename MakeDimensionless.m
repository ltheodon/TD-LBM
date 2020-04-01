%% Compute the space and time increments

Deltax_d = Lx_d / Nx;                                                   % Space increment (X-direction)     [m]
Deltay_d = Ly_d / Ny;                                                   % Space increment (Y-direction)     [m]
Deltat_d = (Ma_lim * Deltax_d) / (vtypic_d*sqrt(k));                    % Time increment in order to be at the incompressibility limit [s]

%% Compute dimensionless quantities
 
% rho_a = rho_d / (1/delta_x)^3)
% tau_a = tau_d / delta_t
% v_a = v_d / (delta_x/delta_t)

% Cs = sqrt(Rbar*T) vitesse du son isotherme
% v_s = sqrt(gamma Rbar T) vitesse du son adiabatique
% Ma = Norme(v)/v_s
% Rbar = R/Mbar


rho_a_0         = rho_d_0 / (1/Deltax_d^3);     % to fill in;                 % Dimensionless density 
gx_a            = gx_d / (Deltax_d/Deltat_d^2); % to fill in;          % Dimensionless body force per unit mass (X-component)
gy_a            = gy_d / (Deltax_d/Deltat_d^2) ; % to fill in;          % Dimensionless body force per unit mass (Y-component)
vx_a_0          = vx_d_0 / (Deltax_d/Deltat_d); % to fill in;            % Dimensionless initial velocity  (X-component)
vy_a_0          = vy_d_0 / (Deltax_d/Deltat_d); % to fill in;            % Dimensionless initial velocity  (Y-component)
vxtop_a         = vxtop_d / (Deltax_d/Deltat_d); % to fill in;            % Dimensionless velocity at ny=Ny (X-component)
vxbottom_a      = vxbottom_d / (Deltax_d/Deltat_d);% to fill in;            % Dimensionless velocity at ny=1  (X-component) 
vyleft_a        = vyleft_d / (Deltax_d/Deltat_d); % to fill in;            % Dimensionless velocity at nx=1  (Y-component)
vyright_a       = vyright_d / (Deltax_d/Deltat_d); % to fill in;            % Dimensionless velocity at nx=Nx (Y-component)
vytop_a         = vytop_d / (Deltax_d/Deltat_d); % to fill in;            % Dimensionless velocity at ny=Ny (Y-component)
vybottom_a      = vybottom_d / (Deltax_d/Deltat_d); % to fill in;            % Dimensionless velocity at ny=1  (Y-component) 
vxleft_a        = vxleft_d / (Deltax_d/Deltat_d);% to fill in;            % Dimensionless velocity at nx=1  (X-component)
vxright_a       = vxright_d / (Deltax_d/Deltat_d);% to fill in;            % Dimensionless velocity at nx=Nx (X-component)
T_a_0           = (T_d_0-Tmin_d) / (DeltaT_d); % to fill in;                       % Dimensionless initial temperature of the fluid
Ttop_a          = (Ttop_d-Tmin_d)  / (DeltaT_d);% to fill in;                       % Dimensionless temperature at ny=Ny
Tbottom_a       = (Tbottom_d-Tmin_d)  / (DeltaT_d);% to fill in;                       % Dimensionless temperature at ny=1
Tleft_a         = (Tleft_d-Tmin_d)  / (DeltaT_d);% to fill in;                       % Dimensionless temperature at nx=1
Tright_a        = (Tright_d-Tmin_d)  / (DeltaT_d);% to fill in;                       % Dimensionless temperature at nx=Nx
betaV_a         = betaV_d  * DeltaT_d;% to fill in;                   % Dimensionless isobaric volumic coefficient of thermal expansion

Vx_a = [vxright_a vxtop_a vxleft_a vxbottom_a vxtop_a vxtop_a vxbottom_a vxbottom_a];   % Corners belong to top or bottom boundary
Vy_a = [vyright_a vytop_a vyleft_a vybottom_a vytop_a vytop_a vybottom_a vybottom_a];   % Corners belong to top or bottom boundary

Re_r  = vtypic_d*Lmin_d/Viscosity_d ; % Reynolds number for the real system 
Ma_r  = (vtypic_d/vs_d) ;  % Mach number for the real system
Ra_r = betaV_d * gmax_d * DeltaT_d * Lmin_d^3 / (Viscosity_d * Diffusivity_d) ;     % Rayleigh number for the real system
Pr_r  =  Viscosity_d / Diffusivity_d; % to fill in;                                    % Prandtl  number for the real system

Viscosity_a    = Viscosity_d * (Deltat_d/Deltax_d^2); % to fill in;                     % Dimensionless kinematic viscosity
Tauf_a         = 1/2 + Viscosity_a *k; %    % Dimensionless relaxation time for mass distribution

%Diffusivity_a  = lambda_d/(cp*rho_a_0); % to fill in;                 % Dimensionless heat diffusivity
Diffusivity_a  = Diffusivity_d * (Deltat_d/Deltax_d^2); 
Taug_a         = 1/2 + Diffusivity_a * k_t; % to fill in;                               % Dimensionless relaxation time for temperature distribution

disp(['Dimensionless quantities : ']);
fprintf('\nRe = %.2g        Ma = %.2g         Ra = %.2g        Pr = %.2g \n\n',[Re_r Ma_r Ra_r Pr_r]);      % Print values for error checking
fprintf('Tau_f = 0.5 + %.2g            Tau_g = 0.5 + %.2g \n',[Tauf_a-0.5 Taug_a-0.5]);                 % Print values for error checking
disp('======================================================');


CP='MD1'; CheckPoints;                            % Check the construction of Reynolds Number Re
CP='MD2'; CheckPoints;                            % Check the construction of Rayleigh Number Gr
CP='MD3'; CheckPoints;                            % Check the construction of dimensionless kinematic viscosity Viscosity_a
