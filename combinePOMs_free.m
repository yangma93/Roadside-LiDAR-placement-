function POM_com = combinePOMs_free(POMs)
% POMs is a cell array which contains POM to be combined
POM_com = POMs{1};
num_pom = length(POMs);
if num_pom<2
    POM_com = POMs{1};
else
    for j=2:num_pom
        POM_temp = POMs{j};
        [lia,lob] = ismember(POM_temp(:,1),POM_com(:,1));
        idx = lob(lob>0);
        if ~isempty(idx)
            POM_com(idx,2) = max(POM_com(idx,2),POM_temp(lia,2));
            % we use maxout in this case
            POM_com = vertcat(POM_com,POM_temp(~lia,:)); %#ok<*AGROW>
        else
            POM_com = vertcat(POM_com,POM_temp);
        end
    end
end
end