%Test Touch sensor Method
%Ignore for Repo Evaluation
rbc = robot_class('EV3LL');
isTouched = rbc.touched;

if (isTouched == 1) 
    %right turn
    rbc.driveEncodAlt(290,-290,30);
    
    %move foward
    rbc.driveEncodComp(obj, 300)
    
else
    rbc.driveEncodComp(obj, 300)  
end
