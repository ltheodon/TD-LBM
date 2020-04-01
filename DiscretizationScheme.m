%% Discretization schemes (mass and then temperature) in D=2 dimensions

% Scheme D2Q9 for mass
Q      = 9;                                              % Number of predefined velocities (9 for the scheme D2Q9)
k      = 3; % to fill in;                                              % The constant k is defined by k^2 = c_s_a = c_s_d/c_r_d     with c_s_d = sqrt(tilde(R).T)    and   c_r_d = Deltax_d /Deltat_d   
W      = [1/9 1/9 1/9 1/9 1/36 1/36 1/36 1/36 4/9 ]; % to fill in;                   % Weight coefficients W_i for the scheme D2Q9 : W_1 -> W_9
opp    = [3 4 1 2 7 8 5 6 9]; % to fill in;                            % opp(i) designates the direction opposite to direction i
ciax   = [1 0 -1 0 1 -1 -1 1 0] ; % to fill in;                       % Dimensionless predefined velocities (X-component)
ciay   = [0 1 0 -1 1 1 -1 -1 0]; % to fill in];                       % Dimensionless predefined velocities (Y-component)

CP='DS1'; CheckPoints;                                   % Check for some values

% Scheme D2Q5 for temperature
Q_t    = 5;                                              % Number of predefined velocities (5 for the scheme D2Q5)
k_t    = 3;                                            % The constant k is defined by k^2 = c_s_a = c_s_d/c_r_d     with c_s_d = sqrt(tilde(R).T)    and   c_r_d = Deltax_d /Deltat_d   
W_t    = [1/6 1/6 1/6 1/6 2/6]; % to fill in;                          % Weight coefficients W_i for the scheme D2Q5 : W_1 -> W_5
opp_t  = [3 4 1 2 5]; % to fill in;                                    % opp_t(i) designates the direction opposite to direction i
ciax_t = [1 0 -1 0 0]; % to fill in;                                  % Dimensionless predefined velocities (X-component)
ciay_t = [0 1 0 -1 0]; % to fill in];                                  % Dimensionless predefined velocities (Y-component)

CP='DS2'; CheckPoints;                                   % Check for some values