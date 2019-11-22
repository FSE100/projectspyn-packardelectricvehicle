ignore_red = false;
robot = robot_class('EV3LL');
pause on

commands = [1 .5 1 1 -.5];

determine_action_priority_turn(a)

function val = tele_control(a)
    global key
    InitKeyboard();
    while 1
    pause(.1);
    switch key
        case 'uparrow'
            a.driveEncodComp(800);
        case 'downarrow'
            a.driveMotors(-47,-50);
        case 'leftarrow'
            a.driveEncodAlt(-100,100,30);
        case 'rightarrow'
            a.driveEncodAlt(100,-100,30);
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
            endq
    end
CloseKeyboard();
    end
end

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




function val = decide_color_action_alt(color_code, color_rgb, robot)
    disp ("in decide function alt")
    
    if (color_code == 5)
        disp("red detected")
        robot.stopDrive();
        pause(5);
        robot.driveEncodComp(300);
    else if (color_code ==3)
            if (color_rgb(2) > color_rgb(3))
                tele_control(a);
            else
                drop_off(a);

%prioritizes turning always
function val = determine_action_priority_turn(robot)
    aInit = robot.ev3.GetMotorAngle('A');
    past_dis = [];
    i = 0;
    while (1)
     color = robot.getColor();
     %color = robot.getColor();
     disp(color);
     %color2 = robot.getColorRGB();
    
     decide_color_action(color,robot);
        
     ultra_val = robot.getUltrasonicVal();
     
     if (ultra_val < 55)
         disp("Turn Right")
         robot.stopDrive();
         robot.driveEncodComp(-200);
         robot.driveEncodAlt(290+100,-290-100,30);
         robot.driveEncodComp(200);
     elseif (robot.getTouchedVal() == 1)
             disp("Turning left")
             robot.stopDrive();
             robot.driveEncodComp(-200);
             robot.driveEncodAlt(-290-100,290+100,30);
             robot.driveEncodComp(200);
     else
         disp("going straight")
         robot.driveMotors(55,50);
     end
        
    end
end


function val = determine_action_priority_straight(robot)
    aInit = robot.ev3.GetMotorAngle('A');
    past_dis = [];
    i = 0;
    while (1)
     color = robot.getColor();
     %color = robot.getColor();
     disp(color);
     %color2 = robot.getColorRGB();
    
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