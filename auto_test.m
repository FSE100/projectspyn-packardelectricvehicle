robot = robot_class('EV3LL');


commands = [1 .5 1 1 -.5];


while (1)
    determine_action(robot)
end      



function val = determine_action2(robot)
    aInit = robot.ev3.GetMotorAngle('A');
    past_dis = [];
    i = 0;
    while (1)
     if (robot.getTouchedVal() ~= 1)
        robot.driveMotors(55,50);
        
     else
         robot.stopDrive();
         ultra_val = robot.getUltrasonicVal();
         i = i+1;
         past_dis = [past_dis, robot.ev3.GetMotorAngle('A')-aInit];
         if (ultra_val < 55)
             disp("Turning right")
                robot.driveEncodAlt(290+100,-290-100,30);
         else
                disp("Turning left")
                robot.driveEncodAlt(-290-100,290+100,30);
         end
         if (rem(i,4) == 0)
             
         end
    end
        
    end
end


function val = determine_action(robot)
            %display(robot.getTouchedVal())
           if (robot.getTouchedVal() == 1)
            robot.stopDrive();
            ultraVal2 = robot.getUltrasonicVal();
            robot.driveEncodComp(-300*2);
           
            disp(ultraVal2)
            if ultraVal2 < 50
            disp("Turning right")
                robot.driveEncodAlt(290+100,-290-100,30);
            
            else
                disp("Turning left")
                robot.driveEncodAlt(-290-100,290+100,30);
            end
           else
               robot.driveMotors(55,50);
           end
            val = 0;
end

