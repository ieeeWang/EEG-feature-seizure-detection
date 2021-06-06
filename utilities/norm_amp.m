function [seg_nor, t0_nor]=norm_amp(seg,t0)
% normalize two signals for Dynamic Warping
seg=seg(:);t0=t0(:);
L=length(seg);
seg_nor=(seg-min(seg)*ones(L,1))/(max(seg)-min(seg)); % ->[0 1]
t0_nor=(t0-min(t0)*ones(L,1))/(max(t0)-min(t0));% ->[0 1]