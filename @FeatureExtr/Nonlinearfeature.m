function features =Nonlinearfeature(obj)
%---------------------------------------------------
% Non-linear process and extract Non-linear parameters
%---------------------------------------------------

%% prepare data
data_input=obj.eeg_segment_nonlinear;
n_channel=length(data_input); % 39
features=cell(n_channel,1);% define cell
%% compute on all channel
for j=1:n_channel
    data_temp=data_input{j};
    datasize=size(data_temp);
%% compute features on one channel
    features_temp=[];
     for i=1:datasize(2)
        data =data_temp(:,i); 
         
        tau = Nonlinear.delaytime(data,100);   % max_tao=1000 
        min_m=1;  max_m=20; % 确定求最小嵌入维时的范围 1-20
        %[E1,E2]=Nonlinear.cao1(data,min_m,max_m,tau);   %调用c编写的dll文件计算E1,E2。
        [E1,E2]=Nonlinear.cao1(data,min_m,max_m,tau); 
        e1=E1;
        e2=E2;
        % figure(i);   % 画cao氏图
        % Cao_plot(e1,e2); 
        m_num= Nonlinear.Cao_num(e1,e2);    % 自动计算 最小嵌入维m
        D  = Nonlinear.GPnew( data, m_num, tau );     % 计算关联维 D

        % P:时间序列的平均周期,选择演化相点距当前点的位置差，即若当前相点为I，
        % 则演化相点只能在|I－J|>P的相点中搜寻 
        P=10;     
        lambda_1=Nonlinear.lyapunov_wolf(data,m_num,tau,P);  % 计算L.E.指数

        % save features 
        features_temp(:,i)=[tau;m_num;lambda_1;D]; 
     end
    features{j}=features_temp;
end