classdef TargetClass
    % TargetClass   Class for storing information about a particular
    % Target
    % 
    % TargetClass Properties:
    %    name - name of the target
    %    type - type of target
    %    stktype - stk version of the target type for pointing
    %    solarzenithanglemax - float containging minium value of sun zenith angle for imaging is null if no constraint applied
    %    sunlightconstraint - boolean describing whether or not to apply a sunlight constraint to accesses to the target
    %    datagenerationrate - float describing the data generation rate associated with this target
    %    subtargetlist - cell array ofsub target objects
    %    shapefilepath - string containing path shapefile with corresponding target area
    %    shapefilelats - vector containing latitudes of points defined in shapefile
    %    shapefilelons - vector containing longitudes of points defined in shapefile
    %    shapefilenames - vector containing names of points defined in shapefile
    %    shapefilex - vector containing x coordinates of points defined in shapefile
    %    shapefiley - vector containing y coordinates of points defined in shapefile
    %    shapefilez - vector containing z coordinates of points defined in shapefile
    %    targetMassData - vector containing target mass area
    %    targetmap - matrix of values denoting inside and outside of target area
    %    R - geographic raster reference object
    %    xdata - vector containing x ordinates of points distrubuted across target area
    %    ydata - vector containing y ordinates of points distrubuted across target area
    %    zdata - vector containing z ordinates of points distrubuted across target area
    %    latitude -vector containing latitudes of points distrubuted across target area
    %    longitude - vector containing longitudes of points distrubuted across target area
    %    altitude - vector containing altitudes of points distrubuted across target area
    %    accesstimesteps-vector containing time steps spent in target access
    %    accessstartlist - vector containing access start times
    %    accessstoplist - vector containing access stop times
    %    access - access object
    %    subareaaccesssequence - squence of subareas accessed
    %    accessstarttimes - start times of accesses
    %    accessstarttimesstr - start times of accesses in string
    %    accessstarttimesnum - start times of accesses in number
    %    accessstoptimes - stop times of accesses
    %    accessstoptimesstr - stop times of accesses in string
    %    accessstoptimesnum - stop times of accesses in number
    %    accesssdurations - durations of accesses
    %    accesssdurationsstr - durations of accesses in string
    %    FoVaccesstimesteps - vector containing time steps spent in target access accounting for FoV
    %    FoVaccessstartlist - vector containing access start times accounting for FoV
    %    FoVaccessstoplist - vector containing access stop times accounting for FoV
    %    FoVaccess - access object accounting for FoV
    %    FoVaccessstarttimes - start times of accesses accounting for FoV
    %    FoVaccessstarttimesstr - start times of accesses in string accounting for FoV
    %    FoVaccessstarttimesnum - start times of accesses in number accounting for FoV
    %    FoVaccessstoptimes - stop times of accesses accounting for FoV
    %    FoVaccessstoptimesstr - stop times of accesses in string accounting for FoV
    %    FoVaccessstoptimesnum - stop times of accesses in number accounting for FoV
    %    FoVaccesssdurations - durations of accesses accounting for FoV
    %    FoVaccesssdurationsstr - durations of accesses in string accounting for FoV 
    %
    % TargetClass Methods:
    %    TargetClass - Constructor of TargetClass
    %    computeaccestimes - calculates accesstimes to targed in simplified orbit model
    %    convertcart2geo - convertes cartesian coordinates to geodetic
    %    
   properties
      name {mustBeText} = "undefined" % name of the target
      type(1,:) char {mustBeMember(type,{'AreaTarget','MultiPointTarget','Earth','Lunar','Solar','Undefined'})} = 'Undefined' % type of target
      stktype % stk version of the target type for pointing
      solarzenithanglemax = 'null'  % float containging minium value of sun zenith angle for imaging is null if no constraint applied
      sunlightconstraint % boolean describing whether or not to apply a sunlight constraint to accesses to the target
      datagenerationrate {mustBeNumeric} % float describing the data generation rate associated with this target
      subtargetlist % cell array ofsub target objects
      shapefilepath % string containing path shapefile with corresponding target area
      shapefilelats {mustBeNumeric} % vector containing latitudes of points defined in shapefile
      shapefilelons {mustBeNumeric} % vector containing longitudes of points defined in shapefile
      shapefilenames % vector containing names of points defined in shapefile
      shapefilex {mustBeNumeric} % vector containing x coordinates of points defined in shapefile
      shapefiley {mustBeNumeric} % vector containing y coordinates of points defined in shapefile
      shapefilez {mustBeNumeric} % vector containing z coordinates of points defined in shapefile
      targetMassData %vector containing target mass area
      targetmap {mustBeNumeric} % matrix of values denoting inside and outside of target area
      R % geographic raster reference object
      xdata {mustBeNumeric} % vector containing x ordinates of points distrubuted across target area
      ydata {mustBeNumeric} % vector containing y ordinates of points distrubuted across target area
      zdata {mustBeNumeric} % vector containing z ordinates of points distrubuted across target area
      latitude {mustBeNumeric} % vector containing latitudes of points distrubuted across target area
      longitude {mustBeNumeric} % vector containing longitudes of points distrubuted across target area
      altitude {mustBeNumeric} % vector containing altitudes of points distrubuted across target area
      accesstimesteps {mustBeNumeric} % vector containing time steps spent in target access
      accessstartlist {mustBeNumeric} % vector containing access start times
      accessstoplist {mustBeNumeric} % vector containing access stop times
      access % access object
      subareaaccesssequence = [] % squence of subareas accessed
      accessstarttimes = {} % start times of accesses
      accessstarttimesstr % start times of accesses in string
      accessstarttimesnum % start times of accesses in number
      accessstoptimes = {} % stop times of accesses
      accessstoptimesstr % stop times of accesses in string
      accessstoptimesnum % stop times of accesses in number
      accesssdurations % durations of accesses
      accesssdurationsstr % durations of accesses in string
      FoVaccesstimesteps {mustBeNumeric} % vector containing time steps spent in target access accounting for FoV
      FoVaccessstartlist {mustBeNumeric} % vector containing access start times accounting for FoV
      FoVaccessstoplist {mustBeNumeric} % vector containing access stop times accounting for FoV
      FoVaccess % access object accounting for FoV
      FoVaccessstarttimes % start times of accesses accounting for FoV
      FoVaccessstarttimesstr % start times of accesses in string accounting for FoV
      FoVaccessstarttimesnum % start times of accesses in number accounting for FoV
      FoVaccessstoptimes % stop times of accesses accounting for FoV
      FoVaccessstoptimesstr % stop times of accesses in string accounting for FoV
      FoVaccessstoptimesnum % stop times of accesses in number accounting for FoV
      FoVaccesssdurations % durations of accesses accounting for FoV
      FoVaccesssdurationsstr % durations of accesses in string accounting for FoV 
   end
   methods
       function obj = TargetClass(name,type,datarate,sza,sunconst,xdatshapefile,ydat,zdat)
           %TargetClass is the constructor of the
           %TargetClass object
           % Inputs:
           %    name : string containting name of the target
           %    type : type of target
           %    sza : solar zenith angle (if constraint exists)
           %    sunconst : type of sun constraint
           %    xdatshapefile : vector containing x ordinates of points
           %    distrubuted across target area or string containing
           %    shapefile path
           %    ydat : vector containing y ordinates of points distrubuted across target area
           %    zdat : vector containing z ordinates of points distrubuted across target area
           % Outputs:
           %    obj : the TargetClass object
            if nargin == 7 % old constructor for earth area target
                obj.name = name;
                obj.xdata = xdat;
                obj.ydata = ydat;
                obj.zdata = zdat;
            elseif nargin == 6 % constructor for earth area/ sun constraint target
                obj.name = name;
                obj.type = type;
                obj.datagenerationrate = datarate;
                obj.shapefilepath = xdatshapefile;
                obj.solarzenithanglemax = sza;
                obj.sunlightconstraint = sunconst;
           elseif nargin == 3 % constructor for solar/moon point target
                obj.name = name;
                obj.type = type;
                obj.datagenerationrate = datarate;
           elseif nargin == 5 % constructor for earth / sun constraint target
                obj.name = name;
                obj.type = type;
                obj.datagenerationrate = datarate;
                obj.solarzenithanglemax = sza;
                obj.sunlightconstraint = sunconst;
            end
       end
       function obj = convertcart2geo(obj)
           %convertcart2geo convertes cartesian coordinates to geodetic
           %
           % Inputs:
           % Outputs:
           %    obj : the TargetClass object
            [obj.latitude,obj.longitude,obj.altitude]=ecef2lla(obj.xdata,obj.ydata,obj.zdata);

       end
       function obj = computeaccestimes(obj,nopositionpoints,satellite,instrument,ellipsoid,timeseries)
           %computeaccestimes calculates accesstimes to targed in
           %simplified orbit model
           % Inputs:
           %    nopositionpoints : number of position points on earth
           %    surface
           %    satellite : satellite to consider
           %    instrument : instrumnet to consider
           %    ellipsoid : shape of eath
           %    timeseries : vector of time instances
           % Outputs:
           %    obj : the TargetClass object
             % find nearst target map node point and check if is in instrument foot print
            j = 1;
            for i = 1:nopositionpoints 
                % calculate instrument footprint
                footprintradius =  tan(deg2rad(instrument.FOVangle)) * satellite.altitudeseries(i);
            
                % find distances to points
                distances = distance(satellite.groundtrack.Latitude(i),satellite.groundtrack.Longitude(i),rad2deg(obj.latitude),rad2deg(obj.longitude),ellipsoid);
            
                %now find minum of those distances
                [mindistance, index] = min(distances);
                if mindistance < footprintradius
                    obj.accesstimesteps(j) = timeseries(i);
                    j = j + 1;
                end
            end
            
            % now post process the acces time series into discrete target accesses
            timestep = timeseries(2) - timeseries(1);
            
            
            j = 1;
            inaccess = false;
            for i = 1:size(obj.accesstimesteps,2)-1
                if obj.accesstimesteps(i+1) - obj.accesstimesteps(i) <= timestep * 2
                    if inaccess == false
                        inaccess = true;
                        obj.accessstartlist(j) = obj.accesstimesteps(i);
                    end
                else
                    if inaccess == true
                        inaccess = false;
                        obj.accessstoplist(j) = obj.accesstimesteps(i);
                        j = j + 1;
                    end
                end
            end


       end
       function obj = identifystkpointingtype(obj)
           %convertcart2geo convertes cartesian coordinates to geodetic
           %
           % Inputs:
           % Outputs:
           %    obj : the TargetClass object
           if string(obj.type) == 'AreaTarget'
                obj.stktype = 'TBD';
           elseif string(obj.type) == 'MultiPointTarget'
                obj.stktype = 'TBD';
           elseif string(obj.type) == 'Earth'
                obj.stktype = 'Planet/Earth';
           elseif string(obj.type) == 'Lunar'
               obj.stktype = 'Planet/Moon';
           elseif string(obj.type) == 'Solar'
               obj.stktype = 'Planet/Sun';
           end

       end
      

   end
end