function [ comp ] = complexity( obj2, X )
%����Ϊһά���ݾ������Ϊ���и��Ӷ� ----XΪ��
%�㷨from�����Ӷȡ�������Ӧ����������ȼ���е�ʵ���о���
    x=mean(X);
    Y=(X>x);%ʵ�����ݵĴ���������
    n=length(Y);
    C=0;
    CS=[];
    PS=[];
    for i=1:n
        temp=size(CS);
        CS(temp(1,2)+1)=Y(i);
        PS(1:i-1)=Y(1:i-1);
        dd=findstr(PS,CS);
        if size(dd)==[0 0]
            C=C+1;
            CS=[];
        end
    end
    comp=C*log2(n)/n;
end

