function [Features_statistics]=Stafeature3(obj )
%-------------------------------------------------
% compute basic statistics value over segments of EEG data
% 1) mean and 2) standard deviation(SD) 3)zero_times, 
% 4) range_amplitude - 0.5*(max_amp-min_amp).
%--------------------------------------------------
srate=obj.sample_rate;
input_signal=obj.data;
duration=size(input_signal,2)/srate;
%% compute above features
for ch=1:size(input_signal,1)
    dataWindow=input_signal(ch,:);
    mean1(ch,:)=mean(dataWindow);
    std1(ch,:)=std(dataWindow);

    % m_times=meanCrosstimes(input_signal,mean1);
    zero_times(ch,:)=meanCrosstimes(dataWindow,0,duration); % zero across times in one second
    
    % get the range of amplitude
    max_amp=max(dataWindow);
    min_amp=min(dataWindow);
    range_amp=0.5*(max_amp-min_amp);
    r_amp(ch,:)=range_amp;    
end
Features_statistics=[mean1,std1,zero_times,r_amp];  % [ch * 4]   
end


function mean_crosstimes=meanCrosstimes(inputdata,datamean,duration)
    flag=[];
    for i=1:length(inputdata)
        if (inputdata(i)>datamean)
            flag(i)=1;
        elseif inputdata(i)<datamean
            flag(i)=0;
        end
    end
    count=0;
    j=1;
    while (j<length(flag))
        if (flag(j+1)==flag(j))
            count=count;
        else
            count=count+1;
        end
        j=j+1;
    end
mean_crosstimes=count/duration;
end