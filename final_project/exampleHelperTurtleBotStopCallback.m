function exampleHelperTurtleBotStopCallback( ~, ~, ~ )
    %exampleHelperTurtleBotStopCallback - Callback function called when timer is halted
    %
    %    See also exampleHelperTurtleBotObstacleTimer, exampleHelperTurtleBotTrackingTimer
    
    %    Copyright 2014 The MathWorks, Inc.
    
    disp('Shutting down the ROS node')
    rosshutdown
end

