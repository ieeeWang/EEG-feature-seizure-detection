close all;clear all;clc
% for viualization
mainPath='..\'; % father'father folder of this file
addpath(genpath(mainPath));

t1=[7.3 5.0 6.2 6.6 5.7 5.0 9.1];
t2=[0.4 1 3];
rng(1)
t3= rand([1,7]);
t3(3)=t3(3)+0.2;


% type='HVG';
type='VG';
Vec=t3; plt=1;
disp(Vec)
[VGmatrix1, D_vg]=TS2VGmatrix(Vec,type,plt);
set(gca,'Xtick',[1:length(Vec)],'XTickLabel',{'t_1','t_2','t_3',...
    't_4','t_5','t_6','t_7'});
ylabel('Point value')

disp(D_vg)
% the total number of all edges without repeat
N_edge=sum(sum(VGmatrix1));
disp(N_edge)
tabulate(D_vg)



type='HVG';
Vec=t3; plt=1;
[VGmatrix2, D_hvg]=TS2VGmatrix(Vec,type,plt);
set(gca,'Xtick',[1:length(Vec)],'XTickLabel',{'t_1','t_2','t_3',...
    't_4','t_5','t_6','t_7'});
ylabel('Point value')

disp(D_hvg)
N_edge=sum(sum(VGmatrix2));
disp(N_edge)
tabulate(D_hvg)

%%
% Call CIRCULARGRAPH with only the adjacency matrix as an argument.
figure
circularGraph(VGmatrix1);
figure
circularGraph(VGmatrix2);

%% compute shortest paths in network
S1 = sparse(VGmatrix1'); 
N= size(VGmatrix1,1);
%  false for an undirected graph. the upper triangle of the sparse matrix being ignored.
P_m1 = graphallshortestpaths(S1,'directed',false)
disp('average shortest path:')
sum(sum(P_m1))/((N-1)*N)
S2 = sparse(VGmatrix2'); 
P_m2 = graphallshortestpaths(S2,'directed',false)
disp('average shortest path:')
sum(sum(P_m2))/((N-1)*N)
% return 

%% compute AC
% DVG= D_vg-D_hvg;
% disp(DVG)
% tabulate(DVG)
% 
% [times, items] = hist(D_vg, min(D_vg):max(D_vg));
% P=times./length(D_vg);
% 
% coeff1 = getCoeff_VGnet(VGmatrix1);
% coeff2 = getCoeff_VGnet(VGmatrix2);
% return 



% VGm=TS2VGmatrix(Vec,type,plt);
% in the upright half (including diagonal) of matrix 'VGm', each row
% records the edge (1 means edge, 0 means non-edge) of ith item with the
% time series on its right.
% VGm - [n*n] with n=length(Vec)-1;

%% VG
n= length(Vec)-1;
VGm=zeros([n n]);
for j=1:n
    tempVec=Vec(j:end);   
    N=length(tempVec)-1;
    R=tempVec(1)*ones(1,N);
    K=(tempVec(2:end)-R)./[1:N]; % length of K is N
    % E record the edge of rest items with the first item in 'tempVec'
    % e.g., tempVec=[2 1 3]; E=[1 1];
    E=[]; E(1)=1;% length of E is N
    for i=2:N
        if K(i)>max(K(1:(i-1)))
            E(i)=1;
        else
            E(i)=0;
        end
    end
    VGm(j,[j:n])=E;
end
% the total number of all edges without repeat
N_edge=sum(sum(VGm))


%% HVG
% n= length(Vec)-1;
% VGm=zeros([n n]);
% for j=1:n
%     tempVec=Vec(j:end);
%     N=length(tempVec)-1;
%     
%     E=[]; E(1)=1;% length of E is N 
%     for i=2:N
%         M_mid=max(tempVec(2:i));
%         if (tempVec(1)>M_mid) && (tempVec(i+1)>M_mid)
%             E(i)=1;
%         else
%             E(i)=0;
%         end
%     end
%     VGm(j,[j:n])=E;
% end
% % the total number of all edges without repeat
% N_edge=sum(sum(VGm))


%% compute the number of edges on each node based VGm
% enlarge the VGm into [L*L] matrix, L is the length(Vec)
VGm2=[];
L=length(Vec);
addcolum=zeros(L-1,1);
addrow =zeros(1,L);
VGm2=[addcolum,VGm];
VGm2=[VGm2;addrow];
% sum items on the cross of each item in the diagonal of VGm2

N_edge=[];
for i=1:size(VGm2,1)
    temp_r=VGm2(i,:);
    temp_c=VGm2(:,i);
    N_edge(i)=sum(temp_r)+sum(temp_c);
end

%% plot VG
figure
x=[1:length(Vec)];
barwidth=0.1;
bar(x,Vec,barwidth);
% stem(x,Vec);
% plot collection
hold on
for i=1:(length(Vec)-1)
    for j=(i+1):length(Vec)
        if VGm2(i,j)==1
            line([i j],[Vec(i) Vec(j)],'LineStyle','-','LineWidth',1);
        end
    end
end
hold off

    
%% plot HVG
% figure
% x=[1:length(Vec)];
% barwidth=0.1;
% bar(x,Vec,barwidth);
% % stem(x,Vec);
% % plot collection
% hold on
% for i=1:(length(Vec)-1)
%     for j=(i+1):length(Vec)
%         if VGm2(i,j)==1
%             high=min(Vec(i), Vec(j));
%             line([i j],[high high],'LineStyle','-','LineWidth',1);
%         end
%     end
% end
% hold off




        



