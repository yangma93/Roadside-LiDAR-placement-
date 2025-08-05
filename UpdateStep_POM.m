function [Position,Dimension,Angle,AgentPts,FaceIdx,ID_array] = UpdateStep_POM(agentUnit,step)
Position = [];
Dimension =[];
Angle = [];
AgentPts = [];
FaceIdx = [];
ID_array = [];
idx = find(agentUnit.timeStamp>=step & agentUnit.timeStamp<step+1,1);
if ~isempty(idx)
    Position = agentUnit.trajectoryData(idx,:);
    Dimension = agentUnit.Dimension;
    if ~isempty(agentUnit.head_angle)
        Angle = agentUnit.head_angle(idx,1);% rad
        AgentPts = agentUnit.gridpoints;
        % AgentPts = agentUnit.Vertices;
        AgentPts(:,4) = agentUnit.ID_num;
        ID_array = agentUnit.ID_num;
        % ID_num can be used to segment agent points according to their ID
        FaceIdx = agentUnit.Faces;
    end
end
end