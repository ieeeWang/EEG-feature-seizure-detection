function [ g ] = sse2( b, A )
%信息熵计算程序，输入量A为一维时间序列
%算法from《熵分析》
    a=length(A);
    B=diff(A);
    C=heaviside(B);
    D=[C(1:a-2),C(2:a-1)];%设字长宽度为2
    F=zeros(1,9);%共3^2=9种模式
    for i=1:a-2
        if(D(i,:)-[0 0])==[0 0];
            F(1)=F(1)+1;
        elseif(D(i,:)-[0 0.5])==[0 0];
            F(2)=F(2)+1;
        elseif(D(i,:)-[0 1])==[0 0];
            F(3)=F(3)+1;
        elseif(D(i,:)-[0.5 0])==[0 0];
            F(4)=F(4)+1;
        elseif(D(i,:)-[0.5 0.5])==[0 0];
            F(5)=F(5)+1;
        elseif(D(i,:)-[0.5 1])==[0 0];
            F(6)=F(6)+1;
        elseif(D(i,:)-[1 0])==[0 0];
            F(7)=F(7)+1;
        elseif(D(i,:)-[1 0.5])==[0 0];
            F(8)=F(8)+1;
        else(D(i,:)-[1 1])==[0 0];
            F(9)=F(9)+1;
        end
    end %统计各种模式的出现次数
    E=F/(a-2);
    for i=1:9
        if(E(i)==0)
            G(i)=0;
        else
            G(i)=-E(i)*log2(E(i));%修改于2010.6.8
        end
        %G(i)=-E(i)*log2(E(i)); %出现BUG，E(i)=0的情况未考虑
    end
    
    g=sum(G);

end

