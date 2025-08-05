function voxelmap = EstRSLPlacement_gpuFree(RSU_config,angleRange,angularRes,...
    disRange,roi_POM,POM_grids,POM_sz,idx_linear)
% RSU_config: configureMatrix Nx6 matrix where row corresponds to RSUs
% example: [input,response] = CreateTrainingInstance(agentCell,agentCell_dect,
% configureMatrix_isu)
gridSize = 0.4;
num_rsu = length(RSU_config(:,1));
Sz_cell = cell(num_rsu,1);
Idx_cell = cell(num_rsu,1);
In_cell = cell(num_rsu,1);
[x,y,z] = createGrids(angleRange,angularRes,disRange,gridSize);
for j = 1:num_rsu
    [Sz_cell{j,1},Idx_cell{j,1},In_cell{j,1}] = createVoxelPos(x,y,z,...
        RSU_config(j,:),gridSize,POM_sz,roi_POM);
end
voxelmap = zeros(length(POM_grids(:,1)),1);
num_grids=  length(POM_grids(:,1));
for m = 1:num_rsu
    voxelmap_t = zeros(num_grids,1);
    Sz = Sz_cell{m,1};
    in = In_cell{m,1};
    idx_linear_tem = Idx_cell{m,1};
    RayMatrix = zeros(Sz);
    [~,lob] = ismember(idx_linear_tem,idx_linear);
    RayMatrix(in(lob>0)) = POM_grids(lob(lob>0),4);
    RayMatrix_r = 1-RayMatrix;
    Temp_Prob = cumprod(RayMatrix_r,2);
    Temp_Prob(:,2:end) = Temp_Prob(:,1:end-1);
    Temp_Prob(:,1) = 1;
    POB = Temp_Prob.*RayMatrix;
    voxelmap_t(lob(lob>0),1) = POB(in(lob>0));
    voxelmap = voxelmap_t + voxelmap;
end
voxelmap(voxelmap>POM_grids(:,4)) = POM_grids(voxelmap>POM_grids(:,4),4);
idx_valid = POM_grids(:,4)<1;
voxelmap = voxelmap(idx_valid,1);
end

% function CrossEntropy = EstKLEntropy(POM_base,POM_input)
% idx_valid = POM_base<1;
% POM_base = POM_base(idx_valid,1);
% POM_input = POM_input(idx_valid,1);
% zero_proxy = 1e-4;
% POM_input(POM_input<zero_proxy,:) = zero_proxy;
% POM_input(POM_input>=1,:) = 1-zero_proxy;
% POM_base(POM_base<zero_proxy,:) = zero_proxy;
% POM_base(POM_base>=1,:) = 1-zero_proxy;
% % CE = -POM_base.*log(POM_input)-(1-POM_base).*log(1-POM_input);
% CE = POM_base.*log(POM_base./POM_input)+(1-POM_base).*log((1-POM_base)./...
%     (1-POM_input));
% CrossEntropy = sum(CE);
% end

