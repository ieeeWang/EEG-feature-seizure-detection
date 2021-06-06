clear all; close all; clc

input_dir= 'D:\data_repo\EEG_epilepsy\DL2021\';
load([input_dir,'Fv64_29subj'])

C0 = Fv64.C0;
C1 = [Fv64.A; Fv64.B; Fv64.C; Fv64.D; Fv64.M];
All_X = [C0; C1]';

%% Spearman's rank correlation coefficient
% 2)
tic % Elapsed time is 1453 seconds
corrM = [];
nf= size(All_X,1); % 64
for i=1:nf 
    for j=1:nf
        a=All_X(i,:); b= All_X(j,:); 
        % [RHO,PVAL] = corr(a(:), b(:),'Type','Spearman') % (the default) uses all rows regardless of missing values (NaNs)
        [RHO,PVAL] = corr(a(:), b(:),'Type','Spearman','rows','complete'); % 'complete' uses only rows with no missing values (NaN)
        corrM(i,j) =RHO;
    end
end
toc

%%
figure
    featurehead =   [1, 8,12, 24,36,39,51,55, 64];
    featureheadtxt = {1, 8,12, 24,36,39,51,55,64};
    imagesc(corrM); % plot the matrix
    % set(gca, 'XTick', 1:nf); % center x-axis ticks on bins
    % set(gca, 'XTickLabel', featurehead); % set x-axis labels
    xticks(featurehead);xticklabels(featureheadtxt)
    yticks(featurehead);yticklabels(featureheadtxt)
    xlabel('Feature index');ylabel('Feature index');
    % title('Correlation coefficient map', 'FontSize', 14); % set title
    colorbar; colormap(jet)
