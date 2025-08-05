function voxelmap = NRM(RSU_config,angleRange,angularRes,...
    disRange,roi_POM,POM_grids,POM_sz,idx_linear,gridSize,net)
% RSU_config: configureMatrix Nx6 matrix where row corresponds to RSUs
num_rsu = length(RSU_config(:,1));
feature_temp = cell(num_rsu,1);
Sz_cell = cell(num_rsu,1);
Idx_cell = cell(num_rsu,1);
In_cell = cell(num_rsu,1);
InFOV_cell = cell(num_rsu,1);
[x,y,z] = createGrids(angleRange,angularRes,disRange,gridSize);
for j = 1:num_rsu
    [Sz_cell{j,1},Idx_cell{j,1},In_cell{j,1}] = createVoxelPos(x,y,z,...
        RSU_config(j,:),gridSize,POM_sz,roi_POM);
    LocalPoints = CoorsTrans_degree(RSU_config(:,4),RSU_config(:,5),...
        RSU_config(:,6),POM_grids(:,1:3),RSU_config(:,1:3),j,1);
    [sphereData(:,1),sphereData(:,2),sphereData(:,3)] = cart2sph(LocalPoints(:,1),...
        LocalPoints(:,2),LocalPoints(:,3));
    sphereData(:,1:2) = sphereData(:,1:2)*180/pi;
    feature_temp{j,1}(:,4) = sphereData(:,3); % depth features
    feature_temp{j,1}(:,1) = LocalPoints(:,1)./sphereData(:,3);
    feature_temp{j,1}(:,2) = LocalPoints(:,2)./sphereData(:,3);
    feature_temp{j,1}(:,3) = LocalPoints(:,3)./sphereData(:,3);
    InFOV_cell{j,1} = sphereData(:,1)>=angleRange(1) & sphereData(:,1)<=angleRange(2) & ...
    sphereData(:,2)>=angleRange(3) & sphereData(:,2)<= angleRange(4) & ...
    sphereData(:,3)<= disRange;
end
num_grids=  length(POM_grids(:,1));
for m = 1:num_rsu
    accOcclusion = zeros(num_grids,1);
    sigma_voxel = zeros(num_grids,1);
    Sz = Sz_cell{m,1};
    in = In_cell{m,1};
    idx_linear_tem = Idx_cell{m,1};
    RayMatrix = gpuArray(zeros(Sz));
    [~,lob] = ismember(idx_linear_tem,idx_linear);
    RayMatrix(in(lob>0)) = POM_grids(lob(lob>0),4);
    sigma_voxel(lob(lob>0),1) = RayMatrix(in(lob>0));
    RayMatrix_r = 1-RayMatrix;
    Temp_Prob = cumprod(RayMatrix_r,2);
    Temp_Prob(:,2:end) = Temp_Prob(:,1:end-1);
    Temp_Prob(:,1) = 1;
    accOcclusion(lob(lob>0),1) = Temp_Prob(in(lob>0));
    feature_temp{m,1}(:,6) = accOcclusion;
    feature_temp{m,1}(:,5) = sigma_voxel;
    feature_temp{m,1}(~InFOV_cell{m},6) = 0;
end
% compute final feature array
voxelmap_entire = zeros(num_rsu*num_grids,1);
feature_vector = cell2mat(feature_temp);
feature_input = horzcat(VariableEncoding(feature_vector,3),feature_vector);
idx_valid = feature_vector(:,6)>0;
voxelmap_entire(idx_valid,:) = predict(net,feature_input(idx_valid,:));
voxelmap = zeros(num_grids,1);
for k=1:num_rsu
    voxelmap_t = voxelmap_entire((k-1)*num_grids+1:k*num_grids,1);
    voxelmap = voxelmap +voxelmap_t;
end
voxelmap(voxelmap>POM_grids(:,4)) = POM_grids(voxelmap>POM_grids(:,4),4);
idx_valid = POM_grids(:,4)<1;
voxelmap = voxelmap(idx_valid,1);
end
