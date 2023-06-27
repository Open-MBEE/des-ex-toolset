classdef DesignVariableClass
    % DesignVariableClass   Class for storing information about a particular
    % design variable
    %
    % DesignVariableClass Properties:
    %    Type - Type of vairable, i.e. continuous or dicrete
    %    csmaddress - Numeric vector representing the design variables address n the model tree
    %    Max - Max value in the collection range
    %    Min - Min value in the collection range
    %    N - Number of collection points
    %    Counter - Counter for looping through collection points
    %    collectionvector - store of all collection point values
    %    modelelementname - name of hte element of the model from which the
    %    design values is generated
    %
    % DesignVariableClass Methods:
    %    DesignVariableClass - Constructor of DesignVariableClass
    %    addaddressentry - add a new address entry to the DesignVariableClass object


   properties
      Type(1,:) char {mustBeMember(Type,{'Continuous','Discrete','Undefined'})} = 'Undefined' % Type of vairable, i.e. continuous or dicrete
      csmaddress % csmaddress - numeric vector representing the design variables address n the model tree
      Max {mustBeNumeric} % Max - Max value in the collection range
      Min {mustBeNumeric} % Min - Min value in the collection range
      N {mustBeNumeric} % N - Number of collection points
      counter {mustBeNumeric} = 1 % Counter - Counter for looping through collection points
      collectionvector {mustBeNumeric} % collectionvector - store of all collection point values
      modelelementname {mustBeText} = "undefined" % modelelementname - name of the element of the model from which the design values is generated
      currentvalue % currentvalue - current value of the design variable (alternative to the model element name approach)
   end
   methods
       function obj = DesignVariableClass(name,type,parameters)
           %DesignVariableClass is the constructor of the
           %DesignVariableClass object
           % Inputs:
           %    type : a string representing the type of the design
           %    variable to vreat
           %    parameters : an array containing the Max, Min and N values
           %    to generate an array of collection values for the design
           %    variable
           % Outputs:
           %    obj : the DesignVariableClass object
            if nargin == 3
                obj.Type = type;
                obj.csmaddress = [];
                if strcmp(obj.Type,'Continuous')
                    obj.Max = parameters(1);
                    obj.Min = parameters(2);
                    obj.N = parameters(3);
                    obj.collectionvector = linspace(parameters(2),parameters(1),parameters(3));
                    obj.modelelementname = name;
                elseif strcmp(obj.Type,'Discrete')
                   "Not yet Implemented"
                end
            end
       end
       function obj = addaddressentry(obj,addr)
           %addaddressentry add a new address entry to the 
           %DesignVariableClass object
           % Inputs:
           %    addr : the next of the vector containing the design 
           % variable's address in the csm mdoel tree
           % Outputs:
           %    obj : the DesignVariableClass object
            if nargin == 2
                obj.csmaddress = [obj.csmaddress,addr];

            end
       end
   end
end