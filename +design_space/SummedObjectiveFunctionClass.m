classdef SummedObjectiveFunctionClass
    % SummedObjectiveFunctionClass   Class for storing information about a particular
    % objective function
    %
    % SummedObjectiveFunctionClass Properties:
    %    approximatefunction - Approximated function of the summed objective function
    %    collecteddata - colected data matirx of weighted objective summation
    %
    % ObjectiveFunctionClass Methods:
    %    SummedObjectiveFunctionClass - Constructor of SummedObjectiveFunctionClass
    %    plotgraph - plots a 3d plot of the system parameter value against two specified design variables, the other design variables are
    %    taken as their first value collected
   properties
        approximatefunction % Approximated function of the summed objective function
        collecteddata %colected data matirx of weighted objective summation
   end
   methods
       function obj = SummedObjectiveFunctionClass(approximatefunctionin)
           %SummedObjectiveFunctionClass is the constructor of the
           %SummedObjectiveFunctionClass object
           % Inputs:
           %    approximatefunction : functionhandle of aprroximation function
           %    (i.e. the approximation approach)
           % Outputs:
           %    obj : the SummedObjectiveFunctionClass object
            if nargin == 1
                obj.approximatefunction = approximatefunctionin;
            end
       end
       function obj = plotgraph(obj,designvariablelistarray,XData,designvarchoice,objectivelistarray,optimisationposition,othervals,constraintarray,previousdatalist)
           %plotgraph plots a 3d plot of the system parameter value against
           %two specified design variables, the other design variables are
           %taken as their first value collected
           % Inputs:
           %    designvariablelistarray : cell array containing all design
           %    variables
           %    xdata : positions of collection points
           %    designvarchoice : choice to two desigm vars to plot against
           %    objectivelistarray : array of values individual objectives
           %    optimisationposition : array containing the position of
           %    the best solution in the directions of the two specified
           %    design variables and the objective function
           %    othervals : values to set remaining design variables
           %    constraintarray : array of constraint coefficients
           %    previousdatalist : Array of previous design space data
           % Outputs:
           %    plots of the design space
           %collected data prosessing
            figure
            % calculate the weighted collected data and sum across all
            % objectives
            obj.collecteddata = transpose(zeros(size(objectivelistarray{1}.structureddata)));
            for i = 1:size(objectivelistarray,2)
                obj.collecteddata = obj.collecteddata + transpose(objectivelistarray{i}.structureddata);
            end
            try obj.approximatefunction()

            catch ME
                if strcmp(ME.message,'Not enough input arguments.')
                    %generate points at which to plot approximation
                    N_plot=200*ones(1,size(designvariablelistarray,2));%number of points to calculate at
                    x_plot=linspace(designvariablelistarray{designvarchoice(1)}.Min,designvariablelistarray{designvarchoice(1)}.Max,N_plot(1))';
                    y_plot=linspace(designvariablelistarray{designvarchoice(2)}.Min,designvariablelistarray{designvarchoice(2)}.Max,N_plot(2))';
                    [x_mesh, y_mesh]=meshgrid(x_plot,y_plot);
                    
                    % need to determine values of other desing variables not inlcuded in plot
                    X_plot = zeros(N_plot(1)*N_plot(2),size(designvariablelistarray,2));
                    for i=1:size(designvariablelistarray,2)
                        if i == designvarchoice(1) 
                            X_plot(:,i) =  reshape(x_mesh,[],1);
                        elseif i == designvarchoice(2)
                            X_plot(:,i) =  reshape(y_mesh,[],1);
                        else
                            X_plot(:,i) = othervals(i)*ones(N_plot(1)*N_plot(2),1);
                        end
                    end
                    
                    %approximate function at each point
                    Z = obj.approximatefunction(X_plot);                    
                    constraintmap = zeros(size(Z));
                    for i = 1:size(Z,1)
                        pointconsts = design_space.SysCon(X_plot(i,:));
                        if size(constraintarray,1)==1
                            jlimit = 1;
                        else
                            jlimit = size(constraintarray,2);
                        end
                        for j = 1:jlimit
                            if pointconsts(j) > 0
                                constraintmap(i) = 1;
                            end
                        end
                    end

                    s = surf(x_plot,y_plot,reshape(Z,N_plot(1),[]),reshape( ...
                        constraintmap,N_plot(1),[])); %surface plot of the 
                    % results with the estimated parameters including 
                    % colouring for feasible region
                    s.EdgeColor = 'none';
                    mycolors = [0 1 0; 1 1 0;1 0 0];
                    colormap(mycolors); 
                    hold on
                end
            end
            % plot collected data
            if isnan(XData(1,1)) == false
                noplotpoints =  designvariablelistarray{designvarchoice(1)}.N * designvariablelistarray{designvarchoice(2)}.N;
                stepsize = size(XData,2);
                % cycle through point data and select relevant plot points
                xdataplot = zeros(2,noplotpoints);
                collecteddataplot = zeros(1,noplotpoints);
                k = 1;
                for i = 1:size(XData,2)
                    % check values of other not plotted deisgn variables
                    plotpoint = false;
                    for j = 1:size(othervals,2)
                        if j ~= designvarchoice(1) && j~= designvarchoice(2)
                            if XData(j,i) == othervals(j) 
                                plotpoint = true;
                            else
                                plotpoint = false;
                                break
                            end
                        elseif  size(XData,1) == 2
                            % for case when only two design variables exist
                            plotpoint = true;
                        end
                    end
                    if plotpoint == true                   
                        xdataplot(1,k) = XData(designvarchoice(1),i);
                        xdataplot(2,k) = XData(designvarchoice(2),i);
                        collecteddataplot(k) = obj.collecteddata(i);
                        k = k + 1;
                    end
                end
    
                plot3(xdataplot(1,:),xdataplot(2,:),collecteddataplot,'o')
                hold on
            end

            % plot optimisaiotn result (if it exists)
            if size(optimisationposition,1) > 0 
                hold on 
                bestsolutionobjval = obj.approximatefunction(optimisationposition);
                disp('Surrogate best solution fitness:')
                disp(bestsolutionobjval)
                plot3(optimisationposition(designvarchoice(1)),optimisationposition(designvarchoice(2)), bestsolutionobjval ,'r*')
                text(optimisationposition(designvarchoice(1)),optimisationposition(designvarchoice(2)), bestsolutionobjval ,"Best Solution") 
            end

            % finally plot previous data
            for m = 1:size(previousdatalist,2)
                
                if isnan(previousdatalist{m}.xdata(1,1)) == false
                    noplotpoints =  previousdatalist{m}.designvariablelist{designvarchoice(1)}.N * previousdatalist{m}.designvariablelist{designvarchoice(2)}.N;
            
                    % cycle through point data and select relevant plot points
                    xdataplot = zeros(2,noplotpoints);
                    structureddataplot = zeros(1,noplotpoints);
                    k = 1;
                    for i = 1:size(previousdatalist{m}.xdata,2)
                        % check values of other not plotted deisgn variables
                        plotpoint = false;
                        for j = 1:size(othervals,2)
                            if j~= designvarchoice(1) && j~= designvarchoice(2)
                                if previousdatalist{m}.xdata(j,i) == othervals(j) 
                                    plotpoint = true;
                                else
                                    plotpoint = false;
                                    break
                                end
                            elseif  size(previousdatalist{m}.xdata,1) == 2
                                % for case when only two design variables exist
                                plotpoint = true;
                            end
    
                        end
                        if plotpoint == true                   
                            xdataplot(1,k) = previousdatalist{m}.xdata(designvarchoice(1),i);
                            xdataplot(2,k) = previousdatalist{m}.xdata(designvarchoice(2),i);
                            structureddataplot(k) = previousdatalist{m}.objectiveOBJ.collecteddata(i);
                            k = k + 1;
                        end
                    end
                    plot3(xdataplot(1,:),xdataplot(2,:),structureddataplot,'x')
                    hold on
                end
            end
            
            xlabel(designvariablelistarray{designvarchoice(1)}.modelelementname) 
            ylabel(designvariablelistarray{designvarchoice(2)}.modelelementname)
            inspect
            zlabel("Objective Function Value")    
            title("Design Space")  
            legend("Approximated Objective Function", "Evaluated Objective Function","Best Solution","Previously Collected Design Points")
            %xlim([designvariablelistarray{designvarchoice(1)}.Min,designvariablelistarray{designvarchoice(1)}.Max])
            %ylim([designvariablelistarray{designvarchoice(2)}.Min,designvariablelistarray{designvarchoice(2)}.Max])
 
       end
   end
end