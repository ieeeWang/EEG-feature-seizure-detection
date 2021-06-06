close all;clear all;clc
% Save 4 typical SEZ types (20 sec each) from EDF files

%% define absolute path
mainPath='D:\surfdrive\MATLAB\EEG-MR project\';
addpath(genpath(mainPath));% add mainpath

EDF_path= 'G:\TUePC\4KH_archive_LeiWang_2018June\EEG DB\Annotated dataset\';
%% for DL figure
plotrange=[-10, 10]; % seconds

% pattern [A]
% EDFname='68a.EDF';  Onset='02-Jun-2008 21:00:32'; % ID: 3

% pattern [B]
% EDFname='159.EDF';  Onset='18-Feb-2013 20:27:35'; % ID: 2

% pattern [C]
% EDFname='25.EDF';  Onset='09-Apr-2013 00:25:14'; % ID: 1

% pattern [D]
% EDFname='22.EDF';  Onset='28-Aug-2013 02:37:05'; % ID: 1
EDFname='136.EDF';  Onset='03-Apr-2012 01:36:21'; % ID: 1 << used this


%% A. plot relative time onset - [before after]
scale=200;
sr=100; montage='CAR';XMLname=strcat(EDFname,'.XML');
Chset ={'T3'; 'T4'; 'Cz'; 'O1'; 'O2'; 'F3'; 'F4'}; % channels to use

figure
% plot all Ch except eye-around - [J3]
EEGsegAll = EEGplot_rel(EDFname, XMLname, EDF_path, Onset, plotrange, sr, scale, montage,'filter',0,'all');
title('filtered EEG')

% 2) plot selected Ch
figure
reverse=1; % Amp = -1*Amp
EEGseg = EEGplot_rel(EDFname, XMLname, EDF_path, Onset, plotrange, sr, scale, montage,'filter',reverse, Chset);

%% save
% save('SezDemo_D','EEGseg') 

%% Plot the AVG 12-s EEG
figure % plot all ch
range = 200; % uV
EEGplot_s(EEGseg.data, sr, range, Chset);
