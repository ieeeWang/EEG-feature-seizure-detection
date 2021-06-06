clear all; close all; clc

stru1 = {};
C0=eye(3);
stru1.C0 = C0;
stru1.A = [1,2,3;4,5,6];

save(['stru1_test'],'stru1')

