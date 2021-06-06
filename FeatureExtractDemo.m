% A demo for batch processing all data under a given folder
close all; clear all; clc
addpath(genpath('.\utilities'));
input_dir= '.\demoEEG\';
output_dir = '.\demoFV\';

%% extract feature
% set sliding-window parameters
settings.T  = 2; % sliding window [seconds]
settings.dT = 1; % step [seconds]
settings.fs =  100; % sample ratio [Hz]

tic
contents=dir([input_dir '\*.mat']); % get all the files
N=size(contents,1);
for j=1:N
    message_str = sprintf('Processing: %i of %i subjects', j, N);
    disp(message_str);
    filename=contents(j).name;
    load ([input_dir, filename]);
    filtEEG = EEGseg.data; % [7*2000] 20-s EEG

    windowSize = settings.T * settings.fs;  % [samples]
    stepSize   = settings.dT * settings.fs; % [samples]
    EEGLength = size(filtEEG,2);
    nWindows = floor((EEGLength - windowSize)/stepSize)+1; % n steps, (n+1) windows.
    
    Fv=[];
    % parfor i = 1: nWindows % use multiple CPU
    for i = 1: nWindows
        t1 = (i-1)*stepSize + 1;
        t2  = t1+ windowSize-1;   
        tmp_segment = filtEEG(:, t1:t2); % a sliding window
        
        Fv47 = ExtractFv47(tmp_segment, settings.fs);
        Fv15 = ExtractFvVG(tmp_segment, settings.fs);
        Fv(:,i) = [Fv47(:); Fv15(:)];
    end
    savename = strrep(filename,'SezDemo','Fv'); % strrep(str,old,new)
    save([output_dir, savename], 'Fv');
end
toc