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
        min_m=1;  max_m=20; % ȷ������СǶ��άʱ�ķ�Χ 1-20
        [E1,E2]=Nonlinear.cao1(data,min_m,max_m,tau);   %����c��д��dll�ļ�����E1,E2��
        e1=E1;
        e2=E2;
        % figure(i);   % ��cao��ͼ
        % Cao_plot(e1,e2); 
        m_min= Nonlinear.Cao_num(e1,e2);    % �Զ����� ��СǶ��άm
        
 

        m_min=8;
        CD = Nonlinear.GPnew( data, m_min, tau );     % �������ά D


        % P:ʱ�����е�ƽ������,ѡ���ݻ����൱ǰ���λ�ò������ǰ���ΪI��
        % ���ݻ����ֻ����|I��J|>P���������Ѱ 
        P=10;     
        lyapunov=Nonlinear.lyapunov_wolf(data,m_min,tau,P);  % ����L.E.ָ��

        % save features 
        features_temp(ch,:)=[tau;m_min;lyapunov;CD]; 
end
features=features_temp;