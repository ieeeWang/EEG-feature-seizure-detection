function [ comp ] = complexity( obj2, X )
%输入为一维数据矩阵，输出为序列复杂度 ----X为列
%算法from《复杂度、近似熵应用于麻醉深度监测中的实验研究》
    x=mean(X);
    Y=(X>x);%实验数据的粗粒化处理
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

