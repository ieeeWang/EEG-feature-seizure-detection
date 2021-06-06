close all;clear all;clc
addpath('.\demoEEG\');
addpath(genpath('.\utilities'));
%% load
load('SezDemo_A') 
EEGsegA = EEGseg;
load('SezDemo_B') 
EEGsegB = EEGseg;
load('SezDemo_C') 
EEGsegC = EEGseg;
load('SezDemo_D') 
EEGsegD = EEGseg;

%% Plot the AVG 12-s EEG
sr=100;
Chset ={'T3'; 'T4'; 'Cz'; 'O1'; 'O2'; 'F3'; 'F4'}; % channels to use
range = 200; % uV

fsize = 12;
figure 
    subplot(411)
    EEGplot_seg(EEGsegA.data, sr, range, Chset);
    title('A (fast spike)', 'FontSize', fsize)
    subplot(412)
    EEGplot_seg(EEGsegB.data, sr, range, Chset);
    title('B (spike-wave)', 'FontSize', fsize)
    subplot(413)
    EEGplot_seg(EEGsegC.data, sr, range, Chset);
    title('C (slow wave)', 'FontSize', fsize)
    subplot(414)
    EEGplot_seg(EEGsegD.data, sr, range, Chset);
    title('D (EMG-related)', 'FontSize', fsize)
    xlabel('Time (second)', 'FontSize', fsize)

   