classdef ExampleHelperPIDControl < handle
    %ExampleHelperPIDControl - Class for executing PID control
    %   OBJ = ExampleHelperPIDControl(GAINS) creates a PID controller object with a GAINS
    %   struct as input. The object keeps track of time, error, and windup.
    %
    %   ExampleHelperPIDControl methods:
    %       PIDControl          - Constructor for PIDControl class
    %       update              - Updates the control output
    %
    %   ExampleHelperPIDControl properties:
    %       PGain               - Proportional gain
    %       DGain               - Derivative gain
    %       IGain               - Integral gain
    %       MaxWindup           - Maximum value for integral windup
    %       SetPoint            - The set value to control around
    %
    
    %   Copyright 2014 The MathWorks, Inc.
    
    properties (Access = public)
        PGain = 0;          % Proportional gain
        DGain = 0;          % Derivative gain
        IGain = 0;          % Integral gain
        MaxWindup = 0;      % Maximum value for integral windup
        SetPoint = 0;       % Set point to control around
    end
    
    properties (Access = protected)
        Time;               % Time since the last update (dt)
        PrevError;          % Error from the prior update
        IntWind;            % Stored integral windup
    end
    
    methods (Access = public)
        function obj = ExampleHelperPIDControl(gains)
            %ExampleHelperPIDControl Constructor
            
            % Set the properties according to the input
            if nargin ~= 0
                obj.PGain = gains.pgain;
                obj.DGain = gains.dgain;
                obj.IGain = gains.igain;
                obj.MaxWindup = gains.maxwindup;
                obj.SetPoint = gains.setpoint;
            end
            obj.Time = tic;
            obj.PrevError = 0;
            obj.IntWind = 0;
        end
        
        function control = update(obj, current)
            %UPDATE - Updates the control output
            
            % Compute error, windup, and derivative terms
            error = obj.SetPoint - current;
            obj.IntWind = obj.IntWind + error*toc(obj.Time);
            derivative = (error - obj.PrevError)./(toc(obj.Time));
            
            % Generate control output and assign properties
            control = obj.PGain*error + obj.DGain*derivative + obj.IGain*obj.IntWind;
            obj.PrevError = error;
            obj.Time = tic;
        end
    end
    
    methods (Static)
        function opts = getDefaultOptions
            %GETDEFAULTOPTIONS - Assigns default values to properties
            
            opts.pgain = 10;
            opts.dgain = 0;
            opts.igain = 0;
            opts.maxwindup = 100;
            opts.setpoint = 0;
        end
    end
    
end

