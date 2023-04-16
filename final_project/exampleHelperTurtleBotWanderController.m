function [v, omega] = exampleHelperTurtleBotWanderController()
    %exampleHelperTurtleBotWanderController - Drives Turtlebot in aimless and random direction
    %  [V,OMEGA] = exampleHelperTurtleBotWanderController() controls a Turtlebot around a space by
    %  randomly altering its angular and linear velocity commands in a
    %  continuous way.
    %
    %   See also exampleHelperTurtleBotPointController, exampleHelperTurtleBotTrackingTimer
    
    %   Copyright 2014 The MathWorks, Inc.
    
    maxV = 0.3;
    maxOmega = 1.5;
    
    persistent vel;
    persistent angV;
    if isempty(vel)
        vel = 0.2;
        angV = 0.5;
    end
    
    % Create a random 3-vector of velocities
    vrand = (randperm(3)-2)*0.02;
    % Use the first one and add it to the current velocity
    vel = vel +  vrand(1);
    % Use similar method for angular velocities
    orand = (randperm(3)-2)*0.1;
    angV = angV + orand(1);
    
    % Thresholding for velocities
    if abs(vel) > maxV
        vel = maxV*sign(vel);
    end
    if abs(angV) > maxOmega
        angV = maxOmega*sign(angV);
    end
    
    v = vel;
    omega = angV;
end