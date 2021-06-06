function [Features_statistics]=Hurstfeature(obj)
% compute hurst exponent by using tools
input_signal=obj.data;
for ch=1:size(input_signal,1)
    dataWindow=input_signal(ch,:);
    H(ch,:)=hurst_estimate(dataWindow,'peng',1);
end
Features_statistics=[H]; 
end