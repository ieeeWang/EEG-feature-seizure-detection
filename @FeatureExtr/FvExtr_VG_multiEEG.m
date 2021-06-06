function Fv= FvExtr_VG_multiEEG(obj)
% to compute the VG feature set on multi EEG channels
% Fv is the mean value of each feature on all valid EEG channels
% the order inside Fv refer to 'feature order.xlsx'@D:\EEG DB\EEG_DB hierarchy\VGset\VG_amp
% By Lei@TUe May3 2017

input_signal=obj.data;
for ch=1:size(input_signal,1)
    Vec =input_signal(ch,:); % one EEG channel
    windowSize= length(Vec);
    
    [VGmatrix1, D_vg]=TS2VGmatrix(Vec,'VG',0);
    coeff1 = getCoeff_VGnet(VGmatrix1);
    MD1=sum(D_vg)/windowSize;

    [VGmatrix2, D_hvg]=TS2VGmatrix(Vec,'HVG',0);
    coeff2 = getCoeff_VGnet(VGmatrix2);
    MD2=sum(D_hvg)/windowSize;
    
    % DVG= VG-HVG
    VGmatrix3=VGmatrix1-VGmatrix2;
    coeff3 = getCoeff_VGnet(VGmatrix3);
    MD3=MD1-MD2;
    D_dvg= D_vg-D_hvg;
    
    DD = [D_vg;D_hvg;D_dvg]; % [3*200]
    AC=[coeff1;coeff2;coeff3];% [3*t]
    MD=[MD1;MD2;MD3];% [3*t] 
    H = getEntropy2D(DD);% [3*1]
    lamda_vg =getLamda2D(DD, 'vg');
    lamda_dvg =getLamda2D(DD, 'dvg');
    
    %% average shortest paths of nodes
    N = size(VGmatrix1,1); 
    S1 = sparse(VGmatrix1'); 
    S2 = sparse(VGmatrix2'); 
    %  false for an undirected graph. the upper triangle of the sparse matrix being ignored.
    P_m1 = graphallshortestpaths(S1,'directed',false);
    SL1 = sum(sum(P_m1))/((N-1)*N);
    P_m2 = graphallshortestpaths(S2,'directed',false);
    SL2 = sum(sum(P_m2))/((N-1)*N);    
    SL=[SL1; SL2];% [2*t]
    
    Fv(ch,:)= [MD; AC;H;lamda_vg;lamda_dvg;SL];
end

    