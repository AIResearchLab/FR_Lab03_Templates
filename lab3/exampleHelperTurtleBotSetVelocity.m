function exampleHelperTurtleBotSetVelocity(velPub, vLin, vAng)
%exampleHelperTurtleBotSetVelocity Sets linear and angular velocity of Turtlebot

%   Copyright 2015 The MathWorks, Inc.

persistent velMsg

if isempty(velMsg)
    velMsg = rosmessage(velPub);
end

    velMsg.Linear.X = vLin;
    velMsg.Angular.Z = vAng;
    send(velPub,velMsg);
end
