% STEP 1 = COLLISIONS

v2_a = vx_a(:,:).^2 + vy_a(:,:).^2;                                           % Intermediate quantity : squared norm of v_a=(vx_a vy_a)

% For mass
for i=1:Q
    % to fill in
    civ = ciax(i)*vx_a(:,:) + ciay(i)*vy_a(:,:);% to fill in
    Feq_a(:,:,i) = rho_a(:,:).*W(i).* (1 + k*civ + (k^2/2) * (civ.^2) - (k/2) * v2_a);
    Fpost_a(:,:,i) = F_a(:,:,i) - (F_a(:,:,i) - Feq_a(:,:,i)) / Tauf_a; % Post-collision distribution for mass
end

CP='C1'; CheckPoints;                                                         % Check the construction of Fpost_a (after first iteration only)

% For temperature
if IsWithHeatTransfer
    for i=1:Q_t
        % to fill in
        civ = ciax_t(i)*vx_a(:,:) + ciay_t(i)*vy_a(:,:);% to fill in
        Geq_a(:,:,i) = T_a(:,:).*W_t(i).* (1 + k_t*civ + (k_t^2/2) * (civ.^2) - (k_t/2) * v2_a);
        Gpost_a(:,:,i) = G_a(:,:,i) - (G_a(:,:,i) - Geq_a(:,:,i)) / Taug_a;      % Post-collision distribution for temperature
    end
end
