function Features_Entr =Entropyfeature2(obj,data_input)
% compute entropy features over one segment of EEG data
%  [apen, sse, complexity] - original 
%  [apen, complexity] - real results 
%% prepare data
n_channel=size(data_input,1); % 39

for ch=1:n_channel
    signal=data_input(ch,:);

    %% ApEn
        m=2; r=0.2; tau=1; % parameters for ApEn
        Apen2=fastApEn(obj, m, r, signal,tau); % fast ApEn
        %Apen1 = apen(obj, signal,m,r );  % slow ApEn
    %% L-Z Complexity
       Comp = complexity(obj,signal);  % complexity
     
    %% information entropy       
%       g  = sse2(obj,signal ) ;  % information entropy - error occur!
    %% save results
%       features_temp(ch,:)=[apen, g, comp];
        features_temp(ch,:)=[Apen2, Comp];

end
Features_Entr=features_temp;