classdef robot_class < handle
	%Diagram for port layout
        %A = Left Motor, D = Right Motor, C = Arm Motor
	%1 = Color Sensor, 3 = GyroScope, 4 = Touch Sensor	
    properties
        ev3
        ev3_name
    end
    methods
        function touched = getTouchedVal(obj)
            touched = obj.ev3.TouchPressed(4);
        end
        
        function passVal = disconnect(obj)
           DisconnectBrick(obj.ev3);
        end

        function angle = getAngPos(obj)
            angle = obj.ev3.GyroAngle(3);
        end
        
        function ultraVal = getUltrasonicVal(obj)
            dis = obj.ev3.UltrasonicDist(2);
            if (dis > 0)
              ultraVal = dis;
            end
        end
        
        %-1 = fault, 0 =nocolor, 1 = black, 2= blue, 3 = green, 4= yellow
        %5 = red, 6 = white, 7 = brown
        function colorVal = getColor(obj)
            obj.ev3.SetColorMode(2,1);
            color = obj.ev3.ColorCode(1);
            if color > 0
                colorVal = color;
            else
                colorVal = -1;
            end
        end 
        
        %null gyroscope output for whatever reason. needs to be resolved.
        function passVal = turnPos(obj, angle, speed)
            obj.ev3.StopMotor('AD');
            obj.ev3.GyroCalibrate(3);
            pause(2)
            error = (angle+str2double(obj.ev3.GyroAngle(3)))-str2double(obj.ev3.GyroAngle(3));
            if (error > 0)
                obj.ev3.MoveMotor('A',speed)
                obj.ev3.MoveMotor('D', -speed)
            else
                obj.ev3.MoveMotor('A',-speed)
                obj.ev3.MoveMotor('D', speed)
            end
             error = (angle+str2double(obj.ev3.GyroAngle(3)))-str2double(obj.ev3.GyroAngle(3));
            display(error)
            %startTime = clock(5)
            while (abs(error) > 3 )%&& clock(5) < startTime+5)
                print(error)
                error = angle-obj.ev3.GyroAngle(3);
            end
            obj.ev3.StopMotor('AD')
        end

	%1 is forward, -1 is back, -.5 is left turn, .5 is right turn, 0 is nothing
	function passVal = runDriveCommands(obj, commandList)
		for command = commandList
			switch command
				case 1
				obj.DriveEncodComp(200);
				case -1
				obj.DriveEncodComp(-200);
				case -.5
				obj.DriveEncodAlt(-290,290,30);
				case .5
				obj.DiveEncodAlt(290,-290,30);
				otherwise
				disp("Inncorrect Value")
		passVal = 0;
			end
		end
	end



        function passVal = driveEncod(obj,distance, speed)
            obj.ev3.ResetMotorAngle('AD');
            obj.ev3.MoveMotorAngleRel('AD', speed, distance, 'Brake');
            obj.ev3.WaitForMotor('A');
            passVal = 0;
        end

	function pass val = driveEncodComp(obj,distance)
	    obj.ev3.ResetMotorAngle('AD');
	    obj.ev3.MoveMotorAngleRel('A', 47, distance,'Brake');
	    obj.ev3.MoveMotorAngleRel('D',50,distance,'Brake');
	    obj.ev3.WaitForMotor('A');
	    passVal = 0;
	end
        
        function passVal = driveEncodAlt(obj,leftDis, rightDis,speed)
            obj.ev3.ResetMotorAngle('AD');
            obj.ev3.MoveMotorAngleRel('A', speed,leftDis, 'Brake');
            obj.ev3.MoveMotorAngleRel('D', speed,rightDis, 'Brake');
            obj.ev3.WaitForMotor('A');
        end
        
        function passVal = driveMotors(obj, leftPwr, rightPwr)
            obj.ev3.MoveMotor('A', leftPwr);
            obj.ev3.MoveMotor('D', rightPwr);
        end
        
        function obj = robot_class(robot_name)
            obj.ev3 = ConnectBrick(robot_name);
            obj.ev3_name = robot_name;
            obj.ev3.StopMotor('AD');
            obj.ev3.GyroCalibrate(3);
        end
        
        function passVal = stopDrive(obj)
            obj.ev3.StopMotor('AD');
        end
        
        function passVal = setArmToPosAbs(obj, pos)
        obj.ev3.ResetMotorAngle('C');
        obj.ev3.MoveMotorAngleRel('C', pos, 5, 'Brake');
        obj.ev3.WaitForMotor('C');
        passVal = 0;
        end  
    end
end


            
            
