function Features_Entr =ApEnfeature(obj)
% compute entropy features over one segment of EEG data
%  [apen, sse, complexity] - original 
%  [apen, complexity] - real results 
%% prepare data
data_input=obj.data;
n_channel=size(data_input,1); % 39
features_temp=[];
for ch=1:n_channel
    signal=data_input(ch,:);

    %% ApEn
    m=2; r=0.2; tau=1; % parameters for ApEn
    Apen2=fastApEn(obj, m, r, signal,tau); % fast ApEn
    %Apen1 = apen(obj, signal,m,r );  % slow ApEn
     
    %% save results
    features_temp(ch,:)=[Apen2];

end
Features_Entr=features_temp;