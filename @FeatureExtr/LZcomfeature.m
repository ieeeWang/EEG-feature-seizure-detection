function Features_Entr =LZcomfeature(obj)
% compute entropy features over one segment of EEG data
%  [apen, sse, complexity] - original 
%  [apen, complexity] - real results 
%% prepare data
data_input=obj.data;
n_channel=size(data_input,1); % 39
features_temp=[];
for ch=1:n_channel
    signal=data_input(ch,:);

    %% L-Z Complexity
       Comp = complexity(obj,signal);  % complexity
     
    %% save results

        features_temp(ch,:)=[ Comp];

end
Features_Entr=features_temp;