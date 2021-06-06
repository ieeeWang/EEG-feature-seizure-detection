% foo.m
%
% This m-file shows an example of how to use ApEn function
% 
% More specifically, it generates three simulated data with different
% complexity (sine, chirp, and Gaussian noise), and plots the ApEn values
% with varying r

%-------------------------------------------------------------------------
% coded by Kijoon Lee, kjlee@ntu.edu.sg
% Mar 21st, 2012
%-------------------------------------------------------------------------
clear all
close all
clc

m = 2;      % embedded dimension
tau = 1;    % time delay for downsampling
N = 1000;
t = 0.001*(1:N);

% generate simulated data
sint = sin(2*pi*10*t);      % sine curve
chirpt = chirp(t,0,1,150);  % chirp signal
whitet = randn(1,N);        % white noise


% specify the range of r
rnum = 10;
result = zeros(3,rnum);
window=N/rnum;

data1=[];data2=[];data3=[];
for i=1:rnum
    data1(i,:)=sint((i-1)*window+1:i*window);
    data2(i,:)=chirpt((i-1)*window+1:i*window);
    data3(i,:)=whitet((i-1)*window+1:i*window);
end

     
    
% display orignal signal
figure
plot(sint,'o-')
hold on
plot(chirpt,'--*r')
hold on
plot(whitet,'--g')
hold off
legend('sin','chirp','white noise')

% hurst_estimate(dataWindow,'peng',1);

% main calculation and display
figure
for i = 1:rnum
    result(1,i) = hurst_estimate(data1(i,:),'peng',1);
    result(2,i) = hurst_estimate(data2(i,:),'peng',1);
    result(3,i) = hurst_estimate(data3(i,:),'peng',1);
end

r = 1:10;
plot(r,result(1,:),'o-',r,result(2,:),'o-',r,result(3,:),'o-')
%axis([0 rnum*0.02 0 1.05*max(result(:))])
legend('sin','chirp','white noise')
title('Hurst index','fontsize',14)
xlabel ('sliding window (window size = 100)')



sint = hurst_estimate(sint,'peng',1)
chirpt= hurst_estimate(chirpt,'peng',1)
whitet = hurst_estimate(whitet,'peng',1)

