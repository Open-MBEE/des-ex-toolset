classdef SubTargetClass
    % SubTargetClass   Class for storing information about a particular
    % SubTarget - e.g area of a target with a specific data generation rate
    % 
    % SubTargetClass Properties:
    %     name - name of the target
    %     datagenerationrate - float describing the data generation rate associated with this target sub area
    %     shapefilepath - string containing path shapefile with corresponding target area
    %     shapefilelats - vector containing latitudes of points defined in shapefile
    %     shapefilelons - vector containing longitudes of points defined in shapefile
    %     accesstimesteps - vector containing time steps spent in target access
    %     accessstartlist - vector containing access start times
    %     accessstoplist - vector containing access stop times
    %     access - access object
    %     accessstarttimes - start times of accesses
    %     accessstarttimesstr - start times of accesses in string
    %     accessstarttimesnum - start times of accesses in number
    %     accessstoptimes - stop times of accesses
    %     accessstoptimesstr - stop times of accesses in string
    %     accessstoptimesnum - stop times of accesses in number
    %     accesssdurations - durations of accesses
    %     accesssdurationsstr - durations of accesses in string
    %
    % SubTargetClass Methods:
    %    SubTargetClass - Constructor of SubTargetClass
   properties
      name {mustBeText} = "undefined" % name of the target
      datagenerationrate {mustBeNumeric} % float describing the data generation rate associated with this target sub area
      shapefilepath % string containing path shapefile with corresponding target area
      shapefilelats {mustBeNumeric} % vector containing latitudes of points defined in shapefile
      shapefilelons {mustBeNumeric} % vector containing longitudes of points defined in shapefile
      accesstimesteps {mustBeNumeric} % vector containing time steps spent in target access
      accessstartlist {mustBeNumeric} % vector containing access start times
      accessstoplist {mustBeNumeric} % vector containing access stop times
      access % access object
      accessstarttimes = {} % start times of accesses
      accessstarttimesstr % start times of accesses in string
      accessstarttimesnum % start times of accesses in number
      accessstoptimes = {} % stop times of accesses
      accessstoptimesstr % stop times of accesses in string
      accessstoptimesnum % stop times of accesses in number
      accesssdurations % durations of accesses
      accesssdurationsstr % durations of accesses in string
   end
      
   methods
       function obj = SubTargetClass(name,datarate,shapefilepath)
           %TargetClass is the constructor of the
           %TargetClass object
           % Inputs:
           %    name : string containting name of the target
           %    datarate : rate of data collection for the subtarget
           %    shapefilepath : path to shapefile containing target
           %    coordinates
           % Outputs:
           %    obj : the SubTargetClass object
            if nargin == 3 % old constructor for earth area target
                obj.name = name;
                obj.datagenerationrate = datarate;
                obj.shapefilepath = shapefilepath;
            end
       end     

   end
end