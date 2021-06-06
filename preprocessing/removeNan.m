function arr = removeNan(arr)
% remove samples (rows) including nan
tmp = sum(isnan(arr), 2);
arr(find(tmp>0),:)=[];
