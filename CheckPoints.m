if strcmp(Scenario,'Debugging') && (~exist('nt','var') || (nt==1))
    
    switch CP
        
        case 'DS1'
            ScriptName = 'DiscretizationScheme.m';
            CheckedVariable = 'W, opp, ciax and ciay ';
            Computed = floor(dot(W,[1 2 3 4 5 6 7 8 9]) + dot(opp,[5 4 3 2 1 6 7 8 9]) + dot(ciax,[ 1 3 2 6 5 4 8 7 9]) + dot(ciay,[ 2 1 3 6 5 4 8 7 9]));
            Expected = floor(1505/6);
        
        case 'DS2'
            ScriptName = 'DiscretizationScheme.m';
            CheckedVariable = 'W_t, opp_t, ciax_t and ciay_t ';
            Computed = floor(dot(W_t,[1 3 4 6 8]) + dot(opp_t,[5 4 3 7 8]) + dot(ciax_t,[6 5 4 7 9]) + dot(ciay_t,[ 2 1 3 6 5]));
            Expected = 90;
        
        case 'MD1'
            ScriptName = 'MakeDimensionless.m';
            CheckedVariable = 'Reynols number';
            Computed = floor(Re_r*1e4)/1e4;
            Expected = 134.8356;
            
        case 'MD2'
            ScriptName = 'MakeDimensionless.m';
            CheckedVariable = 'Rayleigh number';
            Computed = floor(Ra_r*1e4)/1e4;
            Expected = 30.2474;
            
        case 'MD3'
            ScriptName = 'MakeDimensionless.m';
            CheckedVariable = 'Viscosity_a';
            Computed = floor(1e6*Viscosity_a)/1e6;
            Expected = 0.005138;
            
        case 'P1'
            ScriptName = 'Preprocessing.m';
            CheckedVariable = 'F_NodeType';
            Computed = rot90(F_NodeType);
            Expected = [1 3 3 3 3 1;1 0 0 0 0 1;1 0 0 0 0 1;1 0 0 0 0 1;1 3 3 3 3 1];
            
        case 'P2'
            ScriptName = 'Preprocessing.m';
            CheckedVariable = 'nxsf';
            Computed = rot90(nxsf(:,:,8));
            Expected = [1 1 2 3;1 1 2 3;1 1 2 3];
            
        case 'P3'
            ScriptName = 'Preprocessing.m';
            CheckedVariable = 'nysf';
            Computed = rot90(nysf(:,:,3));
            Expected = [3 3 3 3;2 2 2 2;1 1 1 1];
            
        case 'P4'
            ScriptName = 'Preprocessing.m';
            CheckedVariable = 'i_sf';
            Computed = rot90(i_sf(:,:,5));
            Expected = [7 5 5 5;7 5 5 5;7 5 5 5];
            
        case 'I1'
            ScriptName = 'Initialize.m';
            CheckedVariable = 'Feq_a';
            Computed = floor(1e13*Feq_a(:,:,1))/1e13;
            Expected = 5.53e-11*ones(4,3);
            
        case 'I2'
            ScriptName = 'Initialize.m';
            CheckedVariable = 'Geq_a';
            Computed = floor(1e4*Geq_a(:,:,1))/1e4;
            Expected = 0.0833*ones(4,3);
            
        case 'C1'
            ScriptName = 'Collision.m';
            CheckedVariable = 'Fpost_a';
            Computed = floor(1e13*Fpost_a(:,:,9))/1e13;
            Expected = 1e-13*[2212 2212 2212; 2212 2212 2212;2212 2212 2212;2212 2212 2212];
            
        case 'T1'
            ScriptName = 'Transfer.m';
            CheckedVariable = 'F_a';
            Computed = floor(1e14*F_a(:,:,2))/1e14;
            Expected = 0.5531e-10*ones(4,3);
            
        case 'M1'
            ScriptName = 'Moments.m';
            CheckedVariable = 'rho_a';
            Computed = floor(1e13*rho_a(:,:))/1e13;
            Expected = 0.4978e-9*ones(4,3);

    end
    
    %% END OF SPECIFIC INFORMATIONS
    
    if Computed == Expected
        disp(['Check-Point ' CP ' in "' ScriptName '" concerning : ' CheckedVariable '... Status : PASS']);
    else
        disp(['Check-Point ' CP ' in "' ScriptName '" concerning : ' CheckedVariable '... Status : FAIL']);
        disp('The following computed value :');
        Computed
        disp('should be equal to : ');
        Expected
    end
    disp('======================================================');
end