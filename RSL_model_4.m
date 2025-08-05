%% Demarcate the ROI 
corner_point = [min(POM_grids(:,1)) min(POM_grids(:,2)) min(POM_grids(:,3))];
roi_POM = [corner_point(1) max(POM_grids(:,1)) corner_point(2) max(POM_grids(:,2)) ...
    corner_point(3) max(POM_grids(:,3))];
row_size = round((max(POM_grids(:,2))-corner_point(2))/gridSize)+1;
col_size = round((max(POM_grids(:,1))-corner_point(1))/gridSize)+1;
dep_size = round((max(POM_grids(:,3))-corner_point(3))/gridSize)+1;
row_num = round((POM_grids(:,2)-corner_point(2))/gridSize)+1;
col_num = round((POM_grids(:,1)-corner_point(1))/gridSize)+1;
dep_num = round((POM_grids(:,3)-corner_point(3))/gridSize)+1;
POM_sz = [row_size col_size dep_size];
idx_linear = sub2ind(POM_sz,row_num,col_num,dep_num);
clear row_num col_num dep_num

%% RSL parameters 
angularRes = [.2 .5]; %angular resolutions 
angleRange = [-180 180 -25 10]; % FOV
disRange = 80; % detection range 

%% create PG cell array for candidate RSL placements 
load RSL_candidates.mat
% RSL_candidates are pre-construted candidate RSL positions 
use_NRM = true; 

RSL_candidates = cell2mat(RSL_candidates);
RSL_candidates(:,6) = 0;
num_RSL_cfgs = length(RSL_candidates);
PG_array = cell(num_RSL_cfgs,1);
if use_NRM
    % NRM
    load net_res0_add1_sig.mat % Model 3 in the paper 
    for j=1:num_RSL_cfgs
        cfg = j % used to indicate the process of computing PG for each candidate RSL
        % Fig. 10 in the paper
        PG_array{j,1} = NRM(RSL_candidates(j,:),angleRange,angularRes,...
            disRange,roi_POM,POM_grids,POM_sz,idx_linear,gridSize,net_sigmoid);
    end
else
    % analytical method
    for j=1:num_RSL_cfgs
        cfg = j % used to indicate the process of computing PG for each candidate RSL
        % Fig. 10 in the paper
        PG_array{j,1} = EstRSLPlacement(RSL_candidates(j,:),angleRange,angularRes,...
            disRange,roi_POM,POM_grids,POM_sz,idx_linear,gridSize);
    end
end
POM_GT = double(POM_grids(:,4));
POM_GT = POM_GT(POM_GT<1,1);

%% randomly display 9 observed PG
Id_RSL = randperm(num_RSL_cfgs);
for k=1:9
    subplot(3,3,k)
    plotPOM(POM_grids_gt(:,1:3),PG_array{Id_RSL(k)},ROI,gridSize);
    title([num2str(Id_RSL(k)),'-th RSL'])
    % tunnel walls are not visualized 
end

%% plot KL-curve
KL_array = zeros(num_RSL_cfgs,1);
for j=1:num_RSL_cfgs
    voxelmap = PG_array{j,1};
    voxelmap(voxelmap>POM_GT) = POM_GT(voxelmap>POM_GT);
    KL_array(j,1) = EstKLEntropy(POM_GT,voxelmap);
end
[~,lob] = sort(KL_array,'ascend');

for i = 1:num_RSL_cfgs
    voxelmap = zeros(length(POM_GT(:,1)),1);
    for j= 1:i
        voxelmap = voxelmap + PG_array{lob(j),1};
    end
    voxelmap(voxelmap>POM_GT) = POM_GT(voxelmap>POM_GT);
    KL_array(j,1) = EstKLEntropy(POM_GT,voxelmap);
end
figure
plot(KL_array,'LineWidth',2,'Color',"b");
xlabel('RSL number','FontSize',18,'FontName','Segoe UI Emoji');
ylabel('KL divergence','FontSize',18,'FontName','Segoe UI Emoji')
ax = gca;ax.FontSize = 18;
clear voxelmap
clear ax