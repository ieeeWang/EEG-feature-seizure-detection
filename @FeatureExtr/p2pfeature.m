function output =p2pfeature(obj)
% compute peak-to-peak (p2p) feature over one segment of EEG data
%  [mean(p2p), std(p2p)]
%% prepare data
data_input=obj.data;
n_channel=size(data_input,1); % 39
features_temp=[];
for ch=1:n_channel
    seg=data_input(ch,:);
  
    minD=7; % the mindistance between two neighber peaks
    [pks1,locs1]=findpeaks(seg,'MinPeakDistance',minD);
        if isempty(locs1)
            pks1=max(seg);
            locs1=find(seg==pks1);
            locs1=(locs1(1));
        end
        
    [pks2,locs2]=findpeaks(-seg,'MinPeakDistance',minD);
        if isempty(locs2)
            pks2=min(seg);
            locs2=find(seg==pks2);
            locs2=(locs2(1));
        end
    
    L1= length(locs1); L2=length(locs2);
    if L1<L2 
        temp= mean(pks1);
        if abs(locs1(1)-locs2(1)) < abs(locs1(end)-locs2(end))
            % add temp at end
            pks1=[pks1, temp*ones(1, L2-L1)];
        else
            % add temp at head
            pks1=[temp*ones(1, L2-L1),pks1];
        end
    elseif L1>L2 
        temp= mean(pks2);
        if abs(locs1(1)-locs2(1)) < abs(locs1(end)-locs2(end))
            % add temp at end
            pks2=[pks2, temp*ones(1, L1-L2)];
        else
            % add temp at head
            pks2=[temp*ones(1, L1-L2), pks2];
        end
    end
    
    pp= abs(pks1-pks2);
    ppm =mean(pp);
    ppsd=std(pp,1);
    
    
    %% save results
    features_temp(ch,:)=[ppm, ppsd];
end
output=features_temp;