%% 隧道的点云模型导入
gridSize = 0.4;
tunnel_pt = pcread...
    ('E:\科研\学术论文\202502 curved tunnels\Codes\Validation\highway tunnel\tunnel_pt.ply');
% the address where the tunnel 3D model is stored 
tunnel_pt = pcdownsample(tunnel_pt,'gridAverage',gridSize);
TunnelGrids = tunnel_pt.Location;
RoadBoundary = TunnelGrids;
RoadBoundary(:,4) = -1; 
x_min = min(RoadBoundary(:,1));
x_max = max(RoadBoundary(:,1));
y_min = min(RoadBoundary(:,2));
y_max = max(RoadBoundary(:,2));
ROI = [x_min x_max y_min y_max min(RoadBoundary(:,3))...
    max(RoadBoundary(:,3))+2];
% -1 is used to differ tunnel background from foreground objects  

gen_grid = true;
if gen_grid
%% downsample agent points  
    H_array = zeros(num_agents,1);
    for j=1:num_agents
        pt_tem = pointCloud(agentCell{j}.gridpoints);
        pt_out = pcdownsample(pt_tem,'gridAverage',gridSize);
        agentCell{j}.gridpoints = pt_out.Location; %#ok<*SAGROW>
        H_array(j,1) = agentCell{j}.Dimension(3);
    end
    h_max = max(H_array); 
    clear H_array;
    h_array = 0:gridSize:h_max;
    if h_array(end)<h_max
        h_max = ceil(h_max/0.4)*0.4;
        h_array = horzcat(h_array,h_max);
    end

%% create Grid points of tunnel
    road_pt = pcread...
    ('E:\科研\学术论文\202502 curved tunnels\Codes\Validation\highway tunnel\tunnel_rd.ply');
    % the address where the tunnel road surface model is stored 
    road_pt = pcdownsample(road_pt,'gridAverage',gridSize);
    grid_plane = double(road_pt.Location);
    POM_grids = [];
    for i=1:length(h_array)
        grid_tem = grid_plane;
        grid_tem(:,3) = grid_tem(:,3)+h_array(i);
        POM_grids = vertcat(POM_grids,grid_tem); %#ok<*AGROW>
    end
    clear grid_tem RoadBound Grid x_min x_max y_min y_max
    % grid-based search
    % traffic flow part 
    corner_point = [min(POM_grids(:,1)) min(POM_grids(:,2)) min(POM_grids(:,3))];
    row_size = round((max(POM_grids(:,2))-corner_point(2))/gridSize)+1;
    col_size = round((max(POM_grids(:,1))-corner_point(1))/gridSize)+1;
    dep_size = round((max(POM_grids(:,3))-corner_point(3))/gridSize)+1;
    row_num = round((POM_grids(:,2)-corner_point(2))/gridSize)+1;
    col_num = round((POM_grids(:,1)-corner_point(1))/gridSize)+1;
    dep_num = round((POM_grids(:,3)-corner_point(3))/gridSize)+1;
    idx_linear = sub2ind([row_size col_size dep_size],row_num,col_num,dep_num);
    clear row_num col_num dep_num
    
    %% evelation interpolation
    x = min(grid_plane(:,1)):gridSize:max(grid_plane(:,1));
    y = min(grid_plane(:,2)):gridSize:max(grid_plane(:,2));
    [X,Y] = meshgrid(x,y);
    X = reshape(X,numel(X),1);
    Y = reshape(Y,numel(Y),1);
    Z = griddata(grid_plane(:,1),grid_plane(:,2),grid_plane(:,3),X,Y,'linear');
    basemap = [X Y Z];
    clear X; clear Y; clear Z;clear Points2Estimated
    clear x; clear y;clear rdSurPts;clear rd_basemap

    %% Use data structures
    basemap = basemap(~isnan(basemap(:,3)),:);
    [elemap,upperLeftCor,ImSize] = elevationMap(basemap,[gridSize gridSize]);
    for i=1:num_agents
        agentCell{i,1}.trajectoryData(:,3) = eleMapInterp...
            (agentCell{i,1}.trajectoryData(:,1:2),[gridSize gridSize],...
            upperLeftCor,ImSize,elemap); %#ok<*SAGROW>
    end
    % remove invalid trajectory points
    for i=1:length(agentCell)
        idx_in = find(agentCell{i,1}.trajectoryData(:,3)>0);
        if ~isempty(idx_in)
            agentCell{i,1}.timeStamp = agentCell{i,1}.timeStamp(idx_in,:);
            agentCell{i,1}.trajectoryData = agentCell{i,1}.trajectoryData(idx_in,:);
            agentCell{i,1}.head_angle = agentCell{i,1}.head_angle(idx_in,:);
            agentCell{i,1}.velocityDirection = agentCell{i,1}.velocityDirection(idx_in,:);
            agentCell{i,1}.velocityScale = agentCell{i,1}.velocityScale(idx_in,:);
        else
            agentCell{i,1} =[];
        end
    end
    isnull = cellfun(@isempty,agentCell);
    agentCell = agentCell(~isnull,:);
    clear idx_in isnull upperLeftCor ImSize
end


