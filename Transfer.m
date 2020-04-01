% STEP 2 = TRANSFER
% We adopt the "reception" point of view : we scan each (nx,ny,i) and look for the place where it comes from.
% We define the "boundary of the computational domain" as nx=1 or nx=Nx or ny=1 or ny=Ny

% For mass
for nx=1:Nx
    for ny=1:Ny
        for i=1:Q
            % to fill in
            ixd = nxsf(nx, ny, i);
            iyd = nysf(nx, ny, i);
            id = i_sf(nx, ny, i);
            F_a(nx,ny,i) = Fpost_a(ixd, iyd, id); % to fill in
        end
    end
end
CP='T1'; CheckPoints;                             % Check the construction of F_a

% For temperature, there are two parts
if IsWithHeatTransfer
    for nx=1:Nx
        for ny=1:Ny
            for i=1:Q_t
                ixd = nxst(nx, ny, i);
                iyd = nyst(nx, ny, i);
                id = i_st(nx, ny, i);
                type = SourceNodeType(nx, ny, i);
                switch id
                	case 2
                    	T_w = Tleft_a;
                    	q_w = qinleft;
                	case 3
                    	T_w = Tbottom_a;
                    	q_w = qinbottom;
                    case 4
                    	T_w = Tright_a;
                    	q_w = qinright;
                	case 1
                    	T_w = Ttop_a;
                    	q_w = qintop;
                end
                switch type
                    case 0
                        G_a(nx,ny,i) =  Gpost_a(ixd, iyd, id);
                    case 1
                        G_a(nx,ny,id) = - Gpost_a(ixd, iyd, i) + 2*T_w.*W_t(i);
                    case 2
                        T_w = T_a(nx,ny) + Deltax_d * q_w / (2*lambda_d);
                        G_a(nx,ny,id) = - Gpost_a(ixd, iyd, i) + 2*T_w.*W_t(i);                        
                end
            end
        end
    end
end
