function colorImgSub = exampleHelperTurtleBotEnableColorCamera
%exampleHelperTurtleBotEnableColorCamera Subscribes to an appropriate color camera topic on the TurtleBot

%   Copyright 2015 The MathWorks, Inc.

% Determine if we are connected to the physical TurtleBot
isHardware = exampleHelperTurtleBotIsPhysicalRobot; 
if isHardware
    colorImgSub = rossubscriber('/camera/rgb/image_color/compressed', 'BufferSize', 5, 'DataFormat', 'struct');
    receive(colorImgSub,3);
    disp('Successfully Enabled Camera (compressed image)');
else
    colorImgSub = rossubscriber('/camera/rgb/image_raw', 'BufferSize', 5, 'DataFormat', 'struct');
    receive(colorImgSub,3);
    disp('Successfully Enabled Camera (raw image)');
end

end

