function fitness = EstFitness_MIN(x,POM_GT,PG_array,KL_thres)
num_rsl = sum(x);
PG = PG_array(logical(x));
voxelmap = zeros(length(POM_GT(:,1)),1);
for j=1:length(PG)
    voxelmap = voxelmap + PG{j};
end
voxelmap(voxelmap>POM_GT) = POM_GT(voxelmap>POM_GT);
KL = EstKLEntropy(POM_GT,voxelmap);
if KL>KL_thres
    penalty = 1e7*(KL-KL_thres);
else
    penalty = 0;
end
fitness = num_rsl + penalty;
end