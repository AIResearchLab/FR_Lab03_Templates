classdef ExampleHelperTurtleBotKeyInput < handle
    %ExampleHelperTurtleBotKeyInput - Class for obtaining keyboard input
    %   OBJ = ExampleHelperTurtleBotKeyInput() creates a figure with instructions for Turtlebot
    %   keyboard control. The object keeps track of the figure and axes handles
    %   and converts keyboard input into ASCII values.
    %
    %   ExampleHelperTurtleBotKeyInput methods:
    %       getKeystroke            - Returns ASCII value for keystroke
    %       closeFigure             - Closes the figure and cleans up
    %
    %   ExampleHelperTurtleBotKeyInput properties:
    %       Figure                  - Stores the figure handle
    %       Axes                    - Stores the axes handle
    %
    %   See also exampleHelperTurtleBotKeyboardControl
    
    %   Copyright 2014-2015 The MathWorks, Inc.
    
    properties
        Figure = [];            % Stores the figure handle
        Axes = [];              % Stores the axes handle
    end
    
    methods
        function obj = ExampleHelperTurtleBotKeyInput()
            %ExampleHelperTurtleBotKeyInput - Constructor for KeyInput class
            
            callstr = 'set(gcbf,''Userdata'',double(get(gcbf,''Currentcharacter''))) ; uiresume ' ;
            
            obj.Figure = figure(...
                'Name','Press a key', ...
                'KeyPressFcn',callstr, ...
                'Position',[500 500  500 300],...
                'UserData','Timeout');
            obj.Axes = axes('Color','k','Visible','Off','XLim',[0,100],'YLim',[0,100]);
            text(50,80,'i = Forward','HorizontalAlignment','center','EdgeColor','k');
            text(50,40,'k = Backward','HorizontalAlignment','center','EdgeColor','k');
            text(25,60,'j = Left','HorizontalAlignment','center','EdgeColor','k');
            text(75,60,'l = Right','HorizontalAlignment','center','EdgeColor','k');
            text(50,20,'q = Quit','HorizontalAlignment','center','EdgeColor','r');
            text(50,0,'Keep this figure in scope to give commands','HorizontalAlignment','center');
        end
        
        function keyout = getKeystroke(obj)
            %GETKEYSTROKE - Returns ASCII value for keystroke
            
            try
                uiwait(obj.Figure);
                keyout = get(obj.Figure,'Userdata') ;
            catch
                keyout = 'q';
            end
        end
        
        function closeFigure(obj)
            %CLOSEFIGURE - Closes the figure and cleans up
            
            try
                figure(obj.Figure);
                close(obj.Figure);
            catch
            end
        end
    end
    
end

