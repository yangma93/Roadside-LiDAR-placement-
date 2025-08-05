function model_name = MatchModel(vTypefile,Type)
num_id = length(vTypefile(:,1));
Typecell = repmat(Type,num_id,1);
ind = cellfun(@isequal,vTypefile(:,1),Typecell);
model_name = vTypefile(ind,2);
end