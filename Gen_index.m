function index_linear = Gen_index(C_min,C_max,R_min,R_max,FaceID,ImSize) % Gen_index(P1,P2,P3,FaceID,ImSize)
% index_linear = [];
% if sum(Triangle(:,3))==3
%     Triangle = vertcat(P1,P2,P3);
% Triangle = reshape(P,2,numel(P)/2)';
% C_min = min(Triangle(:,1));
% C_max = max(Triangle(:,1));
% R_min = min(Triangle(:,2));
% R_max = max(Triangle(:,2));
% if R_min == R_max && C_min == C_max
%     index_linear = sub2ind(ImSize,R_min,C_min);
% else
[R,C] = meshgrid(R_min:1:R_max,C_min:C_max);
index_linear = sub2ind(ImSize,reshape(R,numel(R),1),reshape(C,numel(C),1));
% end
index_linear(:,2) = FaceID;
% end
end