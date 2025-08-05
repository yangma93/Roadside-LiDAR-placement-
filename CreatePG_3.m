%% Get final step of simualtion 
out_stamp = zeros(num_agents,1);
for j=1:num_agents
    out_stamp(j,1) = agentCell{j}.timeStamp(end);
end
final_step = max(out_stamp);
clear out_stamp
POM_grids_gt = POM_grids;
IoU_metric = zeros(final_step,1);
ProcTime = zeros(final_step,1);
agentCount = zeros(final_step,1);
POM_index = zeros(length(POM_grids_gt),1);

%% PG creation
for i = 1:final_step
    step = i/final_step %#ok<NOPTS>
    % 'step' is used to indicate the process of PG creation 
    tic
    step_cell = num2cell(i);
    step_cell = repmat(step_cell,num_agents,1);
    [Position,Dimension,Angle,AgentPts,FaceIndex,ID_array] = cellfun(@UpdateStep_POM,...
        agentCell,step_cell,'UniformOutput',false);
    isnull = cellfun(@isempty,Position);
    idx_inside = find(isnull == false);
    if ~isempty(idx_inside)
        P_in_temp = cell2mat(Position(idx_inside,:));
        idx_in_temp = P_in_temp(:,1)>=ROI(1) & P_in_temp(:,1)<=ROI(2) & ...
            P_in_temp(:,2)>=ROI(3) & P_in_temp(:,2)<=ROI(4);
        idx_inside = idx_inside(idx_in_temp,:);
        if ~isempty(idx_inside)
            num_inside = length(idx_inside);
            agentCount(i,1) = num_inside;
            P_in = Position(idx_inside,:);
            Size_in = Dimension(idx_inside,:);
            Ag_in = Angle(idx_inside,:);
            ID_inside = cell2mat(ID_array(idx_inside,:));
            Model = AgentPts(idx_inside,:);
            FaceIdx = FaceIndex(idx_inside,:);

            %% 3D models alignment
            if num_inside>150
                parfor j=1:num_inside
                    Model{j,1} = RotateModels(Model{j,1},Ag_in{j,1},P_in{j,1});
                end
            else
                for j=1:num_inside
                    Model{j,1} = RotateModels(Model{j,1},Ag_in{j,1},P_in{j,1});
                end
            end
            Model_Pts = cell2mat(Model); 
            % kd-tree based search 
            % Idx_tem = rangesearch(Mdl,Model_Pts(:,1:3),gridSize);
            % Idx_array_tem = unique(cell2mat(Idx_tem'));
            % POM_index(Idx_array_tem,1) = POM_index(Idx_array_tem,1) +1;

            % grid-based search      
            row_num = round((Model_Pts(:,2)-corner_point(2))/gridSize)+1;
            col_num = round((Model_Pts(:,1)-corner_point(1))/gridSize)+1;
            dep_num = round((Model_Pts(:,3)-corner_point(3))/gridSize)+1;
            idx_out_row = row_num<1|row_num>row_size;
            idx_out_col = col_num<1|col_num>col_size;
            idx_out_dep = dep_num<1|dep_num>dep_size;
            idx_out = logical(idx_out_dep+idx_out_col+idx_out_row);
            idx_linear_tem = sub2ind([row_size col_size dep_size],...
                row_num(~idx_out,:),col_num(~idx_out,:),dep_num(~idx_out,:));
            [~,lob] = ismember(idx_linear_tem,idx_linear);
            POM_index(lob(lob>0),1) = POM_index(lob(lob>0),1) +1; 
            % Eq. (1) in the paper 
        end
        ProcTime(i,1) = toc;
    end
end
clear idx_out_row idx_out_col idx_out_dep

%% compute original PG
POM_index = POM_index/final_step;
POM_grids_gt = horzcat(POM_grids_gt,POM_index);
TunnelGrids(:,4) = 1; 
% PG values correspond to tunnel walls equal 1.0 
POM_grids_gt = POM_grids_gt(POM_grids_gt(:,4)>0,:);
POM_grids = vertcat(POM_grids_gt,TunnelGrids);
plotPOM(POM_grids(:,1:3),POM_grids(:,4),ROI,gridSize);
title('original PG')
ax = gca;
ax.FontSize =24;
% visualize the original PG 
