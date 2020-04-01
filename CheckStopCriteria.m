%% Update counter and check stop criteria  

% Define the stop criterion among :
%     'MaxIterationsNumber'  
%     'ConvergenceBelowThreshold'

StopCriterion = 'MaxIterationsNumber';      

% Update counter
nt = nt + 1;

% Check stop criterion
switch StopCriterion
    case 'MaxIterationsNumber'
        if nt > Nt  
            KeepGoingOn = 0;   
        end        
    case 'ConvergenceBelowThreshold'            % This is not implemented yet but will be inspired from below
        %% Juste après le début de la boucle temporelle, introduire les lignes de code suivantes : 
        %% ===== variables needed for calculation of residuals =====================
        %    usum0 = 0;
        %    vsum0 = 0;
        %    rsum0 = 0;
        %
        %    for i=1:nx
        %        for j=1:ny
        %            usum0 = usum0 + u(i,j);
        %            vsum0 = vsum0 + v(i,j);
        %            rsum0 = rsum0 + rho(i,j);
        %        end
        %    end
        %% Juste à la fin de la boucle temporelle (càd en ligne 2 de ce code), introduire les lignes de code suivantes :
        %% ===== calculate residuals ===============================================
        %    usum = 0;
        %    vsum = 0;
        %    rsum = 0;
        %    
        %    for i=1:nx
        %        for j=1:ny
        %            usum = usum + u(i,j);
        %            vsum = vsum + v(i,j);
        %            rsum = rsum + rho(i,j);
        %        end
        %    end
        %    
        %    % values for normalising residuals
        %    if(t==1)
        %        if(abs(usum-usum0)==0)
        %            unorm = 1;
        %        else
        %            unorm = abs(usum-usum0);
        %        end
        %        
        %        if(abs(vsum-vsum0)==0)
        %            vnorm = 1;
        %        else
        %            vnorm = abs(vsum-vsum0);
        %        end
        %        
        %        if(abs(rsum-rsum0)==0) 
        %            rnorm = 1;
        %        else
        %            rnorm = abs(rsum-rsum0);
        %        end
        %    end
        %    
        %    % calculate residuals
        %    ures = (abs(usum-usum0))/unorm;
        %    vres = (abs(vsum-vsum0))/vnorm;
        %    rres = (abs(rsum-rsum0))/rnorm; 
        %       
        %% ===== output iterations to screen =======================================
        %    if(mod(t,rf)==0)
        %        if(mod(t,100)==0 || t==1)
        %        fprintf('iteration---u residual-----v residual-----rho residual\n'); 
        %        end
        %        fprintf('%8d   %12.5e   %12.5e   %12.5e\n',t,ures,vres,rres);
        %    end
        %    
        %    % check if solution has converged
        %    if(ures<eps && vres<eps && rres<eps)
        %        break;
        %    end
end