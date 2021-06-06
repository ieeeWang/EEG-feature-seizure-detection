close all;clear all;clc
addpath('.\demoFV\');
addpath(genpath('.\utilities'));
%% load
load('Fv_A'); FvA = Fv;
load('Fv_B'); FvB = Fv;
load('Fv_C'); FvC = Fv;
load('Fv_D'); FvD = Fv;

% map into [0 - 1]
FvA_norm = normalize(FvA,2,'range'); 
FvB_norm = normalize(FvB,2,'range');
FvC_norm = normalize(FvC,2,'range');
FvD_norm = normalize(FvD,2,'range');

% z-score, ie, mean=0, std=1 
% FvA_norm = normalize(FvA,2); 
% FvB_norm = normalize(FvB,2);
% FvC_norm = normalize(FvC,2);
% FvD_norm = normalize(FvD,2);

%% Plot the AVG 12-s EEG
X = 1:19; % sec
Y = 1:62;
[XX,YY] = meshgrid(X,Y);

figure 
fsize = 12;
subplot(411)  
    surf(XX,YY,FvA_norm,'EdgeColor','none');   
    axis xy; 
    axis tight; 
    colormap(jet); 
    view(0,90);
    colorbar 
    ylabel('Feature ID','FontSize',fsize);
    title('A','FontSize',fsize)
subplot(412)  
    surf(XX,YY,FvB_norm,'EdgeColor','none');   
    axis xy; 
    axis tight; 
    colormap(jet); 
    view(0,90);
    colorbar 
    ylabel('Feature ID','FontSize',fsize);
    title('B','FontSize',fsize)
subplot(413)  
    surf(XX,YY,FvC_norm,'EdgeColor','none');   
    axis xy; 
    axis tight; 
    colormap(jet); 
    view(0,90);
    colorbar 
    ylabel('Feature ID','FontSize',fsize);
    title('C','FontSize',fsize)
subplot(414)  
    surf(XX,YY,FvD_norm,'EdgeColor','none');   
    axis xy; 
    axis tight; 
    colormap(jet); 
    view(0,90);
    colorbar 
    xlabel('Time (s)','FontSize',fsize);
    ylabel('Feature ID','FontSize',fsize);
    title('D','FontSize',fsize)