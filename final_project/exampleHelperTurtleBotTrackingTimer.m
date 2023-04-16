function exampleHelperTurtleBotTrackingTimer(~, event, handles, isHardware)
    %exampleHelperTurtleBotTrackingTimer - Timer update function called in TurtlebotObjectTracking
    %   exampleHelperTurtleBotTrackingTimer(~, event, handles) updates the state of a
    %   Turtlebot using ROS publishers and subscribers passed into the
    %   function through the handles struct. The controller here generates
    %   object tracking behavior by using the Kinect sensor.
    %   The first argument is the timer object and can be ignored.
    %
    %   See also TurtleBotObjectTrackingExample
    
    %   Copyright 2014-2015 The MathWorks, Inc.
    
    persistent state
    persistent angVFilt
    persistent linVFilt
    persistent initialTime
    persistent cliffFlag
    persistent bumpArray
    
    maxSpinTime = 3.5;
    maxBumpTime = 2;
    maxCliffTime = 2;
    betaLin = 0.7;
    betaAng = 0.7;
    
    [findObject, imageControl] = initControl();
    
    currentTime = datetime(event.Data.time);
    
    % Initialize state and persistent variables
    if isempty(state)
        state = ExampleHelperTurtleBotStates.Seek;
        angVFilt = 0;
        linVFilt = 0;
        initialTime = currentTime;
        cliffFlag = 0;
        bumpArray = [];
        setSound(handles.soundPub, 'cleaning end', isHardware);
        if isHardware
            handles.cliffSub.NewMessageFcn = @cliffCallback;
            handles.bumpSub.NewMessageFcn = @bumpCallback;
        end
    end
    
    % Check bumper status and start timer if active
    if ~isempty(bumpArray)
        bumpArray = [];
        state = ExampleHelperTurtleBotStates.Bumper;
        setSound(handles.soundPub, 'error sound', isHardware);
        initialTime = currentTime;
    end
    
    % Check cliff sensor status and start timer if active
    if cliffFlag
        cliffFlag = 0;
        state = ExampleHelperTurtleBotStates.Cliff;
        setSound(handles.soundPub, 'error sound',isHardware);
        initialTime = currentTime;
    end
    
    switch state
        case ExampleHelperTurtleBotStates.Seek
            % Object-finding state
            latestImg = rosReadImage(handles.colorImgSub.LatestMessage);
            [center, scale] = findObject(latestImg,handles.params,isHardware);
            % Wander if no circle is found, target the circle if it exists
            if isempty(center)
                [linearV, angularV] = exampleHelperTurtleBotWanderController();
            else
                [linearV, angularV] = imageControl(center, scale, size(latestImg),handles.gains);
                setSound(handles.soundPub, 'recharge start',isHardware);
            end
            state = ExampleHelperTurtleBotStates.Seek;
            
        case ExampleHelperTurtleBotStates.Bumper
            % Bumper contact state - reverse
            [linearV, angularV] = exampleHelperTurtleBotReverseController();
            % Check for bumper state time expiration
            if seconds(currentTime - initialTime) > maxBumpTime
                if isempty(bumpArray)
                    state = ExampleHelperTurtleBotStates.Spin;
                    initialTime = currentTime;
                end
            end
            
        case ExampleHelperTurtleBotStates.Spin
            % Spin state
            [linearV, angularV] = exampleHelperTurtleBotSpinController();
            % Check for spin state time expiration
            if seconds(currentTime - initialTime) > maxSpinTime
                setSound(handles.soundPub, 'turn off');
                state = ExampleHelperTurtleBotStates.Seek;
            end
            
        case ExampleHelperTurtleBotStates.Cliff
            % Cliff avoidance
            [linearV, angularV] = exampleHelperTurtleBotReverseController();
            % Check for cliff state time expiration
            if seconds(currentTime - initialTime) > maxCliffTime
                cliffFlag = 0;
                state = ExampleHelperTurtleBotStates.Spin;
                initialTime = currentTime;
            end
    end
    
    % Filter the velocities
    linVFilt = betaLin*linearV + (1-betaLin)*linVFilt;
    angVFilt = betaAng*angularV + (1-betaAng)*angVFilt;
    
    % Publish velocities to the robot
    exampleHelperTurtleBotSetVelocity(handles.velPub, linVFilt, angVFilt);
    
    function [objectTrack, imgControl] = initControl()
        % INITCONTROL - Initialization function to determine which control
        % and object detection algorithms to use
        objectTrack = @exampleHelperTurtleBotFindBlueBall;
        imgControl = @exampleHelperTurtleBotPointController;
    end

    function cliffCallback(~, ~)
        %CLIFFCALLBACK - Raise a flag when cliff sensor is activated        
        cliffFlag = 1;
    end    

    function bumpCallback(~, message)
        %BUMPCALLBACK Save the received array of bumper contacts        
        bumpArray = message.Data;
    end
end

function setSound(soundPub, type, isHardware)
%SETSOUND - Plays a sound from the Turtlebot

persistent soundMsg
if ~isHardware
    return;
end

if isempty(soundMsg)
    soundMsg = rosmessage(soundPub);
end

switch type
    case 'turn off'
        type = 1;
    case 'recharge start'
        type = 2;
    case 'error sound'
        type = 4;
    case 'cleaning end'
        type = 6;
    otherwise
        disp('Invalid Sound');
        return;
end

soundMsg.Value = uint8(type);
send(soundPub,soundMsg);

end
