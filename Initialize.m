%% STEP 0 : Initialization

% Basic quantities
KeepGoingOn = 1;                                                        % Stop criterion is not met
nt          = 1;                                                        % Initialization of the iteration number

% Initialization for density, velocity and temperature
rho_a(:,:) = rho_a_0 * ones(Nx,Ny);% to fill in ;                                    % Initial density field
vx_a(:,:)  = vx_a_0 * ones(Nx,Ny); % to fill in;                                    % Initial macroscopic velocity field (X-component)
vy_a(:,:)  = vy_a_0 * ones(Nx,Ny); % to fill in;                                    % Initial macroscopic velocity field (Y-component)
T_a(:,:)   = T_a_0 * ones(Nx,Ny); % to fill in;                                    % Initial temperature field

% Initialization of f_i's (for mass)
v2_a = vx_a(:,:).^2 + vy_a(:,:).^2;                                     % Intermediate quantity : squared norm of v_a=(vx_a vy_a)
for i=1:Q
    civ = ciax(i)*vx_a(:,:) + ciay(i)*vy_a(:,:);% to fill in
    Feq_a(:,:,i) = rho_a(:,:).*W(i).* (1 + k*civ + (k^2/2) * civ.^2 - (k/2) * v2_a); % to fill in;                           % Equilibrium distribution for mass
end
F_a = Feq_a;                                                            % Initial value of F is equilibrium value
CP='I1'; CheckPoints;                                                   % Check the construction of Feq_a

% Initialization of g_i's (for temperature)
if IsWithHeatTransfer
    for i=1:Q_t
        civ = ciax_t(i)*vx_a(:,:) + ciay_t(i)*vy_a(:,:);    % to fill in
        Geq_a(:,:,i) = T_a(:,:).*W_t(i).* (1 + k_t*civ + (k_t^2/2) * civ.^2 - (k_t/2) * v2_a);% to fill in;                        % Equilibrium distribution for temperature
    end
    G_a = Geq_a;                                                             % Initial value of G is equilibrium value
    CP='I2'; CheckPoints;                                                   % Check the construction of Geq_a
end

tic;                                                                    % Set the timer to zero