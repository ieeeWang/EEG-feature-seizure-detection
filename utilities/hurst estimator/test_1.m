clear all
close all
clc

load FGN.mat;
figure(1)
subplot(211)
plot(fgn070_S)
subplot(212)
plot(fgn080_L(1:1000))

figure(2)
plot(fgn070_S,'r')
hold on
plot(fgn080_L(1:1000))

% hurst_estimate(fgn070_S, 'absval', 1, 1);
h=hurst_estimate(fgn070_S,'peng',1)
