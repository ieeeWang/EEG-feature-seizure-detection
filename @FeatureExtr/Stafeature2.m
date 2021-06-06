function [Features_statistics]=Stafeature2(obj, input_signal )
%-------------------------------------------------
% compute basic statistics value over segments of EEG data
% 1) mean and 2) standard deviation(SD) 3)abs sum amplitude 4)mean_crosstimes
%--------------------------------------------------
srate=obj.sample_rate;
duration=size(input_signal,2)/srate;
%% compute above features
for ch=1:size(input_signal,1)
    dataWindow=input_signal(ch,:);
    mean1(ch,:)=mean(dataWindow);
    std1(ch,:)=std(dataWindow);
    %L2=norm(input_signal)^2; % Square amplitude sum
    L2(ch,:)=(1/length(dataWindow))*sum(abs(dataWindow)); % mean abs amplitude
    % m_times=meanCrosstimes(input_signal,mean1);
    zero_times(ch,:)=meanCrosstimes(dataWindow,0,duration); % zero across times in one second
    mean_times(ch,:)=meanCrosstimes(dataWindow,mean(dataWindow),duration); 
    test_power(ch,:)= norm(dataWindow)^2;
    
end
Features_statistics=[mean1,std1,L2,zero_times,mean_times,test_power];  % [ch * 5]   
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