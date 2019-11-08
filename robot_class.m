%This class contains all of functions needed to interactive with the Car.
%The handle superclass is way to change matlab's behaviour so this class's
%objects are passed by reference instead of value which hugely
%innappropiate for this application. 
classdef robot_class < handle
	%Diagram for port layout
        %A = Left Motor, D = Right Motor, C = Arm Motor
	%1 = Color Sensor, 2 = UltraSonic, 3 = GyroScope, 4 = Touch Sensor	
    properties
        ev3 %ev3 object
        ev3_name %ev3 modules named.
        state %states for movement, 'f','b','l','r','sc' - sc = stop due to color
    end
    methods
        %simply returns a boolean value for whether the given touch sensor
        
        function val = resetAllMotorsAngle(obj)
             obj.ev3.ResetMotorAngle('ADC');
        end
        function touched = getTouchedVal(obj)
            touched = obj.ev3.TouchPressed(4);
        end
        
        %away to gracefully disconnect from the robot. Should be done at
        %the end of each test.
        function passVal = disconnect(obj)
           DisconnectBrick(obj.ev3);
        end
        
        %Deprecated but originally would get the gyro value
        function angle = getAngPos(obj)
            angle = obj.ev3.GyroAngle(3);
        end
        %simply returns the ultrasonic value in the default units %25 units
        %is distance when centered from a wall
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
	%1 is forward, -1 is back, -.5 is left turn, .5 is right turn, 0 is nothing
	function passVal = runDriveCommands(obj, commandList)
		for command = commandList
			switch command
				case 1
                obj.state = 'f';
				obj.driveEncodComp(200);
				case -1
				obj.driveEncodComp(-200);
                obj.state = 'b';
				case -.5
				obj.driveEncodAlt(-290,290,30);
                obj.state = 'l';
				case .5
				obj.driveEncodAlt(290,-290,30);
                obj.state = 'r';
                case 1.5
                    obj.setArmToPosAbs(10);
                case -1.5
                    obj.setArmToPosAbs(-10);
				otherwise
				disp("Inncorrect Value")
		passVal = 0;
			end
		end
    end
    %This function is a basic driveEncoder method, does not compensate for
    %differences in the motors
        function passVal = driveEncod(obj,distance, speed)
            obj.ev3.MoveMotorAngleRel('AD', speed, distance, 'Brake');
            obj.ev3.WaitForMotor('A');
            passVal = 0;
        end
    %same as above but fixed speeds and are adjusted so that the robot
    %travels as straight as possible.
	function passVal = driveEncodComp(obj,distance)
            aTicks = obj.ev3.motorGetCount('A');
            obj.ev3.MoveMotorAngleRel('A', 47, distance,'Brake');
            obj.ev3.MoveMotorAngleRel('D',50,distance,'Brake');
            error = aTicks+distance-obj.ev3.motorGetCount('A');
            passVal = 0;
            while (abs(error) > 20)
                if  obj.getTouchedVal() ==1
                    passVal = obj.ev3.motorGetCount('A')- aTicks;     
                    break;
              
                end
               error = aTicks+distance-obj.ev3.motorGetCount('A');
            end
            obj.stopDrive();
            if (passVal ~= 0)                
            passVal = -1;
            end
    end
        
    %This method allows for different distances for each motor, this is
    %used for encoder based turning.
        function passVal = driveEncodAlt(obj,leftDis, rightDis,speed)
            if 1
                obj.ev3.ResetMotorAngle('AD');
                obj.ev3.MoveMotorAngleRel('A', speed,leftDis, 'Brake');
                obj.ev3.MoveMotorAngleRel('D', speed,rightDis, 'Brake');
                obj.ev3.WaitForMotor('A');
                passVal = 0;
            else
               passVal = -1;
            end
        end
        
        %This method is simple have motors go a certain speed.
        function passVal = driveMotors(obj, leftPwr, rightPwr)
            obj.ev3.MoveMotor('A', leftPwr);
            obj.ev3.MoveMotor('D', rightPwr);
        end
        %constructor for the class.
        function obj = robot_class(robot_name)
            obj.ev3 = ConnectBrick(robot_name);
            obj.ev3_name = robot_name;
            obj.ev3.StopMotor('AD');
            %obj.ev3.resetAllMotorsAngle();
            obj.ev3.GyroCalibrate(3);
        end
        %An emergency stop for the drive Subsystem.
        function passVal = stopDrive(obj)
            obj.ev3.StopMotor('AD');
           % obj.state = 'sc';
        end
        
        %This method has the arm motor go to a certain position at a set
        %power. The speed should be slow enough so that the motor does not
        %knock of the wheelchair person.
        function passVal = setArmToPosAbs(obj, pos)
        obj.ev3.ResetMotorAngle('C');
        obj.ev3.MoveMotorAngleRel('C', pos, 5, 'Brake');
        obj.ev3.WaitForMotor('C');
        passVal = 0;
        end  
    end
end


            
            
