function [DepthData_back,LidarData_back] = GenBackRawData(configureMatrix,angleRange,angularRes,...
    disRange,ptOut,ImSize)
numLidars = length(configureMatrix(:,1));
Points = ptOut.Location;
DepthData_back = cell(1,numLidars);
LidarData_back = cell(1,numLidars);
for j=1:numLidars
LocalPoints = CoorsTrans_degree(configureMatrix(:,4),configureMatrix(:,5),...
        configureMatrix(:,6),Points(:,1:3),configureMatrix(:,1:3),j,1);
[sphereData(:,1),sphereData(:,2),sphereData(:,3)] = cart2sph(LocalPoints(:,1),...
        LocalPoints(:,2),LocalPoints(:,3));
sphereData(:,1:2) = sphereData(:,1:2)*180/pi;
[DepthData_back{j},LidarData_back{j},~] = VSM(sphereData,ImSize(j,:),...
    angleRange(j,:),angularRes(j,:),disRange(j,:));
LidarData_back{j} = CoorsTrans_degree(configureMatrix(:,4),configureMatrix(:,5),...
            configureMatrix(:,6),LidarData_back{j},configureMatrix(:,1:3),j,2);
end
end