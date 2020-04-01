% This bundle of scripts computes the density, velocity and temperature of a fluid in different configurations.  
% We use the Lattice Boltzmann Method D2Q9 for mass and D2Q5 for temperature. 

clear all               % Clear many things (among which Workspace)
close all hidden        % Close existing figures (visible or hidden)
clc                     % Clear the 'Command Window'

Fluids;                 % Choose the fluid : air or water 
Scenarii;               % Examples : hydrostatic, poiseuille, lid-driven, heat conduction, free convection, ...
DiscretizationScheme;  	% Example : D2Q9 for mass and D2Q5 for energy
MakeDimensionless;      % Make quantities dimensionless (among which the relaxation times)
Preprocessing;          % Compute Deltax and Deltat + fill in some arrays : nxs, nys, i_s, K_a and G_fact, ...
Initialize;             % Initialization = value at t=0 of following variables : density, velocity, temperature, f_i and g_i

while KeepGoingOn
    
    Collision;          % Compute the collisions with the SRT-BGK algorithm
    Transfer;           % Performs the transfer-step with a "reception" point of view
    Moments;            % First, compute the moments (rho, rho.v and T). Then, compute velocity and pressure. 

    PlotResults;        % Generate plots 
    CheckStopCriteria;  % Check if termination criterion is met. If yes, exit loop.

end

MakeAMovie;             % Concatenate the saved images to generate an .avi movie (if flag value is set to 1)