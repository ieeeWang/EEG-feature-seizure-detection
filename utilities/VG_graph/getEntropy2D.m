function H=getEntropy2D(data)
% compute Entropy in each EEG epoch -- this function for multi-EEG computation
% INPUT
%     data - [3*n], each row is VG,HVG,DVG
% OUTPUT
%     H - [3*1] - [H_vg,H_hvg,H_dvg]

H=[];
for i=1:size(data,1)
    temp2=data(i,:); % [1*n]
        P=tabulate(temp2);
        % remove the items with 0 instance
        loc0 =find(P(:,2)==0);
        P(loc0,:)=[];
        % probility of each degree
        p3=P(:,3)/100; 
        % degree entropy
    H(i,:)=(-1)*sum(p3.*log2(p3));
end

        
        
    