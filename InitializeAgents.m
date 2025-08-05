function agentCell = InitializeAgents(filepath)
%% data import 
csvData = importdata(filepath);
data_text = csvData.textdata;
data_numeric = csvData.data;
data_numeric(:,3) = [];
num_steps = length(data_text);
Timecell = data_text(:,2);
Idcell = data_text(:,1);
%% data conversion 
timeStamp = cellfun(@timeConvert,Timecell);
[Type_ind,ID] = cellfun(@IdConvert,Idcell,'UniformOutput',false);
[loc,lob] = sort(ID);
[ID_sorted,idx_change] = unique(loc,'sorted');
num_agents = length(ID_sorted);
%% agent definition
agentUnit = struct ('ID',[],'IDcell',[],'ID_num',[],'emergeTime',[],...
    'Dimension',[],'Count',1,'Type',[],'timeStamp',[],'trajectoryData',[],...
    'head_angle',[],'velocityDirection',[],'velocityScale',[],'Vertices',[],...
    'Faces',[]);
% Vertices and Faces store the information of mesh models depicting agents
agentCell = cell(num_agents,1);
if num_agents>2
idx_change = vertcat(idx_change,num_steps+1);
for i=1:num_agents
    idx_temp = lob(idx_change(i):idx_change(i+1)-1,:);
    agentTemp = agentUnit;
    agentTemp.ID = ID{idx_temp(1),1};
    agentTemp.timeStamp = timeStamp(idx_temp,:);
    agentTemp.emergeTime = agentTemp.timeStamp(1);
    agentTemp.Type = Type_ind{idx_temp(1),1};
    agentTemp.IDcell = data_text(idx_temp,1);
    agentTemp.trajectoryData = data_numeric(idx_temp,1:2);
    agentTemp.velocityScale = data_numeric(idx_temp,3)/3.6;% m/s
    temp_direct = diff(agentTemp.trajectoryData,1);
    temp_direct = temp_direct./(sum(temp_direct.^2,2).^.5);
    temp_direct = vertcat(temp_direct,temp_direct(end,:)); %#ok<*AGROW> 
    agentTemp.velocityDirection = temp_direct;
    agentCell{i} = agentTemp;
end
else
    agentCell =[];
    msgbox('no enough agents')
end

end

function seconds = timeConvert(time_origin)
idx_colon = find(time_origin == ':');
digit_sec = str2double(time_origin(idx_colon(2)+1:end));
digit_min = str2double(time_origin(idx_colon(1)+1:idx_colon(2)-1));
digit_hour = str2double(time_origin(1:idx_colon(1)-1));
seconds = digit_hour*3600+60*digit_min+digit_sec;

end

