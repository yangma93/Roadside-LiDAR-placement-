function [elemap,upperLeftCor,ImSize,ROI] = elevationMap(Points,cellSize)
numOfPoints = length(Points(:,1));
xGap = cellSize(1);
yGap = cellSize(2);
upperLeftCor = [min(Points(:,1)) max(Points(:,2))];
ROI = [min(Points(:,1)) max(Points(:,1)) min(Points(:,2)) max(Points(:,2))];
Dis(:,1) = round((Points(:,1)-upperLeftCor(:,1))/xGap)+1;
Dis(:,2) = abs(round((Points(:,2)-upperLeftCor(:,2))/yGap))+1;
ImSize = [max(Dis(:,2)) max(Dis(:,1))];
elemap = zeros(ImSize);
Index = sub2ind(ImSize,Dis(:,2),Dis(:,1));
[linearIndex,lob] = sort(Index,'ascend');
Points = Points(lob,:);
idxDiff  = diff(linearIndex);
idOfChange = find(idxDiff>0);
idOfChange = [0;idOfChange;numOfPoints];
numOfCells = length(idOfChange)-1;
z = zeros(numOfCells,1);
for i =1:numOfCells
    idx = idOfChange(i)+1:idOfChange(i+1);
    z(i,:) = mean(Points(idx,3));
end
elemap(linearIndex) = z;
end