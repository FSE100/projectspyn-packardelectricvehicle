robot = robot_class('EV3LL');


commands = [1 .5 1 1 -.5];
solver = maze_solver(robot,-1,-1);


solver.start_maze();
while (1)
    solver.update_maze();
    disp(solver.robot.ev3.GetMotorAngle('A'));
end
solver.stop_maze();
%robot.runDriveCommands(commands);
%solver = maze_solver(robot,-1,-1);
%solver.setupColorTracker();
%while (1)
%end
%robot.disconnect();
