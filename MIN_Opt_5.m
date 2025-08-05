%% MIN problem
%% GA application
rng default
lb = zeros(1,num_RSL_cfgs);
ub = ones(1,num_RSL_cfgs);
 
% parameter value specification
KL_thres = 0.2; 
% KL_thres 

% config GA
options = optimoptions('ga', ...
    'PopulationType', 'bitstring', ...
    'CreationFcn', @my_creation, ...
    'CrossoverFcn', @crossoversinglepoint, ...
    'MutationFcn', {@mutationuniform, 0.02}, ...
    'PopulationSize', 100, ...
    'MaxGenerations', 2000, ...
    'Display', 'iter', ...
    'UseParallel',true,...
    'PlotFcn', @gaplotbestf ...
);
options.FunctionTolerance = 1e-8;
[x_opt_ga, fval] = ga(@(x)EstFitness_MIN(x,POM_GT,PG_array,KL_thres), ...
    num_RSL_cfgs,[],[],[],lb,ub,[],[],options);
% x_opt_ga is a feasible point 

%% Greedy search 
for j = 1:fval
    RSL_num = j;
    [x_opt_greedy,KL_min] = GreedySearch(PG_array,POM_GT,lob,RSL_num);
    num_rsl_opt = length(x_opt_greedy);
    if KL_min<KL_thres
        break
    end
end
% x_opt_greedy corresponds to the index of optimized RSL
% num_rsl_opt = number of RSL
% KL_min = minimum KL value(should be less than KL_thres)

%% RSL node importance
entropy_array = zeros(RSL_num,1);
for i = 1:RSL_num
    voxelmap = zeros(length(POM_GT(:,1)),1);
    for j = 1:RSL_num
        if j~= i
            voxelmap_t = PG_array{x_opt_greedy(j),1};
            voxelmap = voxelmap_t + voxelmap;
        end
    end
    voxelmap(voxelmap>POM_GT) = POM_GT(voxelmap>POM_GT);
    entropy_array(i,1) = EstKLEntropy(POM_GT,voxelmap);
end
clear voxelmap voxelmap_t
IG = entropy_array- KL_min; % larger IG means more important 
IG_std = std(IG); % standard deviation of IG
IG_normalized = IG/sum(IG); % normalized IG


