function mean_dis = FdisDW_betweenCh (obj, delt_f) 
% compute the mean Dynamic Warping distance among all Chs(refer to X.Long 2014])
% INPUT
% 'multiChEEG', rows represent EEG channels, colums represent samples.
% OUTPUT
% mean_dis get its mean value on all pairs of EEG channels.
% Oct.26 2015 by Lei@TU/e

multiChEEG =obj.data; % [Ch*T]
Ch =size(multiChEEG,1);
Srate=obj.sample_rate; % 100 Hz

% save DW_distance between ch(i) and ch(j) in distance(i,j) 
distance=[];
% if INPUT only comtain 'obj'
if nargin==1    
    for i=1:Ch
        t0=multiChEEG(i,:); % ch(i)
        f0=getPSD(t0,Srate); % power spectral distribution of input
        for j=1:Ch
            % distance between ch(i)&ch(j)
            t1=multiChEEG(j,:); % ch(j)
            f1=getPSD(t1,Srate);
%             distance(i,j) = cdtw_dist(f0, f1, Inf); % DW distance
            distance(i,j) = dtw_c(f0, f1); % radius=Inf; Quan's code
        end
    end
% if INPUT also comtain 'radius'
elseif nargin==2 
    welch_resolution= 0.5; % Hz
    radius=delt_f/welch_resolution;
    for i=1:Ch
        t0=multiChEEG(i,:); % ch(i)
        f0=getPSD(t0,Srate); % power spectral distribution of input
        for j=1:Ch
            % distance between ch(i)&ch(j)
            t1=multiChEEG(j,:); % ch(j)
            f1=getPSD(t1,Srate);
%             distance(i,j) = cdtw_dist(f0, f1, radius); % DW distance
            distance(i,j) = dtw_c(f0, f1, radius); % Quan's code
        end
    end
end

% get the mean of matrix - 'distance'
D= distance; % [Ch*Ch]
% get sum of 'up-right' elements in 'D'
dis_sum= (sum(sum(D - D.*eye(Ch))))/2;
mean_dis = dis_sum/nchoosek(Ch,2); % nchoosek: choose k of n.



function f1=getPSD(signal,fs)
% welch estimate the power spectral density (PSD) of input 't1'
welch_resolution= 0.5; % Hz
f0=fs/welch_resolution;
overlap=[];
[Pxx,f] = pwelch(signal,hamming(fs/2),overlap,f0,fs);
% f=[0 0.5 1 ... 50], [101*1] 
f_range=[0.5 45]; % Hz, only focus on this frequency range
f1=Pxx(2:91);
f1=10*log10(f1);



