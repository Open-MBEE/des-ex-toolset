classdef RequirementClass
    % RequirementClass   Class for storing information about a particular
    % requirement
    % 
    % RequirementClassClass Properties:
    %    Type - Type of requirement
    %    Max - Max value allowed by requirement
    %    Min - Min value allowed by requirement
    %
    % RequirementClass Methods:
    %    RequirementClass - Constructor of RequirementClass
   properties
      Type(1,:) char {mustBeMember(Type,{'Max','Min','Range','Undefined'})} = 'Undefined' % Type of requirement
      Max {mustBeNumeric} % Max value allowed by requirement
      Min {mustBeNumeric} % Min value allowed by requirement


   end
   methods
       function obj = RequirementClass(type,limits)
           %RequirementClass is the constructor of the
           %RequirementClass object
           % Inputs:
           %    type : a string representing the type of the design
           %    variable to vreat
           %    limits : an array containing the Max and/or Min values
           %    allowed by the requirement
           % Outputs:
           %    obj : the RequirementClass object
            if nargin == 2
                obj.Type = type;
                if strcmp(obj.Type,'Max')
                    obj.Max = limits;
                elseif strcmp(obj.Type,'Min')
                   obj.Min = limits;
                elseif strcmp(obj.Type,'Range')
                   obj.Max = limits(1);
                   obj.Min = limits(2);
                else
                    "incorrect arguments provided"
                end
            end
       end
   end
end