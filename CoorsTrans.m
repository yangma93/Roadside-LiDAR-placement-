function LocalCoor = CoorsTrans(roll,pitch,yaw,P2Trans,Origin,i,type)
%% Annotations
% Rigid rotation matrix
% i refer to the index of lidar sensors
% P2Trans = points to be transformed
% Origin = position of the lidar sensor center
% roll, pitch, yaw = rotation angles in degrees
% clockwise direction is positive
% roll = roll*pi/180;
% pitch = pitch*pi/180;
% yaw = yaw*pi/180;
Center = repmat(Origin(i,:),length(P2Trans),1);
%% Rotation Matrix
switch type
    case 1
        %% global to local
        Rx=@(k)[1 0 0;0 cos(roll(k)) -sin(roll(k));0 sin(roll(k)) cos(roll(k))];
        Ry=@(k)[cos(pitch(k)) 0 sin(pitch(k));0 1 0;-sin(pitch(k)) 0 cos(pitch(k))];
        Rz=@(k)[cos(yaw(k)) -sin(yaw(k)) 0;sin(yaw(k)) cos(yaw(k)) 0;0 0 1];
        LocalCoor= (Ry(i)*Rx(i)*Rz(i))*(P2Trans'-Center');
        LocalCoor =LocalCoor';
    case 2
        %% local to global
%         Rx=@(k)[1 0 0;0 cos(roll(k)) sin(roll(k));0 -sin(roll(k)) cos(roll(k))];
%         Ry=@(k)[cos(pitch(k)) 0 -sin(pitch(k));0 1 0;sin(pitch(k)) 0 cos(pitch(k))];
%         Rz=@(k)[cos(yaw(k)) sin(yaw(k)) 0;-sin(yaw(k)) cos(yaw(k)) 0;0 0 1];
        Rx= @(k)[1 0 0;0 cos(roll(k)) -sin(roll(k));0 sin(roll(k)) cos(roll(k))];
        Ry= @(k)[cos(pitch(k)) 0 sin(pitch(k));0 1 0;-sin(pitch(k)) 0 cos(pitch(k))];
        Rz= @(k)[cos(yaw(k)) -sin(yaw(k)) 0;sin(yaw(k)) cos(yaw(k)) 0;0 0 1];
        LocalCoor= (Rz(i)*Rx(i)*Ry(i))*P2Trans'+Center';
        LocalCoor = LocalCoor';
end
end

