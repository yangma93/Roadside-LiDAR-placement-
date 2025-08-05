function [voxelmap,X,Y,Z,idx_linear,RayMatrix,POB,Obs_prob] = RayTraceMethod(angleRange,angularRes,configureMatrix,...
    disRange,gridSize,POM,ROI)
azimuth = angleRange(1):angularRes(1):angleRange(2);
azimuth = azimuth*pi/180;
elevation = angleRange(3):angularRes(2):angleRange(4);
elevation = elevation*pi/180;
[T,B] = meshgrid(azimuth,elevation);
rho = 0:gridSize:disRange;
num_pts = numel(T);
rho_array = repmat(rho,num_pts,1);

num_rho = length(rho);
azi_array = repmat(reshape(T,num_pts,1),1,num_rho);
ele_array = repmat(reshape(B,num_pts,1),1,num_rho);
[x,y,z] = sph2cart(azi_array,ele_array,rho_array);

% x = gather(x);y = gather(y);z = gather(z);
%% coordinate transformation 
roll = configureMatrix(:,4)*pi/180;
pitch = configureMatrix(:,5)*pi/180;
yaw = configureMatrix(:,6)*pi/180;
Rx = [1 0 0;0 cos(roll) sin(roll);0 -sin(roll) cos(roll)];
Ry = [cos(pitch) 0 -sin(pitch);0 1 0;sin(pitch) 0 cos(pitch)];
Rz = [cos(yaw) sin(yaw) 0;-sin(yaw) cos(yaw) 0;0 0 1];
R = Rz*Rx*Ry;
Center = configureMatrix(:,1:3)';
%% solution 1#
% for i=1:num_pts
%     for j=1:num_rho
%         X(i,j) = R(1)*x(i,j)+R(4)*y(i,j)+R(7)*z(i,j)+Center(1);
%         Y(i,j) = R(2)*x(i,j)+R(5)*y(i,j)+R(8)*z(i,j)+Center(2);
%         Z(i,j) = R(3)*x(i,j)+R(6)*y(i,j)+R(9)*z(i,j)+Center(3);
%     end
% end

%% solution 2#

X = R(1)*x+R(4)*y+R(7)*z+Center(1);
Y = R(2)*x+R(5)*y+R(8)*z+Center(2);
Z = R(3)*x+R(6)*y+R(9)*z+Center(3);
% X = gather(X);Y = gather(Y);Z = gather(Z);
[voxelmap,idx_linear,RayMatrix,POB,Obs_prob] = estimatePOB(ROI,POM,X,Y,Z,gridSize);

end

function [voxelmap,idx_linear,RayMatrix,POB,Obs_prob] = estimatePOB(ROI,POM,X,Y,Z,gridSize)
voxelmap = zeros(size(POM));
Sz = size(X);
in = X>ROI(1) & X<ROI(2) & Y>ROI(3) & Y<ROI(4) & Z>ROI(5) & Z<ROI(6);
Points = [X(in) Y(in) Z(in)];
row = round((Points(:,2)-ROI(3))/gridSize)+1;
col = round((Points(:,1)-ROI(1))/gridSize)+1;
dep = round((Points(:,3)-ROI(5))/gridSize)+1;
idx_linear = sub2ind(size(POM),row,col,dep);
RayMatrix = zeros(Sz);
RayMatrix(in) = POM(idx_linear);
RayMatrix_r = 1-RayMatrix;
Temp_Prob = cumprod(RayMatrix_r,2);
Temp_Prob(:,2:end) = Temp_Prob(:,1:end-1);
Temp_Prob(:,1) = 1;
POB = Temp_Prob.*RayMatrix;
Obs_prob = voxelmap;
Obs_prob(idx_linear) = Temp_Prob(in);
voxelmap(idx_linear) = POB(in);

end