function [x,y,z] = createGrids(angleRange,angularRes,disRange,gridSize)
azimuth = angleRange(1):angularRes(1):angleRange(2);
azimuth = azimuth*pi/180;
elevation = angleRange(3):angularRes(2):angleRange(4);
elevation = elevation*pi/180;
[T,B] = meshgrid(azimuth,elevation);
T = gpuArray(T);
B = gpuArray(B);
rho = 0:gridSize:disRange;
num_pts = numel(T);
rho_array = repmat(rho,num_pts,1);
num_rho = length(rho);
azi_array = repmat(reshape(T,num_pts,1),1,num_rho);
ele_array = repmat(reshape(B,num_pts,1),1,num_rho);
[x,y,z] = sph2cart(azi_array,ele_array,rho_array);
end