function [ S ] = apen(obj,data,m,r )
% 主函数
% A行列均可  
% m=2;
% r=0.1~0.25  建议0.1
%A为一维数据矩阵，参数m为窗口长度，r为相似容限比例系数
%算法from《皮层脑电时间序列的相空间重构及非线性》

    S=Qmr2(data,m,r)-Qmr2(data,m+1,r);

end    
    
function [ Q ] = Qmr2( A,m,r )
        % A行列均可  
        % m=2;
        % r=0.1~0.25  建议0.1
        %A为一维数据矩阵，参数m为窗口长度，r为相似容限比例系数
        %算法from《皮层脑电时间序列的相空间重构及非线性》
        a=length(A);
        b=a-m+1;
        c=size(A);
        d=c(1);
        if d==1
            A=A';
        end%若A为1维行向量，则转置为列向量
        B=A(1:b);
        C=zeros(1,b);
        D=zeros(b);
        E=zeros(b,1);%临时变量的初始化
        s=std(A,1);%原始数据的标准差

            for i=2:1:m
                E=A(i:a-m+i);
                B=[B,E];
            end%重构后的窗口矩阵

            for i=1:b
                for j=i:b
                    D(i,j)=norm(B(i,:)-B(j,:),inf);
                    D(j,i)=D(i,j);
                end
            end%各向量之间的相互距离矩阵

            for i=1:b
                C(i)=sum(heaviside(r*s*ones(1,b)-D(i,:)));
            end

        Q=sum(log(C))/b;%由近似熵定义得到的中间参量

end


