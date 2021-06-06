clear all; close all; clc

%% add mainpath
mainPath='D:\surfdrive\MATLAB\EEG-MR project\';
addpath(genpath(mainPath));

% VG (10) + saab (7) features: Learn_sets 
input_dir1 = 'D:\data_repo\EEG_epilepsy\Learn_sets\';
% my47 features
input_dir2 = 'D:\data_repo\EEG_epilepsy\exclusive\';

% save into order: [Saab, My47, VG] % samples*69
save_dir = 'D:\data_repo\EEG_epilepsy\DL2021\';

%% 
% VGS:{DVG+HVG+SL} 
% [3,6,9,12,13],[2,5,8],[14,15] : order of 10 important feature in 15 features
    
% for class 0
load([input_dir1,'TrClass_0'])
C0_saab = Trclass.saab'; % KEEP saab on the top, because it has NaN row
C0_VG   = [Trclass.VG'];
C0_VG   = C0_VG(:,[3,6,9,12,13,2,5,8,14,15]); % use only 10 of 15
load ([input_dir2, 'TrClass_A']);
C0_47 = Trclass.C0'; 
C0_64 = [C0_saab, C0_47, C0_VG];

% for class A
Name = 'TrClass_A';
load([input_dir1,Name])
C1_saab = [Trclass.saab']; % KEEP saab on the top, because it has NaN row
C1_VG   = [Trclass.VG'];
C1_VG   = C1_VG(:,[3,6,9,12,13,2,5,8,14,15]); % use only 10 of 15
load ([input_dir2, Name]);
C1_47 = Trclass.C1'; 
C1_A = [C1_saab, C1_47, C1_VG];

% for class B
Name = 'TrClass_B';
load([input_dir1,Name])
C1_saab = [Trclass.saab']; % KEEP saab on the top, because it has NaN row
C1_VG   = [Trclass.VG'];
C1_VG   = C1_VG(:,[3,6,9,12,13,2,5,8,14,15]); % use only 10 of 15
load ([input_dir2, Name]);
C1_47 = Trclass.C1'; 
C1_B = [C1_saab, C1_47, C1_VG];

% for class C
Name = 'TrClass_C';
load([input_dir1,Name])
C1_saab = [Trclass.saab']; % KEEP saab on the top, because it has NaN row
C1_VG   = [Trclass.VG'];
C1_VG   = C1_VG(:,[3,6,9,12,13,2,5,8,14,15]); % use only 10 of 15
load ([input_dir2, Name]);
C1_47 = Trclass.C1'; 
C1_C = [C1_saab, C1_47, C1_VG];

% for class D
Name = 'TrClass_D';
load([input_dir1,Name])
C1_saab = [Trclass.saab']; % KEEP saab on the top, because it has NaN row
C1_VG   = [Trclass.VG'];
C1_VG   = C1_VG(:,[3,6,9,12,13,2,5,8,14,15]); % use only 10 of 15
load ([input_dir2, Name]);
C1_47 = Trclass.C1'; 
C1_D = [C1_saab, C1_47, C1_VG];

% for class M
Name = 'TrClass_M';
load([input_dir1,Name])
C1_saab = [Trclass.saab']; % KEEP saab on the top, because it has NaN row
C1_VG   = [Trclass.VG'];
C1_VG   = C1_VG(:,[3,6,9,12,13,2,5,8,14,15]); % use only 10 of 15
load ([input_dir2, Name]);
C1_47 = Trclass.C1'; 
C1_M = [C1_saab, C1_47, C1_VG];

%% remove samples (rows) including nan
nan0 = sum(sum(isnan(C0_64),2)>0);
nanA = sum(sum(isnan(C1_A),2)>0);
nanB = sum(sum(isnan(C1_B),2)>0);
nanC = sum(sum(isnan(C1_C),2)>0);
nanD = sum(sum(isnan(C1_D),2)>0);
nanM = sum(sum(isnan(C1_M),2)>0);

C1_A = removeNan(C1_A);
C1_B = removeNan(C1_B);
C1_C = removeNan(C1_C);
C1_D = removeNan(C1_D);
C1_M = removeNan(C1_M);
C0_64 = removeNan(C0_64);


%%
Fv64 = {};
Fv64.C0 = C0_64;
Fv64.A = C1_A;
Fv64.B = C1_B;
Fv64.C = C1_C;
Fv64.D = C1_D;
Fv64.M = C1_M;

save([save_dir, 'Fv64_29subj_NoNan'],'Fv64')



