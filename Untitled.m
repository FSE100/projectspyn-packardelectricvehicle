a = robot_class('EV3LL');
%a.driveEncod(1500,30);
%a.setArmToPosAbs(30);    
while (a.getTouchedVal() ==0)
     a.driveMotors(47,50);
end
    a.driveEncod(-300, 50);
    a.driveEncodAlt(-290,290,30);
a.stopDrive();

%a.turnPos(90,30);
a.disconnect();
function passVal = driveEncod(ev3, distance, speed)
    ev3.ResetMotorAngle('AD');
    ev3.MoveMotorAngleRel('AD', speed, distance, 'Brake');
    ev3.WaitForMotor('A');
    passVal = 0;
end



function passVal = setArmToPosAbs(ev3, pos)
    ev3.ResetMotorAngle('C');
    ev3.MoveMotorAngleRel('C', pos, 20, 'Brake');
    ev3.WaitForMotor('C');
    passVal = 0;
end    

function nothing = main(brickName)
    brick = ConnectBrick(brickName);
    brick.beep;
    val = setArmToPosAbs(brick, 25);
    %val = driveEncod(brick, 1500, 30);
end

