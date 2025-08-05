function encode_v = VariableEncoding(p,L)
row_num = size(p,1);col_num = size(p,2);
freq_bands = reshape(repelem(2.^(0:(L-1)),1,size(p,1)),size(p,1),1,[]);
emb_period = [sin(freq_bands.*repmat(p,[1,1,L]));cos(freq_bands.*repmat(p,[1,1,L]))];
emb_sin = reshape(emb_period(1:row_num,:,:),row_num,col_num*L);
emb_cos = reshape(emb_period(row_num+1:end,:,:),row_num,col_num*L);
encode_v = zeros(size(p,1),2*L*size(p,2));
encode_v(:,1:2:end) = emb_sin;
encode_v(:,2:2:end) = emb_cos;encode_v(:,1:2:end) = emb_sin;
end