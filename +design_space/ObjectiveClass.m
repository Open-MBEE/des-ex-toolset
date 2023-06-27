classdef ObjectiveClass
    % ObjectiveFunctionClass   Class for storing information about a particular
    % objective function
    %
    % ObjectiveFunctionClass Properties:
    %    objfunction - function to be fitted to collection data of
    %    objective function
    %    objplotfunction - function to be used to plot the approximated objective 
    %    values
    %    collectionmatirx - store of all collection point values
    %    structureddata - restructured store of all collection point values
    %    for generating surface functions and plots
    %    approximatesurface - Approximated surface of the objective function
    %    approximatefunction - Approximated function of the objective function
    %
    % ObjectiveFunctionClass Methods:
    %    ObjectiveFunctionClass - Constructor of ObjectiveFunctionClass
    %    addaddressentry - add a new address entry to the ObjectiveClass object
    %    updatecollectionmatrix - Inputs new value into the collection matrix
    %    restructurecollectionmatrix restrucutres the collection matrix
    %    to make it suitable for generating surfaces functions and plots
    %    generatesurface generates the approximate surface fitted to the
    %    system paramter data
    %    plotgraph plots a 3d plot of the system parameter value against
    %    two specified design variables, the other design variables are
    %    taken as their first value collected
    %    
   properties
        csmaddress % csmaddress - numeric vector representing the objective address in the model tree 
        objfunction % function to be fitted to collection data of objective function
        weight % weight of objective, to denote minise or maximise aswell as weighting in summed multi-objective optimisation
        objplotfunction % function to be used to plot the approximated objective values
        collectionmatrix {mustBeNumeric} % store of all collection point values
        structureddata {mustBeNumeric} % restructured store of all collection point values for generating surface functions and plots
        modelelementname {mustBeText} = "undefined" % modelelementname - name of the element of the model from which the design values is generated
        approximatesurface % Approximated surface of the objective function
        approximatefunction % Approximated function of the objective function
        currentvalue % currentvalue - current value of the objective (alternative to the model element name approach)
   end
   methods
       function obj = ObjectiveClass(name,dimensions)
           %ObjectiveFunctionClass is the constructor of the
           %ObjectiveFunctionClass object
           % Inputs:
           %    dimensions : an array of the number of collection points to
           %    be taken in each dimension
           % Outputs:
           %    obj : the ObjectiveFunctionClassobject
            if nargin == 2
                obj.modelelementname = name;
                if size(dimensions,2) ==1
                    obj.collectionmatrix = zeros(dimensions,1);
                else
                    obj.collectionmatrix = zeros(dimensions);
                end
            end
       end
       function obj = addaddressentry(obj,addr)
           %addaddressentry add a new address entry to the 
           %ObjectiveClass object
           % Inputs:
           %    addr : the next of the vector containing the dependant 
           % variable's address in the csm mdoel tree
           % Outputs:
           %    obj : the ObjectiveClass object
            if nargin == 2
                obj.csmaddress = [obj.csmaddress,addr];
            end
       end
       function obj = updatecollectionmatrix(obj,value,position)
           %updatecollectionmatrix Inputs new value into the collection
           % matrix
           % Inputs:
           %    value : the value of the objective function at the
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
           %    positionrecord : number of collection points to be used
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
            obj.approximatesurface = lsqcurvefit(obj.objfunction,startingcoeffs,xinputdata,obj.structureddata);       
       end
       function obj = plotgraph(obj,designvariablelistarray,xdata,designvarchoice,bestsolutionposition)
           %plotgraph plots a 3d plot of the system parameter value against
           %two specified design variables, the other design variables are
           %taken as their first value collected
           % Inputs:
           %    designvariablelistarray : cell array containing all design
           %    variables
           %    xdata : positions of collection points
           %    designvarchoice : choice to two desing vars to plot against
           %    bestsolutionposition : array containting the position of
           %    the best solution in the directions of the two specified
           %    design variables and the objective function
           % Outputs:
           %    plots of the design space
            %generate points at which to plot approximation
            N_plot=100*ones(1,size(designvariablelistarray,2));%number of points to calculate at
            x_plot=linspace(designvariablelistarray{designvarchoice(1)}.Min,designvariablelistarray{designvarchoice(1)}.Max,N_plot(1))';
            y_plot=linspace(designvariablelistarray{designvarchoice(2)}.Min,designvariablelistarray{designvarchoice(2)}.Max,N_plot(2))';
            [x_mesh, y_mesh]=meshgrid(x_plot,y_plot);
            X_plot=[reshape(x_mesh,[],1) reshape(y_mesh,[],1)];
            
            %approximate function at each point
            Z = obj.approximatefunction(X_plot);
            figure
            s = surf(x_plot,y_plot,reshape(Z,N_plot(1),[]),'FaceColor','interp','FaceAlpha',0.7); %surface plot of the results with the estimated parameters
            s.EdgeColor = 'none';
            colorbar 
            hold on

            %add collected data
            plot3(bestsolutionposition(1),bestsolutionposition(2), bestsolutionposition(3) ,'r*')
            text(bestsolutionposition(1),bestsolutionposition(2),bestsolutionposition(3) ,"Best Solution") 
            xlabel(designvariablelistarray{designvarchoice(1)}.modelelementname) 
            ylabel(designvariablelistarray{designvarchoice(2)}.modelelementname)
            zlabel(obj.modelelementname)   
            inspect
            title("Design Space")  
            legend("Approximated Objective Function", "Evaluated Objective Function")
 
       end
   end
end