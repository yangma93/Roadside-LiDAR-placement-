function [] = plotPOM(POM,POM_index,ROI,gridsize)
if isempty(POM_index)
idx_occupied = find(POM~=0);
[row,col,dep] = ind2sub(size(POM),idx_occupied);
x_s = (col-1)*gridsize + ROI(1);
y_s = (row-1)*gridsize + ROI(3);
z_s = (dep-1)*gridsize + ROI(5);
% pt = pointCloud([x_s y_s z_s]);
% pt.Intensity = POM(idx_occupied);
% pcshow(pt,'Projection','orthographic','ColorSource','Intensity','BackgroundColor',[1 1 1])
s = repmat(10,length(x_s),1);
scatter3(x_s,y_s,z_s,s,POM(idx_occupied),'MarkerEdgeAlpha',0.4,...
    'MarkerFaceAlpha',0.4,'MarkerFaceColor','flat','Marker','square');
% hold on
else
    s = repmat(10,length(POM),1);
    scatter3(POM(:,1),POM(:,2),POM(:,3),s,POM_index,'MarkerEdgeAlpha',0.4,...
    'MarkerFaceAlpha',0.4,'MarkerFaceColor','flat','Marker','square');
end
colormap(gca,"turbo")
% idx_void = find(POM==0);
% [row,col,dep] = ind2sub(size(POM),idx_void);
% x_s = (col-1)*gridsize + ROI(1);
% y_s = (row-1)*gridsize + ROI(3);
% z_s = (dep-1)*gridsize + ROI(5);
% c = min(POM(idx_occupied),[],'all')*ones(length(x_s(:,1)),1)/10;
% scatter3(x_s,y_s,z_s,10,c,'MarkerEdgeAlpha',0.4,...
%     'MarkerFaceAlpha',0.4,'MarkerFaceColor','flat','Marker','square');
axis equal; box on
axis(ROI)
end
