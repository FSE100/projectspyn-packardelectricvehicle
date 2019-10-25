brick = ConnectBrick(bname);
brick.SetColorMode(ColorCode, 2);
while (a==1)
   color = brick.ColorCode(2);
if (color == 5)
%stop for 4 sec    

else if (color == 2)
%do dropoff thing        
a=2;   
else if (color ==3)
%do pickup thing
else
%keep on going        
end
end
end
end