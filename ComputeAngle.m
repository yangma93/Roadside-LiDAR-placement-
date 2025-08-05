function [head_angle,direct,points] = ComputeAngle(Track)
% Track is original path data whose interval is large
ncs = cscvn(Track');
points = uniformKnots(ncs,0.01,0.5);
temp_v = diff(points);
temp_v = temp_v./(sum(temp_v.^2,2).^0.5);
temp_v = vertcat(temp_v,temp_v(end,:));
temp_angle = acos(temp_v(:,1)); % rad
idx_neg = temp_v(:,2)<0;
temp_angle(idx_neg,1) = 2*pi-temp_angle(idx_neg,1);
dis_matrix = pdist2(Track,points);
ind = find(dis_matrix == min(dis_matrix,[],2));
sz = size(dis_matrix);
[~,col] = ind2sub(sz,ind);
head_angle = temp_angle(col,:);
direct = temp_v(col,:);

end