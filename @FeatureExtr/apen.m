function [ S ] = apen(obj,data,m,r )
% ������
% A���о���  
% m=2;
% r=0.1~0.25  ����0.1
%AΪһά���ݾ��󣬲���mΪ���ڳ��ȣ�rΪ�������ޱ���ϵ��
%�㷨from��Ƥ���Ե�ʱ�����е���ռ��ع��������ԡ�

    S=Qmr2(data,m,r)-Qmr2(data,m+1,r);

end    
    
function [ Q ] = Qmr2( A,m,r )
        % A���о���  
        % m=2;
        % r=0.1~0.25  ����0.1
        %AΪһά���ݾ��󣬲���mΪ���ڳ��ȣ�rΪ�������ޱ���ϵ��
        %�㷨from��Ƥ���Ե�ʱ�����е���ռ��ع��������ԡ�
        a=length(A);
        b=a-m+1;
        c=size(A);
        d=c(1);
        if d==1
            A=A';
        end%��AΪ1ά����������ת��Ϊ������
        B=A(1:b);
        C=zeros(1,b);
        D=zeros(b);
        E=zeros(b,1);%��ʱ�����ĳ�ʼ��
        s=std(A,1);%ԭʼ���ݵı�׼��

            for i=2:1:m
                E=A(i:a-m+i);
                B=[B,E];
            end%�ع���Ĵ��ھ���

            for i=1:b
                for j=i:b
                    D(i,j)=norm(B(i,:)-B(j,:),inf);
                    D(j,i)=D(i,j);
                end
            end%������֮����໥�������

            for i=1:b
                C(i)=sum(heaviside(r*s*ones(1,b)-D(i,:)));
            end

        Q=sum(log(C))/b;%�ɽ����ض���õ����м����

end


