%% Physical properties of the fluid 

Fluid  = 'air';             % Choose among 'air' or 'water'      
Ma_lim = 0.3;               % Incompressibility limit - Maximum allowed Mach number

switch Fluid
    
    case 'air'
        rho_d_0         = 1.18;                                 % Density [kg/m^3]  (default = 1.18)
        Viscosity_d     = 1.567e-5;                             % Kinematic viscosity [m^2/s] (default = 1.567e-5)
        gamma           = 1.4;                                  % Adiabatic coefficient [-]. Hypothesis : diatomic perfect gas (default = 1.4)
        cp              = 1004;                                 % Heat capacity per mass unit [J/kg/K] (default = 1004)
        Diffusivity_d   = 1.9e-5;                               % Thermal diffusivity [m2/s] (default = 1.9e-5 @ 25°C)
        betaV_d         = 0.003400;                             % Isobaric volumetric thermal expansion coefficient [1/K] 
        vs_d            = 343;                                  % Sound velocity [m/s] (default = 343 m/s à 20°C)
        lambda_d        = Diffusivity_d*rho_d_0/cp;             % Heat conductivity [W/m/K]
        
    case 'water'
        rho_d_0         = 1000;                                 % Density [kg/m^3]
        Viscosity_d     = 2e-6;                                 % Kinematic viscosity [m^2/s]
        gamma           = 1.011;                                % Adiabatic coefficient [-] (default = 1.011 at 25°C)
        cp              = 4185;                                 % Heat capacity per mass unit [J/kg/K]
        Diffusivity_d   = 1.43e-7;                              % Thermal diffusivity [m2/s] (default = 1.43e-7 at 25°C)
        betaV_d         = 0.000210;                             % Isobaric volumetric thermal expansion coefficient  [1/K]
        vs_d            = 1480;                                 % Sound velocity [m/s] (default = 1480)
        lambda_d        = Diffusivity_d*rho_d_0/cp;             % Heat conductivity [W/m/K]
        
end