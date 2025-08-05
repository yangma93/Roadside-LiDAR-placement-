function [Sz,idx_linear,in] = createVoxelPos(x,y,z,configureMatrix,gridSize,POM_size,ROI)
%% coordinate transformation 
roll = configureMatrix(:,4)*pi/180;
pitch = configureMatrix(:,5)*pi/180;
yaw = configureMatrix(:,6)*pi/180;
Rx = [1 0 0;0 cos(roll) sin(roll);0 -sin(roll) cos(roll)];
Ry = [cos(pitch) 0 -sin(pitch);0 1 0;sin(pitch) 0 cos(pitch)];
Rz = [cos(yaw) sin(yaw) 0;-sin(yaw) cos(yaw) 0;0 0 1];
R = Rz*Rx*Ry;
Center = configureMatrix(:,1:3)';
X = R(1)*x+R(4)*y+R(7)*z+Center(1);
Y = R(2)*x+R(5)*y+R(8)*z+Center(2);
Z = R(3)*x+R(6)*y+R(9)*z+Center(3);

[Sz,idx_linear,in] = obtainRayMatrix(ROI,POM_size,X,Y,Z,gridSize);

end

function [Sz,idx_linear,in] = obtainRayMatrix(ROI,POM_sz,X,Y,Z,gridSize)
Sz = size(X);
in = find(X>ROI(1) & X<ROI(2) & Y>ROI(3) & Y<ROI(4) & Z>ROI(5) & Z<ROI(6));
Points = horzcat(X(in), Y(in), Z(in));
row = round((Points(:,2)-ROI(3))/gridSize)+1;
col = round((Points(:,1)-ROI(1))/gridSize)+1;
dep = round((Points(:,3)-ROI(5))/gridSize)+1;
% [idx_linear,ia] = unique(sub2ind(POM_sz,row,col,dep));
% in = in(ia);
idx_linear = sub2ind(POM_sz,row,col,dep);
end 