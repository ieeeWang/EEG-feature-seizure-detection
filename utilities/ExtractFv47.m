function Fv = ExtractFv47(segments,srate)
% get feature vector (Fv) from the EEG segments in a sliding window
% segments: [ch*samples], (ch>=2).

N=47; % update N if new features are added below!
if isnan(segments)
    Fv=nan(N,1);
else   
    %% creat an object
    FE1 = FeatureExtr(segments, srate); % the input has at least 2 Ch

    %% compute statistics over segments of EEG data
    % output is [Number_channels * Number_features * window_index] 
    % [mean1,std1,zero_times,range_amp];  
    F_sta=FE1.Stafeature3();
    Fa_sta=mean(F_sta,1); % find mean value of each colum
    
    %% compute parameters in frequency domain: 
    % output is [Number_channels * Number_features * window_index] 
    %     features_norm(ch,:)=[percent_alfa,p_beta,p_delta,p_theta,...
    %             p_gamma,centroid];
    %     features_abs(ch,:)=[t_alfa,t_beta,t_delta,t_theta,t_gamma,...
    %             t_total(0.5-45Hz)];
    F_FFT=FE1.psdwelch();
    Fa_FFT=mean(F_FFT,1); % find mean value of each colum
    
    %% compute discrete wavelet transform(DWT) over segments of EEG data
    % Features is [std(d1),std(d2)...std(d6), r1(d1),r2(d2)...r6(dn)]
    F_DWT=FE1.DWTfeature3(); % output is [Ch * Features]
    Fa_DWT=mean(F_DWT,1); % [1*Features] mean value of each Ch
    
    %% compute entropy features over segments of EEG data
    % output is [Number_channels * Number_features * window_index] 
    F_ApEn = FE1.ApEnfeature();
    F_LZ = FE1.LZcomfeature ();
    F_hurst=FE1.Hurstfeature(); 
    Fa_ApEn=mean(F_ApEn); Fa_LZ=mean(F_LZ); Fa_hurst=mean(F_hurst);
    
    %% compute fc-Pattern over segments of EEG data
    % output is [f_bands * Number_features] 
    % Number_features: [f_size, FC_mean];
    F_fc=FE1.fcPattern2(); % use raw_EEG_segments
    Fa_fc=F_fc(:); 
    
    %% mean of Maximum linear cross-correlation
    F_MaxXcor = FE1.maxXcorrelation(); 
    
    %% Dynamic Warping distance
    % Note inside the 2 following funciton, the computation of DW distance 
    % has 2 option codes.
    
    t=0.5; %[second]
%     mean_dis = FE1.disDW_betweenCh(); % without limit on time lag
    avg_DW_t = FE1.disDW_betweenCh(t); % time lag limit is 0.5 second.
    
    df=2; %[Hz]
%     mean_Fdis = FE1.FdisDW_betweenCh(); % without limit on search radius
    avg_DW_f = FE1.FdisDW_betweenCh(df); % search radius is 2 Hz.
    
    % Euclidian distance
    avg_ED_f = FE1.FdisED_betweenCh(); 
     
    %% save the feature vector [N*1] - [47 features in total]
     Fv = [Fa_sta(:);Fa_FFT(:);Fa_DWT(:);Fa_ApEn;Fa_LZ;Fa_hurst;Fa_fc;...
          F_MaxXcor;avg_DW_t;avg_DW_f;avg_ED_f];
      
end



