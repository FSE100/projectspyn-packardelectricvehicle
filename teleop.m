global key
InitKeyboard();

a = robot_class('EV3LL');

while 1
    pause(.1);
    %display (a.getTouchedVal())
    display(a.getUltrasonicVal());
    %print(key)
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
    end
end
CloseKeyboard();
a.disconnect();
            
            
            