function [Result,DL_struct] = ConvertDriveLine(DrivingLines,DL2)
% 输入特定方向的驾驶路径，可以半自动化获取Edge,Lane 和 Junction的相关信息
% ID 是字符变量，指代驾驶路径的方向

num = length(DrivingLines);
for k=1:num
DrivingLines{k} = DrivingLines{k}(1:4:end,:);
end
figure
plotPatches(DrivingLines);
if ~isempty(DL2)
    plotPatches(DL2);
end
junction_shape = ginput();
if ~isempty(junction_shape)
    plot(junction_shape(:,1),junction_shape(:,2),'ko-')
    Result.junction_shape = est_char(junction_shape);
    Temp_pos = mean(junction_shape);
    Result.junction_pos = horzcat(num2str(Temp_pos(1)),',',...
        num2str(Temp_pos(2)));
    boundary = vertcat(junction_shape,junction_shape(1,:));
    % lane shape & intLanes shape
    DL_struct = struct('lane_id',[],'length',[],'shape',[],'intLanes',[]);
    DL_struct = repmat(DL_struct,num,1);
    for j=1:num
        in = inpolygon(DrivingLines{j}(:,1),DrivingLines{j}(:,2),...
            boundary(:,1),boundary(:,2));
        if ~isempty(in)
            Temp_shape = DrivingLines{j}(in,1:2);
            plot(Temp_shape(:,1),Temp_shape(:,2),'ro','LineWidth',1.5);
            DL_struct(j).intLanes = est_char(Temp_shape);
            % segment driving lines
            idx_tem = find(in==true);
            if idx_tem(1)== 1 % 
                DL_struct(j).shape{2,1} = est_char(DrivingLines{j}(idx_tem(end):end,1:2));
                DL_struct(j).length(2,1) = ...
                    est_length(DrivingLines{j}(idx_tem(end):end,1:2));
            else
                DL_struct(j).shape{1,1} = ...
                    est_char(DrivingLines{j}(1:idx_tem(1),1:2));
                DL_struct(j).length(1,1) = ...
                    est_length(DrivingLines{j}(1:idx_tem(1),1:2));
                DL_struct(j).shape{2,1} = ...
                    est_char(DrivingLines{j}(idx_tem(end):end,1:2));
                DL_struct(j).length(2,1) = ...
                    est_length(DrivingLines{j}(idx_tem(end):end,1:2));
            end       
        end
    end
end

end


function length = est_length(Points)
gap = diff(Points(:,1:2));
gap = sum(gap.^2,2).^.5;
length = sum(gap);
end

function output = est_char(input)
output = [];
input = round(input*100)/100;
for k=1:length(input)
    if k==1
        output = horzcat(output,...
            [num2str(input(k,1)),',',...
            num2str(input(k,2))]); %#ok<*AGROW>
    else
        output = horzcat(output,...
            [' ',num2str(input(k,1)),',',...
            num2str(input(k,2))]);
    end
end
end
