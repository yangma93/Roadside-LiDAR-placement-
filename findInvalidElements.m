function idx_unsafe = findInvalidElements(P1,P2,P3)
% P1,P2,P3 are spherical coordinates of triangle vertices
% index of P1 to P3 corresponds to the index of triangles 
side_ind = abs(sign(P1(:,1)) + sign(P2(:,1)) + sign(P3(:,1)));
diff_12 = abs(P2(:,1)-P1(:,1));
diff_23 = abs(P2(:,1)-P3(:,2));
diff_13 = abs(P3(:,1)-P1(:,1));
diff = max(horzcat(diff_12,diff_13,diff_23),[],2);
idx_unsafe = side_ind == 1 & diff>180;
end