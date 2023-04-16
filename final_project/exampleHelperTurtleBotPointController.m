function [v, omega] = exampleHelperTurtleBotPointController(c, ~, imSize, gains)
    %exampleHelperTurtleBotPointController - Drives a Turtlebot aiming to keep a specified point
    %   in the center of its view
    %   [V,OMEGA] = exampleHelperTurtleBotPointController(C,~,S) controls based on the target
    %   point C within an image dimensions S. Linear (V) and angular
    %   (OMEGA) velocities are returned to keep the robot at a fixed distance
    %   from the object.
    %
    %   See also ExampleHelperPIDControl, exampleHelperTurtleBotTrackingTimer
    
    %   Copyright 2014 The MathWorks, Inc.
    
    maxV = 0.5;
    maxOmega = 0.75;  % 1.5 is good for real Turtlebot
    beta = 0.5;         % Filter constant
    
    
    persistent linearPID;
    persistent angularPID;
    persistent linGains;
    persistent angGains;
    persistent cFiltered;
    
    if isempty(linearPID)
        % Initialize PID controller
        if isempty(gains)
            targetPositions = [0.55, 0.5];  % Percent distance from top and left of image
            linGains = struct('pgain',1/100,'dgain',1/100,'igain',0,'maxwindup',0','setpoint',targetPositions(1));
            angGains = struct('pgain',1/400,'dgain',1/500,'igain',0,'maxwindup',0','setpoint',targetPositions(2));
        else
            linGains = gains.lin;
            angGains = gains.ang;
        end
        % Convert target point into pixels
        linGains.setpoint = linGains.setpoint*imSize(1);
        angGains.setpoint = angGains.setpoint*imSize(2);
        % Set up PID object
        linearPID = ExampleHelperPIDControl(linGains);
        angularPID = ExampleHelperPIDControl(angGains);
        cFiltered = c;
    end
    
    % Filtering Equation
    cFiltered = beta*c + (1-beta)*cFiltered;
    % Update PID control
    omega = update(angularPID,cFiltered(1));
    v = update(linearPID,cFiltered(2));
    
    % Threshold the output velocities
    if abs(v) > maxV
        v = maxV*sign(v);
    end
    if abs(omega) > maxOmega
        omega = maxOmega*sign(omega);
    end
    
end