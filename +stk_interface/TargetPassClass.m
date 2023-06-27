classdef TargetPassClass
    % TargetPassClass   Class for storing information about a particular
    % TargetPass
    % 
    %TargetPassClass Properties:
    %    windowlength - float containing duration in seconds of access window
    %    targetID - name of target to be passed
    %    selectedsubarea - index/name of selected sub area if multi sub area area target
    %    startTime - start time of the pass
    %    startTimeFoV - start time of the pass accounting for instrument FoV
    %    stopTime - stop time of pass
    %    stopTimeFoV - start time of the pass accounting for instrument FoV
    %
    % TargetPassClass Methods:
    %    TargetPassClass - Constructor of TargetPassClass
   properties
      windowlength {mustBeNumeric} % float containing duration in seconds of access window
      targetID % name of target to be passed
      selectedsubarea % index/name of selected sub area if multi sub area area target
      startTime % start time of the pass
      startTimeFoV % start time of the pass accounting for instrument FoV
      stopTime % stop time of pass
      stopTimeFoV % start time of the pass accounting for instrument FoV
   end
   methods
       function obj = TargetPassClass(duration,tarindex,stime)
           %TargetPassClass is the constructor of the
           %TargetPassClass object
           % Inputs:
           %    duration : duration of the pass
           %    tarindex : index of the related target
           %    stime : start of the pass
           % Outputs:
           %    obj : the TargetPassClass object
            if nargin == 3
                obj.windowlength = duration;
                obj.targetID = tarindex;
                obj.startTime = stime;

            end
       end
   end
end