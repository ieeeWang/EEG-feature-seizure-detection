function [k]=Plot_DWT(obj1 , data)
%-------------------------------------------------
% Discrete wavelet transform, to compute enerage rario of each frequency
% band. 
%--------------------------------------------------
%%
Fs = obj1.sample_rate;                  
T = 1/Fs;                    
L = length(data); % 1000                  
t = (0:L-1)*T;  
%% -----------------input data-----------------------
y=data;
NFFT = 2^nextpow2(L);
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

figure(1);  % 原始信号的频谱图
plot(f,2*abs(Y(1:NFFT/2+1)))
xlabel('Frequency/Hz ')
ylabel('Amplitude(mm/s2)')
title('Amplitude spectrum of original signal');


[d,a]=wavedec(y,8,'db10'); % 8层小波分解

A8=wrcoef('a',d,a,' db10',8);
D8=wrcoef('d',d,a,' db10',8);
D7=wrcoef('d',d,a,' db10',7);
D6=wrcoef('d',d,a,' db10',6);
D5=wrcoef('d',d,a,' db10',5);
D4=wrcoef('d',d,a,' db10',4);
D3=wrcoef('d',d,a,' db10',3);
D2=wrcoef('d',d,a,' db10',2);
D1=wrcoef('d',d,a,' db10',1);

%% -----------------Plot  8层小波系数分解结果
figure(2);
subplot(511)
plot(y)
ylabel('y')
subplot(512)
plot(D1)
ylabel('d1')
subplot(513)
plot(D2)
ylabel('d2')
subplot(514)
plot(D3)
ylabel('d3')
subplot(515)
plot(D4)
ylabel('d4')
xlabel('Time(s)')
%---------------------------------------------------------------------
figure(3);
subplot(511)
plot(A8)
ylabel('a8')
subplot(512)
plot(D5)
ylabel('d5')
subplot(513)
plot(D6)
ylabel('d6')
subplot(514)
plot(D7)
ylabel('d7')
subplot(515)
plot(D8)
ylabel('d8')
xlabel('Time(s)')
%% ---------------------其中一层小波系数曲线的频谱图--------------------------
% Y = fft(D8,NFFT)/L; %选择小波层
Y = fft(A8,NFFT)/L; %选择小波层
f = Fs/2*linspace(0,1,NFFT/2+1);
figure(4); % 小波分解得到的 其中一层小波曲线的频谱图
plot(f,2*abs(Y(1:NFFT/2+1)))
title('amplitude spectrum of D_8 level of frenquency band');
xlabel('Frequency/Hz ')
ylabel('Amplitude(mm/s2)')

%% compute wavelet coefficient ratio
EA8=(A8.*y).^2;
EA8=EA8';
EA8E=sum(EA8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ED8=(D8.*y).^2;
ED8=ED8';
ED8E=sum(ED8);

ED7=(D7.*y).^2;
ED7=ED7';
ED7E=sum(ED7);

ED6=(D6.*y).^2;
ED6=ED6';
ED6E=sum(ED6);

ED5=(D5.*y).^2;
ED5=ED5';
ED5E=sum(ED5);

ED4=(D4.*y).^2;
ED4=ED4';
ED4E=sum(ED4);

ED3=(D3.*y).^2;
ED3=ED3';
ED3E=sum(ED3);

ED2=(D2.*y).^2;
ED2=ED2';
ED2E=sum(ED2);

ED1=(D1.*y).^2;
ED1=ED1';
ED1E=sum(ED1);

ED=ED1E+ED2E+ED3E+ED4E+ED5E+ED6E+ED7E+ED8E+EA8E;

RD1=ED1E/ED;
RD2=ED2E/ED;
RD3=ED3E/ED;
RD4=ED4E/ED;
RD5=ED5E/ED;
RD6=ED6E/ED;
RD7=ED7E/ED;
RD8=ED8E/ED;
RA8=EA8E/ED;

x=[1 2 3 4 5 6 7 8 9 ];
y1=[ ED1E ED2E ED3E ED4E ED5E ED6E ED7E ED8E EA8E];
y2=[ RD1  RD2  RD3  RD4  RD5  RD6  RD7  RD8  RA8];


figure(6)
bar(x,y2);
set(gca,'XTicklabel',{'d1' 'd2' 'd3' 'd4' 'd5' 'd6' 'd7' 'd8' 'a8'})
xlabel(' Decomposition scale ')
ylabel('Enerage rario of each frequency band of 8-level DWT')
%%
k=y2; % coefficient vector