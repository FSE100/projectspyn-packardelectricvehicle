%Color Sensor Testing Method
%Ignore for Repo Evaluation

a = robot_class('EV3LL');
pause on;
cont_loop = true;

commands = [1 1 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1.5 -1 -1 -1];

while (1)
    disp(a.getColor());
    a.driveEncodCompCus(400);
end
