classdef SpacecraftClass
    % SpacecraftClass   Class for storing information about a particular
    % Spacecraft
    % 
    % SpacecraftClass Properties:
    %    name - name of the Spacecraft
    %    SMA - float containing SMA of spacecraft orbit
    %    e - float containing eccentricity of spacecraft orbit
    %    I - float containing inclanation of spacecraft orbit
    %    RAAN - float containing RAAN of spacecraft orbit
    %    AOP - float containing AOP of spacecraft orbit
    %    TA - float containing TA of spacecraft orbit
    %    positionseries - vecotr describing posiotn and velocoity of spacecraft along orbit
    %    groundtrack - geoshape object of lat lon points along ground track
    %    altitudeseries - vector of altiudes for each positon in position series
    %    targetlist - cell array of target objects
    %    Instrumentlist - cell array of insturment objects
    %    antennalist - cell array of radio antenna objects
    %    nextcommspass - object containing information about the mext comms pass to be performed
    %    nexttargetpass - object containing information about the mext comms pass to be performed
    %
    % SpacecraftClass Methods:
    %    SpacecraftClass - Constructor of SpacecraftClass
    %    Kepl2Cartesain - Convert Keplerian elements to cartesian coordinates
   properties
      name {mustBeText} = "undefined" % name of the Spacecraft
      SMA {mustBeNumeric} % float containing SMA of spacecraft orbit
      e {mustBeNumeric} % float containing eccentricity of spacecraft orbit
      I {mustBeNumeric} % float containing inclanation of spacecraft orbit
      RAAN {mustBeNumeric}% float containing RAAN of spacecraft orbit
      AOP {mustBeNumeric} % float containing AOP of spacecraft orbit
      TA {mustBeNumeric} % float containing TA of spacecraft orbit
      positionseries %vecotr describing posiotn and velocoity of spacecraft along orbit
      groundtrack % geoshape object of lat lon points along ground track
      altitudeseries %vector of altiudes for each positon in position series
      targetlist % cell array of target objects
      Instrumentlist % cell array of insturment objects
      antennalist % cell array of radio antenna objects
      nextcommspass % object containing information about the mext comms pass to be performed
      nexttargetpass % object containing information about the mext comms pass to be performed
     


   end
   methods
       function obj = SpacecraftClass(name,sma,E,i,raan,aop,ta)
           %SpacecraftnClass is the constructor of the
           %SpacecraftClass object
           % Inputs:
           %    name : string containting name of the Spacecraft
           %    sma : float containing SMA of spacecraft orbit
           %    E : float containing eccentricity of spacecraft orbit
           %    i : float containing inclanation of spacecraft orbit
           %    raan : float containing RAAN of spacecraft orbit
           %    aop : float containing AOP of spacecraft orbit
           %    ta : float containing TA of spacecraft orbit
           % Outputs:
           %    obj : the SpacecraftClass object
            if nargin == 7
                obj.name = name;
                obj.SMA = sma;
                obj.e = E;
                obj.I = i;
                obj.RAAN = raan;
                obj.AOP = aop;
                obj.TA = ta;
            end
       end
       function [X, Y, Z, Vx, Vy, Vz] = Kepl2Cartesain(obj)
            %Kepl2Cartesain Convert Keplerian elements to cartesian
            %coordinates
            %
            % Inputs:				
            %
            % Outputs:
            %

            mu_earth = 3.986 * 10^5; % Earth Gravitational Constant
            re = 6378.1; % earth radius
            %
            %%--------------------------------------------------------------------------------------
            a = obj.SMA;
            p = a*(1-obj.e ^2);
            r_0 = p / (1 + obj.e * cos(obj.TA));
            INC = deg2rad(obj.I);
            %
            %%--------------- Coordinates in the perifocal reference system Oxyz -----------------%
            %
            % position vector coordinates
            x = r_0 * cos(obj.TA);
            y = r_0 * sin(obj.TA);
            %
            %
            % velocity vector coordinates
            Vx_ = -(mu_earth/p)^(1/2) * sin(obj.TA);
            Vy_ = (mu_earth/p)^(1/2) * (obj.e + cos(obj.TA));
            %
            %
            %%-------------- the geocentric-equatorial reference system OXYZ ---------------------%
            %
            % position vector components X, Y, and Z
            X = (cos(obj.RAAN) * cos(obj.AOP) - sin(obj.RAAN) * sin(obj.AOP) * cos(INC)) * x + (-cos(obj.RAAN) * sin(obj.AOP) - sin(obj.RAAN) * cos(obj.AOP) * cos(INC)) * y;
            Y = (sin(obj.RAAN) * cos(obj.AOP) + cos(obj.RAAN) * sin(obj.AOP) * cos(INC)) * x + (-sin(obj.RAAN) * sin(obj.AOP) + cos(obj.RAAN) * cos(obj.AOP) * cos(INC)) * y;
            Z = (sin(obj.AOP) * sin(INC)) * x + (cos(obj.AOP) * sin(INC)) * y;
            % velocity vector components X', Y', and Z'
            Vx = (cos(obj.RAAN) * cos(obj.AOP) - sin(obj.RAAN) * sin(obj.AOP) * cos(INC)) * Vx_ + (-cos(obj.RAAN) * sin(obj.AOP) - sin(obj.RAAN) * cos(obj.AOP) * cos(INC)) * Vy_;
            Vy = (sin(obj.RAAN) * cos(obj.AOP) + cos(obj.RAAN) * sin(obj.AOP) * cos(INC)) * Vx_ + (-sin(obj.RAAN) * sin(obj.AOP) + cos(obj.RAAN) * cos(obj.AOP) * cos(INC)) * Vy_;
            Vz = (sin(obj.AOP) * sin(INC)) * Vx_ + (cos(obj.AOP) * sin(INC)) * Vy_;
       end
   end
end