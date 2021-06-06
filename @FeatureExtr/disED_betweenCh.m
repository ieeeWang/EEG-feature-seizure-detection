function mean_dis = disED_betweenCh(obj) 
% INPUT
% 'multiChEEG', rows represent EEG channels, colums represent samples.
% OUTPUT
% mean_dis get its mean value on all pairs of EEG channels.
% Oct.26 2016 by Lei@TU/e

multiChEEG =obj.data; % [Ch*T]
Ch =size(multiChEEG,1);
Srate=obj.sample_rate; % 100 Hz

% save DW_distance between ch(i) and ch(j) in distance(i,j) 
distance=[];
% if INPUT only comtain 'obj'
if nargin==1    
    for i=1:Ch
        t0=multiChEEG(i,:); % ch(i)
        for j=1:Ch
            % distance between ch(i)&ch(j)
            t1=multiChEEG(j,:); % ch(j)
            distance(i,j) = sqrt(sum((t0-t1).^2)); 
        end
    end
end

% get the mean of matrix - 'distance'
D= distance; % [Ch*Ch]
% get sum of 'up-right' elements in 'D'
dis_sum= (sum(sum(D - D.*eye(Ch))))/2;
mean_dis = dis_sum/nchoosek(Ch,2); % nchoosek: choose k of n.




