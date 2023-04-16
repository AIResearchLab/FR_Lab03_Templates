function hw = exampleHelperTurtleBotIsPhysicalRobot()
    %exampleHelperTurtleBotIsPhysicalRobot - Checks if connected to the physical
    %   Turtlebot (or the Gazebo simulator)
    %   [HW] = exampleHelperTurtleBotIsPhysicalRobot() determines if a Turtlebot is being represented
    %   in hardware or software by checking which image topics are being
    %   published.
    
    %   Copyright 2014-2015 The MathWorks, Inc.
    
    hw = false;
    try
        % Checks if the color image topic is being published
        ros.internal.NetworkIntrospection.getPublishedTopicType('/camera/rgb/image_color', false);
        hw = true;
    catch
    end
end