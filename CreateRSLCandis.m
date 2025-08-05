function [CenterCoors,RSL_candidates] = CreateRSLCandis(Height,Width,Radius,delta_l,delta_h,isplot) 

% 生成RSL的候选位置，Height,Width与Radius参数要与生成隧道时保持一致
% height是隧道顶部到地面的距离，Width车道总宽度，
% Radius 是隧道的平面曲线半径值 
% delta_l 是RSL沿着道路纵向的平均间隔，建议正整数
% delta_h 是RSL沿着道路横向的平均间隔，建议正整数

angular_res = delta_l/Radius;
theta = pi:-angular_res:0;
rho = repmat(Radius,1,length(theta));
[x,y] = pol2cart(theta,rho);
CenterCoors = [x' y'];
CenterCoors(:,3) = 0;

lateral_clear = 1.5;
chord_length = Width+lateral_clear*2;
radius_cross = sqrt(Height^2+0.25*chord_length^2/(2*Height));

if radius_cross>Height 
    C = radius_cross-Height;
    angle = acos(C/radius_cross);
    angle_array = angle+pi/2:-pi/90:pi/2-angle;
    rho = repmat(radius_cross,1,length(angle_array));
    x_arc = pol2cart(angle_array,rho);
else
    angle = acos(0.5*chord_length/radius_cross);
    angle_array_1 = -pi+angle:-pi/90:-pi;
    angle_array_2 = pi:-pi/90:-angle;
    angle_array = horzcat(angle_array_1,angle_array_2);
    rho = repmat(radius_cross,1,length(angle_array));
    x_arc = pol2cart(angle_array,rho);
end
RSL_road_x = x_arc(end)-2:-delta_h:x_arc(1)+2;
if RSL_road_x(end) ~= x_arc(1)-2
    RSL_road_x = horzcat(RSL_road_x,x_arc(1)+2);
end
r = repmat(radius_cross,1,length(RSL_road_x));
if radius_cross>Height^2+0.25*chord_length^2
    C = radius_cross-Height;
    RSL_road_y = sqrt(r.^2-RSL_road_x.^2)-1-C;
else
    C = Height - radius_cross;
    RSL_road_y = sqrt(r.^2-RSL_road_x.^2)-1+C;
end
vertex_unit = zeros(length(RSL_road_x),3);
vertex_unit(:,1) = RSL_road_x'; 
vertex_unit(:,3) = RSL_road_y';

num_cs = length(CenterCoors(:,1));
RSL_candidates = cell(num_cs,1);
for j=1:num_cs
    RSL_candidates{j,1} =  CoorsTransformation(vertex_unit,theta(j),CenterCoors(j,:));
end

if isplot
    plotPatches(RSL_candidates);
end
end