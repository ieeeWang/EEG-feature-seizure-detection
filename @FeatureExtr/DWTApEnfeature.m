function Features =DWTApEnfeature(obj)
% compute DWT-based ApEn features on EEG data in a sliding window

% set parameters
% Fs = obj.sample_rate;                  
% T = 1/Fs;  
data_input=obj.data;

Features =[];% [ch*7]
n_channel=size(data_input,1); 
for ch=1:n_channel
    %% DWT set
    coef_set=[];% DWT set
    y=data_input(ch,:);
    % set parameters
    levels=6;
    [C,L]= wavedec(y,levels,'db4');  
    % Reconstruct single branch from 1-D wavelet coefficients
    a=wrcoef('a',C,L,' db4',levels);    
    % get stadard deveation of each level coefficient
    d=[]; % [levels*time]
    for i=1:levels
        d(i,:)=wrcoef('d',C,L,' db4',i);
    end   
    coef_set=[d;a]; % [7*t]
    
    %% ApEn
    Apen_dwt=[]; % [1*7]
    for j=1:size(coef_set,1) % 7     
        m=2; r=0.2; tau=1; % parameters for ApEn
        signal=coef_set(j,:);
        Apen_dwt(j)= fastApEn(obj, m, r, signal,tau); % fast ApEn
    end
    
    %% save results
    Features(ch,:)=Apen_dwt;
end
