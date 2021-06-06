function newset=feature_reconstruct(featureset)

%% input here>>>>>>>>>>
inputset=featureset; 

%% reconstruct cell data
[r_channel c1]=size(inputset);
cell_temp= inputset{1};
[r_feature c_time]=size(cell_temp);
% define new feature struction
newfeatureset=cell(r_feature,1);
for j=1:r_feature
    feature1=[];
    for i=1:r_channel
        temp1= inputset{i};
        feature1(i,:)=temp1(j,:);
    end 
    newfeatureset{j,:}=feature1;
end
newset=newfeatureset;