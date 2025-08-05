function [face_vertex,CenterCoors,vertex] = CreateTunnel(Height,Width,Radius,isplot) 

% 使用抛物线/圆曲线作为隧道的截面线形
% height是隧道顶部到地面的距离，Width车道总宽度，
% Radius 是隧道的平面曲线半径值 

delta_l = 5;
angular_res = delta_l/Radius;
theta = pi:-angular_res:0;
rho = repmat(Radius,1,length(theta));
[x,y] = pol2cart(theta,rho);
CenterCoors = [x' y'];
CenterCoors(:,3) = 0;

lateral_clear = 1.5;
chord_length = Width+lateral_clear*2;
radius_cross = sqrt(Height^2+0.25*chord_length^2/(2*Height));
warning("off")
if radius_cross>Height 
    C = radius_cross-Height;
    angle = acos(C/radius_cross);
    angle_array = angle+pi/2:-pi/90:pi/2-angle;
    rho = repmat(radius_cross,1,length(angle_array));
    [x_arc,y_arc] = pol2cart(angle_array,rho);
    y_arc = y_arc-C;
else
    % C = sqrt(radius_cross^2-0.25*chord_length^2);
    C = Height - radius_cross;
    angle = acos(0.5*chord_length/radius_cross);
    angle_array_1 = -pi+angle:-pi/90:-pi;
    angle_array_2 = pi:-pi/90:-angle;
    angle_array = horzcat(angle_array_1,angle_array_2);
    rho = repmat(radius_cross,1,length(angle_array));
    [x_arc,y_arc] = pol2cart(angle_array,rho);
    y_arc = y_arc+C;
end
x_road = x_arc(end):-5:x_arc(1);
if x_road(end) == x_arc(1)
    x_road(end) = x_arc(1)+1;
end
y_road = zeros(1,length(x_road));
x_arc = horzcat(x_arc,x_road);
y_arc = horzcat(y_arc,y_road);
vertex_unit = zeros(length(x_arc),3);
vertex_unit(:,1) = x_arc'; 
vertex_unit(:,3) = y_arc';

num_cs = length(CenterCoors(:,1));
vertex = cell(num_cs,1);
for j=1:num_cs
    vertex{j,1} =  CoorsTransformation(vertex_unit,theta(j),CenterCoors(j,:));
end

num_vertex_per = length(vertex_unit);
face_vertex_1 = zeros(num_vertex_per,3);
face_vertex_2 = zeros(num_vertex_per,3);

% 第一个三角单元的顶点编号
face_vertex_1(1:num_vertex_per-1,1) = (1:num_vertex_per-1)';
face_vertex_1(1:num_vertex_per-1,2) =  ...
    face_vertex_1(1:num_vertex_per-1,1) +1;
face_vertex_1(1:num_vertex_per-1,3) = ...
    face_vertex_1(1:num_vertex_per-1,1) +1 + num_vertex_per;

face_vertex_1(1:num_vertex_per-1,1) = (1:num_vertex_per-1)';
face_vertex_1(num_vertex_per,:) = [num_vertex_per 1 num_vertex_per+1];

% 第二个三角单元的顶点编号
face_vertex_2(1:num_vertex_per-1,1) = (1:num_vertex_per-1)';
face_vertex_2(1:num_vertex_per-1,2) =  ...
    face_vertex_2(1:num_vertex_per-1,1) + num_vertex_per+1;
face_vertex_2(1:num_vertex_per-1,3) =  ...
    face_vertex_2(1:num_vertex_per-1,1) + num_vertex_per;
face_vertex_2(num_vertex_per,:) = [num_vertex_per num_vertex_per+1 2*num_vertex_per];

idx_temp = 0:num_cs-2;
idx_temp = repmat(idx_temp,num_vertex_per,1);
idx_temp = reshape(idx_temp,numel(idx_temp),1)*num_vertex_per;
face_vertex_1 = repmat(face_vertex_1,num_cs-1,1);
face_vertex_2 = repmat(face_vertex_2,num_cs-1,1);
face_vertex_1 = face_vertex_1 + idx_temp;
face_vertex_2 = face_vertex_2 + idx_temp;

face_vertex = vertcat(face_vertex_1,face_vertex_2);

if isplot
    Vertices = cell2mat(vertex);
    trimesh(face_vertex,Vertices(:,1),Vertices(:,2),Vertices(:,3));axis equal
    % hold on
    % plotPatches(vertex);
end
end