function ChID = getID_chSet(chSet, Ch)
% get the No. of 'Sel_ch' according to string set in Ch.
% Ch - {ch*1} cell
% chSet - e.g., {'P8', 'FCz', 'P7'}
% {'TP7', 'PO7' 'P7', 'P5', 'CP5'}
% {'Fz', 'Cz' 'FCz', 'FC1', 'FC2'}
% {'TP8', 'PO8' 'P8', 'P6', 'CP6'}

ChID = [];
for i = 1:length(chSet)
    loc=[]; 
    for j=1:length(Ch)
        temp = strmatch(chSet{i}, Ch{j},'exact');
        if ~isempty(temp) % match
            loc = j;
            break
        end
    end
    ChID(i)=loc;
end



