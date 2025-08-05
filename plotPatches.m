function fig = plotPatches(P)
colorarray = 'rbgcmy';
hold on
for i=1:length(P)
k = mod(i,6)+1;
if ~isempty(P{i})
    switch length(P{i}(1,:))
        case 3
            fig = plot3(P{i}(:,1),P{i}(:,2),P{i}(:,3),[colorarray(k),'.'],'MarkerSize',6);
        case 4
            fig = plot3(P{i}(:,1),P{i}(:,2),P{i}(:,3),[colorarray(k),'.'],'MarkerSize',6);
        case 2
            fig = plot(P{i}(:,1),P{i}(:,2),[colorarray(k),'-'],'LineWidth',1);
    end
end
end
axis equal
end

