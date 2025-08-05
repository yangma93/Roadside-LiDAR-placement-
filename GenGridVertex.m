function P_grid = GenGridVertex(P,angularRes,upperLeftCor)
P_grid = P;
switch length(angularRes(1,:))
    case 2 % 垂直角分辨率均匀
        P_grid(:,1) = round((P(:,1)-upperLeftCor(:,1))/angularRes(1))+1;
        P_grid(:,2) = round((upperLeftCor(:,2)-P(:,2))/angularRes(2))+1;

    case 5 % 垂直角分辨率不均匀
        P_grid(:,1) = round((P(:,1)-upperLeftCor(:,1))/angularRes(1))+1;
        % 水平角分辨率都是均匀的 angularRes =  [0.2 -20 5 1 0.5] 
        % -20 与 5分别是角度分辨率变化的临界值 
        % 1与 0.5 分别指代在密集分辨率区间内的角分辨率与区间外的分辨率
        idx_1 = P(:,2)>=angularRes(3);
        idx_2 = P(:,2)<angularRes(3) & P(:,2)>=angularRes(2);
        idx_3 = P(:,2)<angularRes(2);
        P_grid(idx_1,2) = round((upperLeftCor(:,2)-P(idx_1,2))/angularRes(4))+1;
        P_grid(idx_2,2) = round((upperLeftCor(:,2)-angularRes(3))/angularRes(4))+1 + ...
            round((angularRes(3)-P(idx_2,2))/angularRes(5));
        P_grid(idx_3,2) = round((upperLeftCor(:,2)-angularRes(3))/angularRes(4))+1 + ...
            round((angularRes(3)-angularRes(2))/angularRes(5)) + ...
            round((angularRes(2)-P(idx_3,2))/angularRes(4));
end
end