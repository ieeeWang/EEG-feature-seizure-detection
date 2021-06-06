function MaxXcor = maxXcorrelation (obj) 
% compute the maximum linear cross-correlation (A.3.1 in [Mormann 2005])
% INPUT
% 'multiChEEG', rows represent EEG channels, colums represent samples.
% OUTPUT
% MaxXcor get its mean value on all pairs of EEG channels.

% Bivariate linear measures: Maximum linear cross-correlation(A.3.1 in [Mormann 2005])
% MaxXcor is confined to the interval [0, 1] with high values indicating
% that the two signals have a similar course in time (though
% possibly shifted by a time lagt) while dissimilar signals will
% result in values close to zero.

% if the amplitude of EEG is zero, the 'xcorr' will fail, so set it zero. 
multiChEEG=obj.data;
if (max(max(abs(multiChEEG)))<10) % 10 microvolt       
    MaxXcor = 0;
else
    % compute Maximum linear cross-correlation ...
    Srate=obj.sample_rate;
    xcorrcoef= getxcorrcoef(multiChEEG',Srate);
    xMatr=xcorrcoef{1};
    % get sum of elements in 'xMatr'
    n2 = size(xMatr,1); I2 = eye(n2);
    R2 = xMatr -I2;
    R_sum=sum(sum(R2))/2;
    MaxXcor = R_sum/nchoosek(n2,2);
end


function xcorrcoef= getxcorrcoef (multiChEEG,Srate)
% perform cross-correlation(A.3.1 in [Mormann 2005]) on multiple channel EEG epochs. 

% INPUT
% 'multipleEEG', rows represent observation, colums represent EEG channels.

% OUTPUT
% 'xcorrcoef' = [C, L], 
% C(i,j) represent the maximum linear corss-correlation matrirx between i and j channels.
% L(i,j) represent the time lag value when its cross-correlation is maximum.

% set lag range [-maxlags:maxlags]
maxlags=0.5*Srate;  %[0.5 seconds]

% No. of EEG channels
n=size(multiChEEG,2);
C=[]; L=[];
for i=1:n % rows
    for j=1:n % colums
%       [r,lags] = xcorr(multiChEEG(:,i), multiChEEG(:,j),'coeff'); % No lag range limit
        [r,lags] = xcorr(multiChEEG(:,i), multiChEEG(:,j),maxlags,'coeff'); % lag range [-maxlags:maxlags]
        M = max(abs(r));
        C(i,j)=M;
        x= find(abs(r)==M);
        L(i,j)= lags(x);
    end
end

xcorrcoef={C, L};