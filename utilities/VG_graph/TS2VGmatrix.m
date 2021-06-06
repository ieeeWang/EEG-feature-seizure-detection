function [VGmatrix, D_edge]= TS2VGmatrix(Vec,type,plt)
% time serie(TS) of one dimention -> VG matrix of  
% VISIBILITY GRAPH or HORIZONTAL VISIBILITY GRAPH
% OUTPUT 
%     VGmatrix - [n*n] with n=length(Vec); its diagonal is zeros.
%     In the upright half of matrix 'VGm', each row records the edge ('1' means 
%     edge, '0' means non-edge) of ith item in TS with the other time series 
%     on its right.
%     D_edge - [1*t] the number of edges on each node; 
% INPUT
%     Vec - A vector of TS ([1*t] or [t*1])
%     type - 'VG' or  'HVG'
%     plt - '0' or '1'
% by Lei@TU/e June 11 2016

%% test 
% t1=[7.3 5.0 6.2 6.6 5.7 5.0 9.1];
% t2=[0.4 1 3];
% % rng(1)
% t3= rand([1,7]);
% 
% % type='HVG';
% type='VG';
% Vec=t1; plt=1;
% [VGmatrix, D_edge]=TS2VGmatrix(Vec,type,plt);
% disp(D_edge)
% % the total number of all edges without repeat
% N_edge=sum(sum(VGmatrix));
% disp(N_edge)

%% 
Vec=Vec(:)';

switch type
    case 'VG'
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
    case 'HVG'
        n= length(Vec)-1;
        VGm=zeros([n n]);
        for j=1:n
            tempVec=Vec(j:end);
            N=length(tempVec)-1;

            E=[]; E(1)=1;% length of E is N 
            for i=2:N
                M_mid=max(tempVec(2:i));
                if (tempVec(1)>M_mid) && (tempVec(i+1)>M_mid)
                    E(i)=1;
                else
                    E(i)=0;
                end
            end
            VGm(j,[j:n])=E;
        end
end


% enlarge the VGm into [L*L] matrix, L is the length(Vec)
VGm2=[];
L=length(Vec);
addcolum=zeros(L-1,1);
addrow =zeros(1,L);
VGm2=[addcolum,VGm];
VGm2=[VGm2;addrow];
% sum items on the cross of each item in the diagonal of VGm2

% compute the number of edges on each node based VGm
D_edge=[];
for i=1:size(VGm2,1)
    temp_r=VGm2(i,:);
    temp_c=VGm2(:,i);
    D_edge(i)=sum(temp_r)+sum(temp_c);
end

% the total number of all edges without repeat
N_edge=sum(sum(VGm));
VGmatrix=VGm2;

%% plot
if plt==1
    figure
    x=[1:length(Vec)];
    barwidth=0.1;
    switch type
        case 'VG' % plot VG
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
        case 'HVG'
            bar(x,Vec,barwidth);
            % stem(x,Vec);
            % plot collection
            hold on
            for i=1:(length(Vec)-1)
                for j=(i+1):length(Vec)
                    if VGm2(i,j)==1
                        high=min(Vec(i), Vec(j));
                        line([i j],[high high],'LineStyle','-','LineWidth',1);
                    end
                end
            end
            hold off
    end
end


