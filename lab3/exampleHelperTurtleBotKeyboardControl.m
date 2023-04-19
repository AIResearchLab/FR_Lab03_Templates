function exampleHelperTurtleBotKeyboardControl(handles)
    %exampleHelperTurtleBotKeyboardControl - Allows for user control of Turtlebot through keyboard commands
    %   exampleHelperTurtleBotKeyboardControl(HANDLES) takes a set of subscriber
    %   and publisher handles as input and publishes velocity commands according 
    %   to user keyboard input. The turtlebot location is plotted.
    %
    %   See also TurtleBotTeleoperationExample
    
    %   Copyright 2014-2015 The MathWorks, Inc.
    
    plotobj = ExampleHelperTurtleBotVisualizer([-10,10,-10,10]);
    
    keyObj = ExampleHelperTurtleBotKeyInput();
    
    disp('Keyboard Control: ');
    disp('i=forward, k=backward, j=left, l=right');
    disp('q=quit');
    disp('Waiting for input: ');
    
    % Use ASCII key representations for reply, initialize here
    reply = 0;
    
    pose = readPose(handles.odomSub.LatestMessage);
    laserdata = readLaserData(handles.laserSub.LatestMessage);
    try
        plotData(plotobj,pose,laserdata);
    catch
        reply = 'q'; % If figure is closed, exit
    end
    
    while reply~='q'
        
        forwardV = 0;   % Initialize linear and angular velocities
        turnV = 0;
        
        reply = getKeystroke(keyObj);
        switch reply
            case 'i'         % i
                forwardV = 0.2;
            case 'k'     % k
                forwardV = -0.2;
            case 'j'     % j
                turnV = 1;
            case 'l'     % l
                turnV = -1;
        end
        
        % Retrieve pose and laser data and send to plotting function
        % Wait for next laser reading
        laserMsg = receive(handles.laserSub,3);
        odomMsg = handles.odomSub.LatestMessage;
        laserdata = readLaserData(laserMsg);
        pose = readPose(odomMsg);

        % Publish velocities to the robot
        exampleHelperTurtleBotSetVelocity(handles.velPub, forwardV, turnV);        
        
        try
            plotData(plotobj,pose,laserdata);
        catch
            reply = 'q'; % If figure is closed, exit
        end
                
        pause(0.1);
    end
    closeFigure(keyObj);
end

function laserData = readLaserData(laserMsg)
%readPose Extract the laser data in Cartesian coordinates
if isstruct(laserMsg)
    laserData = rosReadCartesian(laserMsg) * [0 1; -1 0];
else
    laserData = readCartesian(laserMsg) * [0 1; -1 0];
end
end

function pose = readPose(odomMsg)
%readPose Extract the robot odometry reading as [x y theta] vector

% Extract the x, y, and theta coordinates
poseMsg = odomMsg.Pose.Pose;
xpos = poseMsg.Position.X;
ypos = poseMsg.Position.Y;
quat = poseMsg.Orientation;
angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
theta = angles(1);
pose = [xpos, ypos, theta];

end
