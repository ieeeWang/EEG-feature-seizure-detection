function featureset=psdwelch(obj1)
% use welch to estimate the power spectral density (PSD) 

fs=obj1.sample_rate;
data_input=obj1.data;

% prepare data
n_channel=size(data_input,1); % 39   
features_norm=[];features_abs=[];


setting1=obj1.setting1;

nwind=setting1.nwind;
alfa = setting1.alfa;
beta = setting1.beta;
delta= setting1.delta;
theta= setting1.theta;
gamma= setting1.gamma;
tot=   setting1.tot;

for ch=1:size(data_input,1)
    signal=data_input(ch,:);

    %% welch estimate the power spectral density (PSD)
    overlap=[]; % optimal value for traid off between resolusion and variance
%     nwind=fs;
    [Pxx,f] = pwelch(signal,hamming(nwind),overlap,400,fs);
    welch_resolution=fs/400; % 0.5 -> 0.25
        
    % get total power in useful f [0.5-45] range: sigma
    [x1,x2]=findxaxis(f,tot);
    Pxx_range=Pxx(x1:x2);
    f_range=f(x1:x2);
    sigma_range=sum(Pxx_range)*welch_resolution; % integrate on tot[0.5 45]
       
%     % get total power in whole f range [0-fs/2]: sigma_test
%     [t1,t2]=findxaxis(f,test_tot);
%     p_all=Pxx(t1:t2);
%     sigma_test=sum(p_all)*welch_resolution; % test it by Parseval's theorem
    
    %% get f band power .... 
        
    [a1,a2]=findxaxis(f,alfa);   
    t_alfa=sum(Pxx(a1:a2))*welch_resolution;
    percent_alfa=t_alfa/sigma_range;

    [b1,b2]=findxaxis(f,beta);     
    t_beta=sum(Pxx(b1:b2))*welch_resolution;
    percent_beta=t_beta/sigma_range;  

    [c1,c2]=findxaxis(f,delta);   
    t_delta=sum(Pxx(c1:c2))*welch_resolution;
    percent_delta=t_delta/sigma_range;  

    [d1,d2]=findxaxis(f,theta); 
    t_theta=sum(Pxx(d1:d2))*welch_resolution;
    percent_theta=t_theta/sigma_range;  

    [e1,e2]=findxaxis(f,gamma);    
    t_gamma=sum(Pxx(e1:e2))*welch_resolution;
    percent_gamma=t_gamma/sigma_range;  
     
    % spectral centroid
    t=sum(Pxx_range.*f_range) *welch_resolution;
    centroid=t/sigma_range; 

    % frequency spreading: B
%     b_2=sum(((Pxx_range(:)-centroid*ones(length(Pxx_range),1)).^2).*f_range); 
%     f_spreading= sqrt(b_2/sigma_range); 
       

    
    %% save results
        features_norm(ch,:)=[percent_alfa,percent_beta,percent_delta,percent_theta,...
            percent_gamma,centroid]; % 6 FEATURES

        features_abs(ch,:)=[t_alfa,t_beta,t_delta,t_theta,t_gamma,...
            sigma_range];  % 6 FEATURES

%         features_BSI(ch,:)= [?];
           
    end
    featureset=[features_norm,features_abs]; % [6+6]
end



function [x1,x2]=findxaxis(y,interval)

    i=1;
    while (y(i)<=interval(1) && i<=length(y))
        i=i+1;
    end
    x1=i-1;

    j=length(y);
    while (y(j)>=interval(2) && j>=1)
        j=j-1;
    end
    x2=j+1;
end
