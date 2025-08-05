function [Grid,CenterCoors,vertex,x_road] = CreateTunnelGrid(Height,Width,Radius) 

% 使用抛物线/圆曲线作为隧道的截面线形
% height是隧道顶部到地面的距离，Width车道总宽度，
% Radius 是隧道的平面曲线半径值 

gridSize = 0.4;
delta_l = gridSize;
angular_res = delta_l/Radius;
theta = pi:-angular_res:0;
rho = repmat(Radius,1,length(theta));
[x,y] = pol2cart(theta,rho);
CenterCoors = [x' y'];
CenterCoors(:,3) = 0;

lateral_clear = 1.5;
chord_length = Width+lateral_clear*2;
radius_cross = sqrt(Height^2+0.25*chord_length^2/(2*Height));
angularRes_cs = gridSize/radius_cross;

if radius_cross>Height 
    C = radius_cross-Height;
    angle = acos(C/radius_cross);
    angle_array = angle+pi/2:-angularRes_cs:pi/2-angle;
    rho = repmat(radius_cross,1,length(angle_array));
    [x_arc,y_arc] = pol2cart(angle_array,rho);
    y_arc = y_arc-C;
else
    C = Height - radius_cross;
    angle = acos(0.5*chord_length/radius_cross);
    angle_array_1 = -pi+angle:-pi/90:-pi;
    angle_array_2 = pi:-pi/90:-angle;
    angle_array = horzcat(angle_array_1,angle_array_2);
    rho = repmat(radius_cross,1,length(angle_array));
    [x_arc,y_arc] = pol2cart(angle_array,rho);
    y_arc = y_arc+C;
end
x_road = x_arc(end):-gridSize:x_arc(1);
if x_road(end) == x_arc(1)
    x_road(end) = x_arc(1)+gridSize;
end
y_road = zeros(1,length(x_road));
x_arc = horzcat(x_arc,x_road);
y_arc = horzcat(y_arc,y_road);
vertex_unit = zeros(length(x_arc),3);
vertex_unit(:,1) = x_arc'; 
vertex_unit(:,3) = y_arc';

grid_unit = zeros(length(x_road),3);
grid_unit(:,1) = x_road'; 
grid_unit(:,3) = y_road';

num_cs = length(CenterCoors(:,1));
vertex = cell(num_cs,1);Grid = cell(num_cs,1);
for j=1:num_cs
    vertex{j,1} =  CoorsTransformation(vertex_unit,theta(j),CenterCoors(j,:));
    Grid{j,1} =  CoorsTransformation(grid_unit,theta(j),CenterCoors(j,:));
end

end