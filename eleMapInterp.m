function elevation = eleMapInterp(Points,cellSize,upperLeftCor,ImSize,elemap)
xGap = cellSize(1);
yGap = cellSize(2);
Dis(:,1) = round((Points(:,1)-upperLeftCor(:,1))/xGap)+1;
Dis(:,2) = abs(round((Points(:,2)-upperLeftCor(:,2))/yGap))+1;
Index = sub2ind(ImSize,Dis(:,2),Dis(:,1));
elevation = elemap(Index);
end