function objective = objectiveFunction(x,POM_GT,PG_array)
PG = PG_array(x);
voxelmap = zeros(length(POM_GT(:,1)),1);
for j=1:length(PG)
    voxelmap = voxelmap + PG{j};
end
voxelmap(voxelmap>POM_GT) = POM_GT(voxelmap>POM_GT);
objective = EstKLEntropy(POM_GT,voxelmap);
end