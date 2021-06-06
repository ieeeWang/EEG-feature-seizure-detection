function [Features_statistics]=Stafeature(obj1 )
%-------------------------------------------------
% compute basic statistics value over segments of EEG data
% 1) mean and 2) standard deviation(SD) 3)abs sum amplitude 4)mean_crosstimes
%--------------------------------------------------

%% prepare data
data_input=obj1.eeg_segment;
n_channel=length(data_input); % 39
Features_statistics=cell(n_channel,1);% define cell

for i=1:n_channel
    data_temp=data_input{i};
    datasize=size(data_temp);
    feature_temp=[];
    for j=1:datasize(2)
        input_signal=data_temp(:,j);
        mean1=mean(input_signal);
        std1=std(input_signal);
        %L2=norm(input_signal)^2; % Square amplitude sum
        L2=sum(abs(input_signal)); %abs sum amplitude
        m_times=meanCrosstimes(input_signal,mean1);
        feature_temp(:,j)=[mean1;std1;L2;m_times];
    end
    Features_statistics{i}=feature_temp;
end    
    
end


function mean_crosstimes=meanCrosstimes(inputdata,datamean)
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
mean_crosstimes=count;
end