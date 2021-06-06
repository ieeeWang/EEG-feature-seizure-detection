function coeff = getCoeff_VGnet(VGmatrix)
% This code computes the assortativity coefficient (AC) of a VG network.
% according to 'Modeling cardiorespiratory interaction during
% human sleep with complex networks', X. Long 2014, APPLIED PHYSICS LETTERS
% INPUT
%     VGmatrix - VGmatrix - [n*n] with n=length(Vec); its diagonal and down triangular is all zeros.
%     In the upright half of matrix 'VGm', each row records the edge ('1' means 
%     edge, '0' means non-edge) of ith item in TS with the other time series 
%     on its right.
% OUTPUT
%     coeff - see the reference paper - Xi Long 2014.
% by Lei@TUe June 16, 2016


% compute the number of edges (i.e., degree) on each node based VGmatrix
VGm2=VGmatrix;
D_edge=[];
for i=1:size(VGm2,1)
    temp_r=VGm2(i,:);
    temp_c=VGm2(:,i);
    D_edge(i)=sum(temp_r)+sum(temp_c);
end


% the total number of all edges without repeat
M =sum(sum(VGm2));
L= size(VGmatrix,1);


ab=[]; % sigma{a*b}
anb=[];% sigma{a+b}
anb2=[]; % sigma{a^2+b^2}
n=0;
for i=1:L
    a=D_edge(i);
    for j=i:L
        if VGmatrix(i,j)==1
            b=D_edge(j);
            n=n+1;
            ab(n)=a*b;
            anb(n)=a+b;
            anb2(n)=a^2+b^2;
        end
    end
end
sigma_ab = sum(ab);
sigma_anb = sum(anb);
sigma_anb2 = sum(anb2);
 
%%
coeff=((1/M)*sigma_ab-((1/M)*0.5*sigma_anb)^2)/...
    ((1/M)*0.5*sigma_anb2-((1/M)*0.5*sigma_anb)^2);



