function path_interp = ClusterTrajectory(reduced_path,dis_thres,start_id)
% grouped_path = reduced_path;
idx_null = cellfun(@isempty,reduced_path);
Temp_path = reduced_path(~idx_null,:);
grouped_path = Temp_path;
num =  length(Temp_path);
dis_indicator = zeros(num,1);

for i=1:num
    Tem_points = Temp_path{i};
    p = polyfit(Tem_points(:,1),Tem_points(:,2),1);
    Temp_dis = abs(p(1)*Tem_points(:,1)+p(2)-Tem_points(:,2))./sqrt(p(1)^2+1);
    dis_indicator(i,:) = mean(Temp_dis);
end
grouped_path = grouped_path(dis_indicator>=dis_thres);
num_curves = length(grouped_path);
path_interp = cell(num_curves,1);
for i=1:num_curves
    Tem_points = grouped_path{i};
    ncs = cscvn(Tem_points(:,1:2)');
    Points = uniformKnots(ncs,0.001,0.2);
    Points(:,3) = i+start_id;
    % i is the id of trajectory data
    path_interp{i}= Points;
%     Temp_direct = Points(2:end,1:2)-Points(1:end-1,1:2);
% %     Temp_angle{i} = getAngle(Temp_direct,[0,1])*180/pi;
%     [N,edges] = histcounts(Temp_angle{i},'BinWidth',40);
%     idx  = find(N==max(N),1);
%     angle_range{i} = edges(idx:idx+1);
end
figure
plotPatches(path_interp);
end

