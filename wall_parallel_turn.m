rbc = robot_class ('EV3LL');
basedistance = rbc.ultraVal;
loop = 0;
distance = 0;
while loop == 0
    distance = rbc.ultraVal;
    if distance > 30.48
        %make a left turn
    end
    else if distance > basedistance
        %move right motor
        end
    else if distance < basedistance
        %move left motor
        end
end