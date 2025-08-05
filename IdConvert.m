function [Type_index,ID] = IdConvert(Id)
idx = find(Id =='.');
Type_index = Id(1:idx-1);
ID = Id;
end