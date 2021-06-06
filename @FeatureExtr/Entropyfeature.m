function Features_Entr =Entropyfeature(obj)
% compute entropy features over one segment of EEG data
%  [apen, sse, complexity]

%% prepare data
data_input=obj.eeg_segment;
n_channel=length(data_input); % 39
Features_Entr=cell(n_channel,1);% define cell
for i=1:n_channel
    data_temp=data_input{i};
    datasize=size(data_temp);
    
    features_temp=[];
    for j=1:datasize(2)
        signal=data_temp(:,j); % colum

        m=2; r=0.1;  % parameters for apen
        S = apen(obj, signal,m,r );  % apen
        %S = apen(signal,m,r );
        g  = sse2(obj,signal ) ;  % information entropy
        comp = complexity(obj,signal );  % complexity
        features_temp(:,j)=[S, g, comp];
    end
  Features_Entr{i}=features_temp;
end
Features_Entr;