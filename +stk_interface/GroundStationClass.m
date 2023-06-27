classdef GroundStationClass
    % GroundStationClass Class for storing information about a particular
    % Ground Station
    % 
    % GroundStationClass Properties:
    %    name - name of the ground station
    %    latitude {mustBeNumeric} - float containing latitude of ground station
    %    longitude {mustBeNumeric} - float containing longitude of ground station
    %    altitude {mustBeNumeric} - float containing altitude of ground station 
    %    access - access object
    %    accessstarttimes - start times of accesses
    %    accessstarttimesstr - start times of accesses in string
    %    accessstarttimesnum - start times of accesses in number form
    %    accessstoptimes - stop times of accesses
    %    accessstoptimesstr - stop times of accesses in string
    %    accessstoptimesnum - stop times of accesses in number form
    %    accesssdurations - durations of accesses
    %    accesssdurationsstr - durations of accesses in string
    %
    % GroundStationClass Methods:
    %    GroundStationClass - Constructor of GroundStationClass
   properties
      name {mustBeText} = "undefined" % name of the ground station
      latitude {mustBeNumeric} % float containing latitude of ground station
      longitude {mustBeNumeric} % float containing longitude of ground station
      altitude {mustBeNumeric} % float containing altitude of ground station 
      access % access object
      accessstarttimes % start times of accesses
      accessstarttimesstr % start times of accesses in string
      accessstarttimesnum % start times of accesses in number form
      accessstoptimes % stop times of accesses
      accessstoptimesstr % stop times of accesses in string
      accessstoptimesnum % stop times of accesses in number form
      accesssdurations % durations of accesses
      accesssdurationsstr % durations of accesses in string


   end
   methods
       function obj = GroundStationClass(name,latitude,longitude,altitude)
           %GroundStationClass is the constructor of the
           %GroundStationClass object
           % Inputs:
           %    name : string containting name of the ground station
           %    latitude : float containing latitude of ground station
           %    longitude : float containing longitude of ground station
           %    altitude : float containing altitude of ground station
           % Outputs:
           %    obj : the GroundStationClass object
            if nargin == 4
                obj.name = name;
                obj.latitude = latitude;
                obj.longitude = longitude;
                obj.altitude = altitude;
            end
       end
   end
end