function KL = EstKLEntropy(POM_base,POM_input)
% idx_valid = POM_base<1;
% POM_base = POM_base(idx_valid,1);
% POM_input = POM_input(idx_valid,1);
num_grids = length(POM_base(:,1));
[N_gt,edges_gt] = histcounts(POM_base,'BinWidth',0.005);
[N_dt,edges_dt] = histcounts(POM_input,'BinWidth',0.005);
if length(N_gt)>length(N_dt)
    P_gt = N_gt/num_grids;
    P_dt = zeros(1,length(P_gt));
    bin_gt = 0.5*(edges_gt(1:end-1)+edges_gt(2:end));
    bin_dt = 0.5*(edges_dt(1:end-1)+edges_dt(2:end));
    [~,lob] = ismember(bin_dt,bin_gt);
    P_dt(lob) = N_dt/num_grids;
else
    P_dt = N_dt/num_grids;
    P_gt = zeros(1,length(P_dt));
    bin_gt = 0.5*(edges_gt(1:end-1)+edges_gt(2:end));
    bin_dt = 0.5*(edges_dt(1:end-1)+edges_dt(2:end));
    [~,lob] = ismember(bin_gt,bin_dt);
    P_gt(lob) = N_gt/num_grids;
end
zero_proxy = 1e-6;
P_gt(P_gt<zero_proxy) = zero_proxy;P_gt(P_gt>=1) = 1-zero_proxy;
P_dt(P_dt<zero_proxy) = zero_proxy;P_dt(P_dt>=1) = 1-zero_proxy;
% RE = P_gt.*log(P_gt./P_dt)+(1-P_gt).*log((1-P_gt)./...
%     (1-P_dt));
RE = P_gt.*log(P_gt./P_dt);
KL = sum(RE);
end