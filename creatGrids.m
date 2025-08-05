function gridpoints = creatGrids(Dimension,Gridsize)
% Dimension = [length width height];
x = -Dimension(2)/2:Gridsize:Dimension(2)/2;
if x(end)~=Dimension(2)/2
    x = horzcat(x,Dimension(2)/2);
end
% y = -Dimension(1)/2:Gridsize:Dimension(1)/2;
% if y(end)~=Dimension(1)/2
%     y = horzcat(y,Dimension(1)/2);
% end
% if the position denotes the front bump 
y = -Dimension(1):Gridsize:0;
if y(end)~=0
    y = horzcat(y,0);
end

z = 0:Gridsize:Dimension(3); 
if z(end)~=Dimension(3)
    z = horzcat(z,Dimension(3));
end
[X,Y] = meshgrid(x,y);
M = [reshape(X,numel(X),1) reshape(Y,numel(Y),1)];
M(:,3) = Dimension(3);
P_l = zeros(length(y),2);P_r = zeros(length(y),2);
P_l(:,1) = -Dimension(2)/2; P_r(:,1) = Dimension(2)/2;
P_l(:,2) = y';P_r(:,2) = y';
P_u = zeros(length(x),2);P_d = zeros(length(x),2);
P_u(:,1) = x';
% P_u(:,2) = Dimension(1)/2;
P_u(:,2) = 0;
P_d(:,1) = x';
% P_d(:,2) = -Dimension(1)/2;
P_d(:,2) = -Dimension(1);

P = vertcat(P_l,P_u,P_r,P_d);
M1 = [];
for i=1:length(z)-1
    P(:,3) = z(i);
    M1 = vertcat(M1,P); %#ok<*AGROW> 
end
gridpoints = vertcat(M,M1);
end