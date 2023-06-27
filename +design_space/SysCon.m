function [c,ceq] = SysCon(x)
    global approximationtype
    global constraintValues

    % process constraint values depending on max or min constraints

    if approximationtype == "POLYNOMIAL"
        global Gapproxsurfacelist
        global Gdependantvariablelist

    
        for i = 1:size(constraintValues,2)
            % process constraint values depending on max or min constraints
            if isnan(constraintValues(i,1))
                constval = -constraintValues(i,2);
            end
            if isnan(constraintValues(i,2))
                constval = constraintValues(i,1);
            end
            c(i) =  Gdependantvariablelist{i}.parameterfunction(Gapproxsurfacelist{i},transpose(x)) + constval;   
        end
    elseif approximationtype == "RBF"
        global GdepvarX_c
        global GdepvarRBFWeights
        global Gdepvark_i
        global Gdepvarbasisfunction 
        
        for i = 1:size(constraintValues,1)
            % process constraint values depending on max or min constraints
            if isnan(constraintValues(i,2))
                constval = constraintValues(i,1);
                c(i) =  -design_space.sim_rbf(GdepvarX_c{i},x,GdepvarRBFWeights{i},Gdepvark_i{i},Gdepvarbasisfunction{i}) + constval;
                
            end
            if isnan(constraintValues(i,1))
                constval = -constraintValues(i,2);
                c(i) =  design_space.sim_rbf(GdepvarX_c{i},x,GdepvarRBFWeights{i},Gdepvark_i{i},Gdepvarbasisfunction{i}) + constval;
            end
        end
    end    
    ceq = [];   % Compute nonlinear equalities at x.      
end