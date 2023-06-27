classdef CommsPassClass
    % CommsPassClass Class for storing information about a particular
    % CommsPass
    % 
    % CommsPassClass Properties:
    %    windowlength - float containing duration in seconds of access window
    %    groundstationID - id of groundation to use
    %    startTime - start time of pass
    %    stopTime - stop time of pass
    %
    % CommsPassClass Methods:
    %    CommsPassClass - Constructor of CommsPassClass
   properties
      windowlength {mustBeNumeric} % float containing duration in seconds of access window
      groundstationID % id of groundation to use
      startTime % start time of pass
      stopTime % stop time of pass
   end
   methods
       function obj = CommsPassClass(duration,gsindex,stime)
           %CommsPassClass is the constructor of the
           %CommsPassClass object
           % Inputs:
           %    duration : duration of the pass
           %    gsindex : index of the related ground station
           %    stime : start time of the pass
           % Outputs:
           %    obj : the CommsPassClass object
            if nargin == 3
                obj.windowlength = duration;
                obj.groundstationID = gsindex;
                obj.startTime = stime;

            end
       end
   end
end