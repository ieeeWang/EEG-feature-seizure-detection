function mean_dis = disDW_betweenCh (obj, rt) 
% compute the mean Dynamic Warping distance among all Chs(refer to X.Long 2014])
% INPUT
% 'multiChEEG', rows represent EEG channels, colums represent samples.
% OUTPUT
% mean_dis get its mean value on all pairs of EEG channels.
% Oct.21 2015 by Lei@TU/e

multiChEEG =obj.data; % [Ch*T]
Ch =size(multiChEEG,1);
Srate=obj.sample_rate;
distance=[]; % distance(i,j) save DW_distance between ch(i) and ch(j)
% no limit on time lag
if nargin==1    
    for i=1:Ch
        t0=multiChEEG(i,:); % ch(i)
        for j=1:Ch
            % distance between ch(i)&ch(j)
            t1=multiChEEG(j,:); % ch(j)
            % DW distance
            [t0, t1]=norm_amp(t0,t1);
%             distance(i,j) = cdtw_dist(t0, t1, Inf); % Long's code
            distance(i,j) = dtw_c(t0, t1); % radius=Inf; Quan's code
        end
    end
% limit on time lag
elseif nargin==2 
    radius=rt*Srate; % constrint on the time lag of DW
    for i=1:Ch
        t0=multiChEEG(i,:); % ch(i)
        for j=1:Ch
            % distance between ch(i)&ch(j)
            t1=multiChEEG(j,:); % ch(j)
            % DW distance
            [t0, t1]=norm_amp(t0,t1);
%             distance(i,j) = cdtw_dist(t0, t1, radius); % Long's code
            distance(i,j) = dtw_c(t0, t1, radius); % Quan's code
        end
    end
end

D= distance; % [Ch*Ch]
% get sum of 'up-right' elements in 'D'
dis_sum= (sum(sum(D - D.*eye(Ch))))/2;
mean_dis = dis_sum/nchoosek(Ch,2); % nchoosek: choose k of n.

