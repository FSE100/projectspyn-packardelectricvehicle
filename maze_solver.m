classdef maze_solver < handle
    properties
        robot %robot_object
        mazeHeight %for tracking position
        mazeWidth %for tracking position
        colorTracker %instance of colorTracker
        currentObj = "pickup" %options are 'pickup' or 'dropoff'
        starting
    end
    methods
        function obj = maze_solver(robot_name, width, height)
            obj.robot = robot_class(robot_name);
            obj.mazeHeight = height;
            obj.mazeWidth = width;
        end
        
        function val = checkColor(obj)
            colorCode = obj.robot.getColor();
            if (colorCode > 0)
                switch colorCode
                    case 2
                    %execute dropoff
                    
                    case 3
                    %execute pickup
                    case 4
                    case 5 %red pause for 5 seconds
                        disp("stopping for 5")
                        obj.robot.stopDrive();
                        %pause(5);             
                end         
            end
            val = 0;                        
        end
        function val = start_maze(obj)
            val =0;
        end
        
        function val = update_maze(obj)
             disp(obj.robot.getUltrasonicVal())
            obj.checkColor();
            obj.determine_action();
           
            val =0;
        end
        
        function val = determine_action(obj)
            display(obj.robot.getTouchedVal());
           if (obj.robot.getTouchedVal() == 1)
            obj.robot.stopDrive();
            obj.robot.driveEncodComp(-300*4);
            ultraVal2 = obj.robot.getUltrasonicVal();
            %disp(ultraVal2)
            if ultraVal2 < 30
            obj.robot.driveEncodAlt(290*2,-290*2,30);
            else
                obj.robot.driveEncodAlt(-290,290,30);
            end
           else
               obj.robot.driveMotors(55,50);
           end
            val = 0;
        end
        
        function val = stop_maze(obj)
            obj.robot.disconnect();
            val =0;
        end
        
        function val = stopTracker(obj)
            cancel(obj.colorTracker);
            val = 0;
        end
        
    end
end