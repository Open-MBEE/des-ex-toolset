classdef InstrumentClass
    % InstrumentClass   Class for storing information about a particular
    % Spacecraft
    % 
    % InstrumentClass Properties:
    %    name - name of the Instrument
    %    Type - type of insturment (viewing type)
    %    azimuth - azimuth of fixed insturment
    %    elevation - elevation of fixed insturment
    %    pointtarget - target for pointing instrument
    %    FOVtype - type of field of view
    %    FOVangle - angular field of view, single value for conic, [vertical, horizontal] for rectangular
    %    targetlist - cell array of target objects
    %
    % InstrumentClass Methods:
    %    InstrumentClass - Constructor of InstrumentClass
   properties
      name {mustBeText} = "undefined" % name of the Instrument
      Type(1,:) char {mustBeMember(Type,{'NadirFixed','Fixed','Targeted','Undefined'})} = 'Undefined' % type of insturment (viewing type)
      azimuth % azimuth of fixed insturment
      elevation % elevation of fixed insturment
      pointtarget % target for pointing instrument
      FOVtype(1,:) char {mustBeMember(FOVtype,{'Conic','Rectangular','Undefined'})} = 'Undefined' % type of field of view
      FOVangle % angular field of view, single value for conic, [vertical, horizontal] for rectangular
      targetlist % cell array of target objects
     


   end
   methods
       function obj = InstrumentClass(name,type,FOVType,FOV,azimuth,elevation,pointtarget)
           %InstrumentClass is the constructor of the
           %InstrumentClass object
           % Inputs:
           %    name : string containting name of the Instrument
           %    type : type of insturment (viewing type)
           %    FOVType : type of field of view (e.g. conical)
           %    FOV : float containing angular feild of view
           %    azimuth :  float containing aziumth offset of instrument
           %    elevation :  float containing elevation offset of
           %    instrument
           %    pointtartget : type of target pointing

           % Outputs:
           %    obj : the InstrumentClass object
            if nargin == 7
                obj.name = name;
                obj.Type = type;
                obj.FOVangle = FOV;
                obj.azimuth = azimuth;
                obj.elevation = elevation;
                obj.pointtarget = pointtarget;
                obj.FOVtype = FOVType;
            end
       end
       
   end
end