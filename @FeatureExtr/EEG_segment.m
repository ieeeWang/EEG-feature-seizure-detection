function EEG_segment(obj1)
%----------------------------
% EEG segment. T is window_length£»N is number of segments
%---------------------------------------
T=obj1.window_length;
data=obj1.data;
datasize=size(data);
Length= datasize(2);
for j=1:datasize(1) % channels number
    % N=floor( Length/T );  % devide data to N segments 
    N=fix( Length/T ); %  if the last segment is no longer than  "window_length", neglect it
    EEG_Channel=[];
    for i=1: N
        EEG_Channel(:,i)=data(j, (i-1)*T+1 : i*T);
    end

    obj1.eeg_segment{j}=EEG_Channel; % T by N
    
end
