function CrossEntropy = computeCrossEntropy(POM_base,POM_input)
% POM_base is a Nx2 array where the 1st col denotes the linear index of
% non-zeros voxels and the second col stores the corresponing POC
% 0 is represented by a very small number approaching 0 such as 1e-10
zero_proxy = min(POM_base(:,2))/10;
POM_input(POM_input(:,2)<zero_proxy,2) = zero_proxy;
idx_tem = find(POM_input(:,2)==1);
if ~isempty(idx_tem)
    POM_input(idx_tem,2) = 1-zero_proxy;
end
[lia,lob] = ismember(POM_base(:,1),POM_input(:,1));
lob = lob(lob>0);
CE_temp1 = -POM_base(lia,2).*log(POM_input(lob,2))-(1-POM_base(lia,2)).*...
    log(1-POM_input(lob,2));
CE_temp2 = -POM_base(~lia,2)*log(zero_proxy)-(1-POM_base(~lia,2))*...
    log(1-zero_proxy);
CrossEntropy = sum(CE_temp1)+sum(CE_temp2); 
% CrossEntropy = sum(CE_temp1)/length(CE_temp1)+sum(CE_temp2)/length(CE_temp2); 
% CrossEntropy = sum(CE_temp1)/length(CE_temp1);
end