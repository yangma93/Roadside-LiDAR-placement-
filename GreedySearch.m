function [x_opt,KL,voxelmap] = GreedySearch(PG_array,POM_GT,lob,RSL_num)
PG_array = PG_array(lob,:);
num_RSL_cfgs = length(PG_array);
x_opt = zeros(RSL_num,1);
voxelmap = zeros(length(POM_GT(:,1)),1);
RSL_idxarray = (1:num_RSL_cfgs)';
for i = 1:RSL_num
    clear KL_temp
    num_cfg_remain = length(RSL_idxarray);
    for j=1:num_cfg_remain
        voxelmap_t = PG_array{RSL_idxarray(j),1} + voxelmap;
        voxelmap_t(voxelmap_t>POM_GT) = POM_GT(voxelmap_t>POM_GT);
        KL_temp(j,1) = EstKLEntropy(POM_GT,voxelmap_t); %#ok<*AGROW,*SAGROW>
    end
    idx_temp = find(KL_temp==min(KL_temp),1);
    voxelmap = voxelmap + PG_array{RSL_idxarray(idx_temp),1};
    KL = KL_temp(idx_temp,1);
    x_opt(i,1) = RSL_idxarray(idx_temp);
    RSL_idxarray(idx_temp,:)= [];
end
x_opt = lob(x_opt,1);
end
