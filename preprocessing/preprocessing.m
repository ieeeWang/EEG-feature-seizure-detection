close all;clear all;clc
% load raw EEG from .mat files, then extract target EEG channales, 
% filtering (zero-phase shiftering), 
% locate seizuzre events
% save EEG segments (e.g., 10s) with onset in the middle

mainPath='D:\surfdrive\MATLAB\EEG-MR project\';
addpath(genpath(mainPath));

%% search under path
EEG_dir= 'G:\TUePC\4KH_archive_LeiWang_2018June\EEG DB\Share2brainwave\data\';
result_dir = 'D:\data_repo\EEG_epilepsy\DL2021\'; 

contents=dir([EEG_dir '\*.mat']); % get all the files

%% load EEG and filter
tic
N=size(contents,1);
for i=1:1
    message_str = sprintf('Processing: %i of %i subjects', i, N);
    disp(message_str);
    filename=contents(i).name;
    
    load ([EEG_dir, filename]);
    fs = EEG.srate;
    % select EEG electrods to analyze 
    ch_sel ={'T3'; 'T4'; 'Cz'; 'O1'; 'O2'; 'F3'; 'F4'}; % channels to use
    n_target = getID_chSet(ch_sel, EEG.Ch);
    EEG_nch = EEG.data(n_target,:);

    % Filter: zero-phase shift 
    d1 = designfilt('bandpassiir','FilterOrder',10, ...
         'HalfPowerFrequency1',1,'HalfPowerFrequency2',49.5, ...
         'SampleRate',fs);
    %fvtool(d1) % filter visualization 

    EEG_nch_flt = (filtfilt(d1, EEG_nch'))';

end
toc