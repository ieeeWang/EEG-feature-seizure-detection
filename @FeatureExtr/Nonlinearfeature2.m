function features =Nonlinearfeature2(obj,data_input)
%---------------------------------------------------
% Non-linear process and extract Non-linear parameters
%---------------------------------------------------

%% prepare data
n_channel=size(data_input,1); % 39
%% compute on all channel
for ch=1:n_channel
    data=data_input(ch,:);
         
        tau = Nonlinear.delaytime(data,100);   % max_tao=1000 
        min_m=1;  max_m=20; % 确定求最小嵌入维时的范围 1-20
        [E1,E2]=Nonlinear.cao1(data,min_m,max_m,tau);   %调用c编写的dll文件计算E1,E2。
        e1=E1;
        e2=E2;
        % figure(i);   % 画cao氏图
        % Cao_plot(e1,e2); 
        m_min= Nonlinear.Cao_num(e1,e2);    % 自动计算 最小嵌入维m
        
 

        m_min=8;
        CD = Nonlinear.GPnew( data, m_min, tau );     % 计算关联维 D


        % P:时间序列的平均周期,选择演化相点距当前点的位置差，即若当前相点为I，
        % 则演化相点只能在|I－J|>P的相点中搜寻 
        P=10;     
        lyapunov=Nonlinear.lyapunov_wolf(data,m_min,tau,P);  % 计算L.E.指数

        % save features 
        features_temp(ch,:)=[tau;m_min;lyapunov;CD]; 
end
features=features_temp;