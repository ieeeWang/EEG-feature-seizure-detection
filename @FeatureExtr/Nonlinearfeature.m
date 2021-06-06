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
        min_m=1;  max_m=20; % ȷ������СǶ��άʱ�ķ�Χ 1-20
        %[E1,E2]=Nonlinear.cao1(data,min_m,max_m,tau);   %����c��д��dll�ļ�����E1,E2��
        [E1,E2]=Nonlinear.cao1(data,min_m,max_m,tau); 
        e1=E1;
        e2=E2;
        % figure(i);   % ��cao��ͼ
        % Cao_plot(e1,e2); 
        m_num= Nonlinear.Cao_num(e1,e2);    % �Զ����� ��СǶ��άm
        D  = Nonlinear.GPnew( data, m_num, tau );     % �������ά D

        % P:ʱ�����е�ƽ������,ѡ���ݻ����൱ǰ���λ�ò������ǰ���ΪI��
        % ���ݻ����ֻ����|I��J|>P���������Ѱ 
        P=10;     
        lambda_1=Nonlinear.lyapunov_wolf(data,m_num,tau,P);  % ����L.E.ָ��

        % save features 
        features_temp(:,i)=[tau;m_num;lambda_1;D]; 
     end
    features{j}=features_temp;
end