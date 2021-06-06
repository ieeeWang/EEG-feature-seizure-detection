function Lamda =getLamda2D(data, type)
% compute Entropy in each EEG epoch -- this function for multi-EEG computation
% INPUT
%     data - [3*n]
% OUTPUT
%     Lamda - [2*1]


Inter1=[1 10];
Inter2=[10 25];


% for DVG
switch type
    case 'vg'
        k=1;
    case 'dvg'
        k=3;
end
      
temp=data(k,:); % [1*n]

    P=tabulate(temp);
    % remove the degrees with 0 instance
    loc0 =find(P(:,2)==0);
    P(loc0,:)=[];        
    p3= P(:,3)/100; % probility of each degree
    x=P(:,1);

    % slope at [1 10]
    Intr = Inter1;
    loc=find(Intr(1)<=x & x<=Intr(2));
    if length(loc)<=1
        s1 = nan(2,1);
    else
        s1 = polyfit(log10(x(loc)), log10(p3(loc)), 1);  
    end
    % slope at [10 25]
    Intr=Inter2;
    loc=find(Intr(1)<=x & x<=Intr(2));
    if length(loc)<=1
        s2 = nan(2,1);
    else      
        s2 = polyfit(log10(x(loc)), log10(p3(loc)), 1); 
    end
    
Lamda = -1.*[s1(1); s2(1)];


        
        
    