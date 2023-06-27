classdef SystemParameterClass
    % SystemParameterClass   Class for storing information about a particular
    % system parameter
    %
    % SystemParameterClass Properties:
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
    % SystemParameterClass Methods:
    %    SystemParameterClass - Constructor of SystemParameterClass
    %    restructurecollectionmatrix - restrucutres the collection matrix to make it suitable for generating surfaces functions and plots
    %    
   properties
        parameterfunction % function to be fitted to collection data of system parameter
        parameterplotfunction % function to be used to plot the aproxximated values of the system parameter
        collectionmatrix {mustBeNumeric} % store of all collection point values
        structureddata {mustBeNumeric} % restructured store of all collection point values for generating surface functions and plots
        approximatesurface % Approximated surface of the system parameter
        approximatefunction % Approximated function of the system parameter
        modelelementname {mustBeText} = "undefined" % modelelementname - name of the element of the model from which the design values is generated
   end
   methods
       function obj = SystemParameterClass(name,dimensions)
           %SystemParameterClass is the constructor of the
           %SystemParameterClass object
           % Inputs:
           %    name : name of the element of the model from which the design values is generated
           %    dimensions : an array of the number of collection points to
           %    be taken in each dimension
           % Outputs:
           %    obj : the SystemParameterClass object
            if nargin == 2
                obj.collectionmatrix = zeros(dimensions);
                obj.modelelementname = name;
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
       function obj = restructurecollectionmatrix(obj,nocollectionpoints)
           %restructurecollectionmatrix restrucutres the collection matrix
           %to make it suitable for generating surfaces functions and plots
           % Inputs:
           %    nocollectionpoints : the number of collection points used
           % Outputs:
           %    obj.structureddata : the resturtured collection matrix

           obj.structureddata = reshape(transpose(obj.collectionmatrix),1,nocollectionpoints);
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
       function obj = plotgraph(obj,designvariablelist,xdata,designvar1,designvar2)
           %plotgraph plots a 3d plot of the system parameter value against
           %two specified design variables, the other design variables are
           %taken as their first value collected
           % Inputs:
           %    designvariablelist : cell array containing all design
           %    variables
           %    xdata : positions of collection points
           %    designvar1 : string containing the name of the first design
           %    variable to be plotted against
           %    designvar2 : string containing the name of the second design
           %    variable to be plotted against
           % Outputs:
           %        
            [X,Y] = meshgrid(designvariablelist{1}.collectionvector,designvariablelist{2}.collectionvector);
            Z = obj.parameterplotfunction(obj.approximatesurface,X,Y);
            figure
            s = surf(X,Y,Z,'FaceColor','interp','FaceAlpha',0.7); %surface plot of the results with the estimated parameters
            s.EdgeColor = 'none';
            colorbar 
            hold on
            plot3(xdata(1,:),xdata(2,:),obj.structureddata,'o') 
            xlabel("Instrument Length (m)") 
            ylabel("Instrument Diameter (kg)")
            zlabel("Satellite Mass (m)") 
            title("Mass Approximation")
            legend("Approximated Mass", "Evaultated Mass")

       end
   end
end