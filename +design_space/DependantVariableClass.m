classdef DependantVariableClass
    % DependantVariableClass   Class for storing information about a particular
    % system parameter with related constraints
    %
    % DependantVariableClass Properties:
    %    parameterfunction - function to be fitted to collection data of
    %    system parameter
    %    parameterplotfunction - function to be used to plot the aproxximated 
    %    values of the system parameter
    %    collectionmatrix - store of all collection point values
    %    structureddata - restructured store of all collection point values
    %    for generating surface functions and plots
    %    approximatesurface - Approximated surface of the system parameter
    %    approximatefunction - Approximated function of the system parameter
    %    modelelementname - name of hte element of the model from which the
    %    design values is generated
    %
    % DependantVariableClass Methods:
    %    DependantVariableClass - Constructor of DependantVariableClass
    %    addaddressentry - add a new address entry to the DependantVariableClass object
    %    updatecollectionmatrix - Inputs new value into the collection
    %    matrix
    %    generatesurface - generates the approximate surface fitted to the system paramter data
    %    restructurecollectionmatrix - restrucutres the collection matrix to make it suitable for generating surfaces functions and plots
    %    plotgraph - plots a 3d plot of the system parameter value against two specified design variables, the other design variables are taken as their first value collected
    %    
   properties
        csmaddress % csmaddress - numeric vector representing the dependant variables address in the model tree
        parameterfunction % function to be fitted to collection data of system parameter
        parameterplotfunction % function to be used to plot the aproxximated values of the system parameter
        collectionmatrix {mustBeNumeric} % store of all collection point values
        structureddata {mustBeNumeric} % restructured store of all collection point values for generating surface functions and plots
        approximatesurface % Approximated surface of the system parameter
        approximatefunction % Approximated function of the system parameter
        modelelementname {mustBeText} = "undefined" % modelelementname - name of the element of the model from which the design values is generated
        currentvalue % currentvalue - current value of the system parameter (alternative to the model element name approach)
        
   end
   methods
       function obj = DependantVariableClass(name,dimensions)
           %DependantVariableClass is the constructor of the
           %DependantVariableClass object
           % Inputs:
           %    name : name of the element of the model from which the design values is generated
           %    dimensions : an array of the number of collection points to
           %    be taken in each dimension
           % Outputs:
           %    obj : the DependantVariableClass object
            if nargin == 2
                if size(dimensions,2) ==1
                    obj.collectionmatrix = zeros(dimensions,1);
                else
                    obj.collectionmatrix = zeros(dimensions);
                end
                obj.modelelementname = name;
            end
       end
       function obj = addaddressentry(obj,addr)
           %addaddressentry add a new address entry to the 
           %DependantVariableClass object
           % Inputs:
           %    addr : the next of the vector containing the dependant 
           % variable's address in the csm mdoel tree
           % Outputs:
           %    obj : the DependantVariableClass object
            if nargin == 2
                obj.csmaddress = [obj.csmaddress,addr];

            end
       end
      function obj = updatecollectionmatrix(obj,value,position)
           %updatecollectionmatrix Inputs new value into the collection
           %matrix
           % Inputs:
           %    value : the value of the system parameter at the
           %    collection point
           %    position : the position in the collection matirx in which
           %    to insert the value
           % Outputs:
           %    obj.collectionmatrix : the updated collection matrix
             

           position = num2cell(position);
           obj.collectionmatrix(sub2ind(size(obj.collectionmatrix),position{:})) = value;       
       end
       function obj = restructurecollectionmatrix(obj,positionrecord)
           %restructurecollectionmatrix restrucutres the collection matrix
           %to make it suitable for generating surfaces functions and plots
           % Inputs:
           %    nocollectionpoints : the number of collection points used
           % Outputs:
           %    obj.structureddata : the resturtured collection matrix

           for i = 1:size(positionrecord,1)
                currentposition = num2cell(positionrecord(i,:));
                obj.structureddata(i) = obj.collectionmatrix(sub2ind(size(obj.collectionmatrix),currentposition{:}));
           end
       end
       function obj = generatesurface(obj,startingcoeffs,xinputdata)
           %generatesurface generates the approximate surface fitted to the
           %system paramter data
           % Inputs:
           %    startingcoeffs : initial coefficient values to put into
           %    fitting function
           %    xinputdata : position data of collection data
           % Outputs:
           %    obj.approximatesurface : the approximate surface
           %    coefficients
            obj.approximatesurface = lsqcurvefit(obj.parameterfunction,startingcoeffs,xinputdata,obj.structureddata);       
       end
       function obj = plotgraph(obj,designvariablelistarray,XData,designvarchoice,othervals,constraintarray,previousdatalist)
           %plotgraph plots a 3d plot of the system parameter value against
           %two specified design variables, the other design variables are
           %taken as their first value collected
           % Inputs:
           %    designvariablelistarray : cell array containing all design
           %    variables
           %    XData : positions of collection points
           %    designvarchoice : list containing the ids of the design
           %    variable against which to plot
           %    othervals : values to set remaining design variables
           %    constraintarray : array of constraint coefficients
           %    previousdatalist : Array of previous design space data
           % Outputs:
           %    plots of the design space
           figure
           try obj.approximatefunction()

            catch ME
                if strcmp(ME.message,'Not enough input arguments.')
                    % generate points at which to plot approximation
                    N_plot=200*ones(1,size(designvariablelistarray,2));
                    %number of points to calculate at
                    x_plot=linspace(designvariablelistarray{ ...
                        designvarchoice(1)}.Min,designvariablelistarray{ ...
                        designvarchoice(1)}.Max,N_plot(1))';
                    y_plot=linspace(designvariablelistarray{ ...
                        designvarchoice(2)}.Min,designvariablelistarray{ ...
                        designvarchoice(2)}.Max,N_plot(2))';
                    [x_mesh, y_mesh]=meshgrid(x_plot,y_plot);
        
        
                    % need to determine values of other design variables 
                    % not inlcuded in plot
                    X_plot = zeros(N_plot(1)*N_plot(2),size( ...
                        designvariablelistarray,2));
                    for i=1:size(designvariablelistarray,2)
                        if i == designvarchoice(1) 
                            X_plot(:,i) =  reshape(x_mesh,[],1);
                        elseif i == designvarchoice(2)
                            X_plot(:,i) =  reshape(y_mesh,[],1);
                        else
                            X_plot(:,i) = othervals(i)*ones( ...
                                N_plot(1)*N_plot(2),1);
                        end
                    end            
        
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
                                constraintmap(i) = 1; % point is outside 
                                %feasible region
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

                % cycle through point data and select relevant plot points
                xdataplot = zeros(2,noplotpoints);
                structureddataplot = zeros(1,noplotpoints);
                k = 1;
                for i = 1:size(XData,2)
                    % check values of other not plotted deisgn variables
                    plotpoint = false;
                    for j = 1:size(othervals,2)
                        if j~= designvarchoice(1) && j~= designvarchoice(2)
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
                        structureddataplot(k) = obj.structureddata(i);
                        k = k + 1;
                    end
                end
                disp(structureddataplot)
                plot3(xdataplot(1,:),xdataplot(2,:),structureddataplot,'o') 
            end

            %plot previous data
            for m = 1:size(previousdatalist,2)
                %firslty find where the current dependant variable is in
                %the previous data
                depid= [];
                for i=1:size(previousdatalist{m}.dependantvariablelist,2)
                    if previousdatalist{m}.dependantvariablelist{i}.modelelementname == obj.modelelementname
                        depid = i;
                    end
                end
                
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
                            structureddataplot(k) = previousdatalist{m}.dependantvariablelist{depid}.structureddata(i);
                            k = k + 1;
                        end
                    end
                    disp(structureddataplot)
                    plot3(xdataplot(1,:),xdataplot(2,:),structureddataplot,'x') 
                end
            end


            
            xlabel(designvariablelistarray{designvarchoice(1)}.modelelementname) 
            ylabel(designvariablelistarray{designvarchoice(2)}.modelelementname)
            zlabel(obj.modelelementname) 
            inspect
            title("Dependant Variable Profile")
            legend("Approximated Dependant Variable", "Evaluated Dependant Variable","Previously Collected Design Points")

       end
   end
end