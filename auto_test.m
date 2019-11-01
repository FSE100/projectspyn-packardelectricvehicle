robot = robot_class('EV3L');

commands = [1 .5 1 1 -.5];

robot.runDriveCommands(commands);

robot.disconnect()
