function [DWT_std_ratio]=DWTfeature3(obj1 )
%-------------------------------------------------
% Discrete wavelet transform, to compute enerage rario of each frequency
% band. and the standard deviation of each frequency band.
%--------------------------------------------------

%% set parameters
Fs = obj1.sample_rate;                  
T = 1/Fs;  
data_input=obj1.data;

%% prepare data
n_channel=size(data_input,1); 
Energy_std =[]; Energy_ratio =[];
for ch=1:n_channel
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
    Energy_std(ch,:)= std(d');
    
    % get enerage (sum square of coefficients) rario of each level
    % total energe
    Etot=0;
    for i=1:size(d,1)
        Etot=Etot+sum(d(i,:).^2);
    end
    %  energe ratio of each level   
    Eratio=[];
    for i=1:size(d,1)
        Eratio(i)=sum(d(i,:).^2)/Etot;    
    end  
    Energy_ratio(ch,:) = Eratio;
end

DWT_std_ratio = [Energy_std, Energy_ratio];
