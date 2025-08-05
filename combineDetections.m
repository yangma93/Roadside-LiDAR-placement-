function [capturedPts,pc_tem_f] = combineDetections(rawDepthData,configureMatrix,...
    DepthData_back)
% rawDepthData is a n*2 cell matrix where n denotes the number of RSUs
num_rsu = length(configureMatrix(:,1));
pc_tem_f = cell(num_rsu,1);
% pc_tem_b = cell(num_rsu,1);
for k=1:num_rsu
    map_back = DepthData_back{k};
%     lidar_back = LidarData_back{k};
    map_fore = rawDepthData{k,1}; agentIDMap_tem = rawDepthData{k,2};
    map_fore_depth = map_fore(:,:,3);
    thetaMap = map_fore(:,:,1);
    betaMap = map_fore(:,:,2);
    idx_tem = map_fore_depth~=0 & map_fore_depth<=map_back;
    [x,y,z] = sph2cart(thetaMap(idx_tem)*pi/180,betaMap(idx_tem)*pi/180,...
        map_fore_depth(idx_tem));
    pc_tem_f{k,1} = CoorsTrans_degree(configureMatrix(:,4),configureMatrix(:,5),...
        configureMatrix(:,6),[x y z],configureMatrix(:,1:3),k,2);
    pc_tem_f{k,1}(:,4)  = agentIDMap_tem(idx_tem);

%     idx_tem1 = map_fore_depth~=0 & map_fore_depth<=map_back;
%     lidar_back(idx_tem1,:) =[];
%     pc_tem_b{k,1} = lidar_back;
end
capturedPts = cell2mat(pc_tem_f);
end