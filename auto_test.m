%Main Autonomous Vehicle Navigation Script
%Contains calls to our robot_class which contains all methods of
%interfacing with the ev3.

robot = robot_class('EV3LL');
pause on;

%initial call to start the maze navigation
determine_action_priority_turn(robot)

%drop off method
%used if the blue is detected and autonomous drop off is enable.
function val = drop_off(a)
    commands = [-.5 -.5 -.5 -1 -1 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 1 1 1];
    a.stopDrive();
    a.runDriveCommands(commands);
end

%pickup method effectively reverse of the above method.
function pickup(a)
    commands = [-.5 -.5 -.5 -1 -1 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1 -1 -1 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1 1 1 1 1 1 1 1 1];
    a.stopDrive();
    a.runDriveCommands(commands);
end


%the manual control method:
%Effectively it creates a window and begins to accept keyboard control to
%move the robot
function val = tele_control(a)
    global key
    InitKeyboard();
    while 1
    pause(.1);
    switch key
        case 'uparrow'
            a.driveMotors(47,50);
        case 'downarrow'
            a.driveMotors(-47,-50);
        case 'leftarrow'
            a.driveEncodAlt(-50,50,30);
        case 'rightarrow'
            a.driveEncodAlt(50,-50,30);
        case 0
            a.driveMotors(0,0);
        case 'q'
            a.driveMotors(0,0);
            break;
        case 'e'
            a.driveEncodAlt(-290,290,30);
        case 'r'
            a.driveEncodAlt(290,-290,30);
        case 'z'
            a.setArmToPosAbs(10);
        case 'x'
            a.setArmToPosAbs(-10);
    end
    end
CloseKeyboard();
end

%deprecated color checking method
function val = decide_color_action(color_code, robot)
    disp ("in decide function_for color")
    %if (((color_code(1) > 34) && (color_code(3) < 12 && color_code(2) <12)) || color_code(2) > 12 || color_code(3) > 12) 
    if (color_code == 5)
        disp("red detected")
        robot.stopDrive();
        pause(5);
        robot.driveEncodComp(300);
    elseif (color_code == 3)
        disp("green detected")        
        robot.stopDrive();
        tele_control(robot);
    end
   % end
end

%a color checking method that employs the autonomous drop off
function val = decide_color_action_code(color_code, robot)
    disp ("in decide function_for color")
    %if (((color_code(1) > 34) && (color_code(3) < 12 && color_code(2) <12)) || color_code(2) > 12 || color_code(3) > 12) 
    if (color_code == 5)
        disp("red detected")
        robot.stopDrive();
        pause(5);
        robot.driveEncodComp(300);
    elseif (color_code == 3)
        disp("green detected");        
        robot.stopDrive();
        pickup(robot);
        %tele_control(robot);
        robot.state = "p";
        val = true;
    elseif (color_code == 2 && robot.state == "p")
        disp("blue detected");
        robot.stopDrive();
        drop_off(robot);
        robot.state = "s";
    end
end

%A color checking method that does not included the autonomous drop off
function val = decide_color_action_code_no_auto(color_code, robot)
    disp ("in decide function_for color")
    if (color_code == 5)
        disp("red detected")
        robot.stopDrive();
        pause(5);
        robot.driveEncodComp(300);
    elseif (color_code == 3 || color_code ==2)
        disp("green detected");        
        robot.stopDrive();
        tele_control(robot);
        robot.state = "p";
        val = false;
    end
end

function val = decide_color_action_alt(color_code, color_rgb, robot)
    disp ("in decide function alt")
    if (color_code == 5)
        disp("red detected")
        robot.stopDrive();
        pause(5);
        robot.driveEncodComp(300);
    elseif (color_code ==3)
            if (color_rgb(2) > color_rgb(3))
                tele_control(a);
            else
                drop_off(a);
            end
        end
end

%prioritizes turning always
function val = determine_action_priority_turn(robot)
    robot.changeColorMode(2);
    ignore_color = false; % this is used 
    while (robot.state == "m" || robot.state == "p")
        color = robot.getColor(); %stores the color code
        disp(color);
    
        %check to see if any color actions are required.
        decide_color_action_code(color, robot);
     
     %stores ultrasonic value
        ultra_val = robot.getUltrasonicVal();
     
%Effectively this series of checks determines what the robot does.
%Option one: if ultrasonic detects no wall on left, turn left and drive forward.
%Option two: if ultrasonic detects a wall, see if the front touch sensor has been triggered. 
%Turn right they are triggered and driveforward.
%Option three: if the two previous conditions both failed, then drive forward.
%Additionally the Left turn moves a little bit each time it uses encoders
%to verify if a stop zone is present.
        if (ultra_val > 55)
            disp("Turn Left")
            robot.stopDrive();
            robot.driveEncodComp(200);
            color_code = robot.getColor();
            decide_color_action_code_no_auto(color_code, robot);
            robot.driveEncodComp(200);
            color_code = robot.getColor();
            decide_color_action_code_no_auto(color_code, robot);
            robot.driveEncodComp(200);
            color_code = robot.getColor();
            decide_color_action_code_no_auto(color_code, robot);
            robot.driveEncodComp(200);
            color_code = robot.getColor();
            decide_color_action_code_no_auto(color_code, robot);
            robot.driveEncodAlt(-290-40,290+40,30);
            robot.driveEncodComp(200);
            color_code = robot.getColor();
            decide_color_action_code_no_auto(color_code, robot);
            robot.driveEncodComp(200);
            color_code = robot.getColor();
            decide_color_action_code_no_auto(color_code, robot);
            robot.driveEncodComp(200);
            color_code = robot.getColor();
            decide_color_action_code_no_auto(color_code, robot);
            robot.driveEncodComp(200);
            color_code = robot.getColor();
            decide_color_action_code_no_auto(color_code, robot);
        elseif (robot.getTouchedVal() == 1)
            disp("Turning Right")
            robot.stopDrive();
            robot.driveEncodComp(-200);
            robot.driveEncodAlt(290+40,-290-40,30);
            robot.driveEncodComp(200);
            color_code = robot.getColor();
            decide_color_action_code_no_auto(color_code, robot);
        else
            disp("going straight")
            robot.driveMotors(55,50);
        end
    end
    robot.stopDrive();
    robot.disconnect();
    
end

%deprecated method was used for the previous algorithm where to going
%straight was prioritized over turning.
function val = determine_action_priority_straight(robot)
    aInit = robot.ev3.GetMotorAngle('A');
    past_dis = [];
    i = 0;
    while (robot.state == "m")
     color = robot.getColor();
     disp(color);
    
     decide_color_action(color,robot);
        
     if (robot.getTouchedVal() ~= 1)
        robot.driveMotors(55,50);
     else
         robot.stopDrive();
         ultra_val = robot.getUltrasonicVal();
         i = i+1;
         past_dis = [past_dis, robot.ev3.GetMotorAngle('A')-aInit];
         robot.driveEncodComp(-200);
         if (ultra_val < 55)
             disp("Turning right")
                robot.driveEncodAlt(290+100,-290-100,30);
         else
                disp("Turning left")
                robot.driveEncodAlt(-290-100,290+100,30);
         end
         if (rem(i,4) == 0)
             disp("hit the wall 4 times, possibly stuck comparing distances")
         end
    end
        
    end
end
