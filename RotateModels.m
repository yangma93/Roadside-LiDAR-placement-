function Coors = RotateModels(model,angle,position)
angle = angle - pi/2;
Coors = CoorsTrans(0,0,angle,model(:,1:3),position,1,2);
Coors(:,4) = model(:,4);
end