%% import path file generated with SUMO tool
[ReadTrajecFileName,ReadTrajecPathName,ReadTrajecFilterIndex] = ...
    uigetfile({'*.*','AllFile(*.*)';'*.xlsx;*.txt;*.csv;*.dat',...
    'ExcelFile(*.xlsx,*.xls,*.csv)';...
    '*.xlsx','TxtFile(*.txt)'},'ReadTrajecfile',...
    'MultiSelect','on',...
    'C:\Users\user\Documents\MATLAB'); %set default path
if isequal(ReadTrajecFileName,0) || isequal(ReadTrajecPathName,0) ...
        || isequal(ReadTrajecFilterIndex,0)
    msgbox('fail to import trajectory data');
else
    filename = horzcat(ReadTrajecPathName,ReadTrajecFileName);
    agentCell = InitializeAgents(filename);
    msgbox('trajectory data import successfully');
end
%% head angle computation 
num_agents = length(agentCell);
for i=1:num_agents
    [agentCell{i}.head_angle,agentCell{i}.velocityDirection] = ...
        ComputeAngle(agentCell{i}.trajectoryData);
    agentCell{i}.ID_num = i;
end
clear ReadTrajecFileName; clear ReadTrajecPathName; clear ReadTrajecFilterIndex

%% 3d mesh model importing
[ReadModelFileName,ReadModelPathName,ReadModelFilterIndex] = ...
    uigetfile({'*.*','AllFile(*.*)';'*.xlsx;*.txt;*.csv;*.dat',...
    'ExcelFile(*.xlsx,*.xls,*.csv)';...
    '*.xlsx','TxtFile(*.txt)'},'ReadTrajecfile',...
    'MultiSelect','on',...
    'C:\Users\user\Documents\MATLAB'); %set default path
if isequal(ReadModelFileName,0) || isequal(ReadModelPathName,0) ...
        || isequal(ReadModelFilterIndex,0)
    msgbox('incorrect file folder');
else
    vTypefile = horzcat(ReadModelPathName,ReadModelFileName);
    csvData = importdata(vTypefile);
    msgbox('agent mesh model import successfully');
end

% create model repository 
temp_name =  unique(csvData(:,2));
for  i=1:length(temp_name)
    b = readSurfaceMesh(horzcat(ReadModelPathName,temp_name{i},'.stl')); %#ok<*NASGU> 
    eval([temp_name{i},'=b;']);
    % eval([temp_name{i},'=b;']);
end
clear b
for i=1:num_agents
  % Tem_class = MatchModel(csvData,{agentCell{i}.Type});
    [~,Tem_idx] = ismember(agentCell{i}.Type,csvData(:,1));
    Tem_class = csvData{Tem_idx,2};
    eval(['Tem_model =',Tem_class,';']); %#ok<*EVLEQ> 
    agentCell{i}.Faces = double(Tem_model.Faces);
    agentCell{i}.Vertices = Tem_model.Vertices;
    agentCell{i}.Dimension(1,1) = max(agentCell{i}.Vertices(:,2))-...
        min(agentCell{i}.Vertices(:,2));
    agentCell{i}.Dimension(1,2) = max(agentCell{i}.Vertices(:,1))-...
        min(agentCell{i}.Vertices(:,1));
    agentCell{i}.Dimension(1,3) = max(agentCell{i}.Vertices(:,3))-...
        min(agentCell{i}.Vertices(:,3));
    agentCell{i}.Vertices(:,1) = agentCell{i}.Vertices(:,1) - ...
        min(agentCell{i}.Vertices(:,1))- ( agentCell{i}.Dimension(1,2))/2;
%     agentCell{i}.Vertices(:,2) = agentCell{i}.Vertices(:,2) - ...
%         min(agentCell{i}.Vertices(:,2))- (agentCell{i}.Dimension(1,1))/2;
    agentCell{i}.Vertices(:,2) = agentCell{i}.Vertices(:,2) - ...
        max(agentCell{i}.Vertices(:,2));
    agentCell{i}.Vertices(:,3) = agentCell{i}.Vertices(:,3) - ...
        min(agentCell{i}.Vertices(:,3));  
end
clear Tem_class;clear Tem_model; clear Tem_idx
for i=1:length(temp_name)
    eval(['clear ',temp_name{i},';']);
end
% clear temporary models 

%% 3D point model import 
[ReadModelFileName,ReadModelPathName,ReadModelFilterIndex] = ...
    uigetfile({'*.*','AllFile(*.*)'},'ReadTrajecfile',...
    'MultiSelect','on',...
    'C:\Users\user\Documents\MATLAB'); %set default path
if isequal(ReadModelFileName,0) || isequal(ReadModelPathName,0) ...
        || isequal(ReadModelFilterIndex,0)
    msgbox('incorrect file folder');
else
    vTypefile = horzcat(ReadModelPathName,ReadModelFileName);
    csvData = importdata(vTypefile);
    msgbox('agent point model import successfully');
end
% create model repsitory 
temp_name =  unique(csvData(:,1));
for  i=1:length(temp_name)
    b = pcread(horzcat(ReadModelPathName,temp_name{i},'.ply')); %#ok<*NASGU> 
    eval([temp_name{i},'=b;']);
end
clear b
for i=1:num_agents
  % Tem_class = MatchModel(csvData,{agentCell{i}.Type});
    [~,Tem_idx] = ismember(agentCell{i}.Type,csvData(:,1));
    Tem_class = csvData{Tem_idx,1};
    eval(['Tem_model =',Tem_class,';']); %#ok<*EVLEQ> 
    agentCell{i}.gridpoints = Tem_model.Location;
    agentCell{i}.gridpoints(:,1) = agentCell{i}.gridpoints(:,1) - ...
        min(agentCell{i}.gridpoints(:,1))- ( agentCell{i}.Dimension(1,2))/2;
    agentCell{i}.gridpoints(:,2) = agentCell{i}.gridpoints(:,2) - ...
        min(agentCell{i}.gridpoints(:,2))- (agentCell{i}.Dimension(1,1))/2;
    agentCell{i}.gridpoints(:,3) = agentCell{i}.gridpoints(:,3) - ...
        min(agentCell{i}.gridpoints(:,3));  
end
clear Tem_class;clear Tem_model; clear Tem_idx
for i=1:length(temp_name)
    eval(['clear ',temp_name{i},';']);
end
clear ReadModelFileName ReadModelPathName ReadModelFilterIndex vTypefile filename
clear csvData temp_name 