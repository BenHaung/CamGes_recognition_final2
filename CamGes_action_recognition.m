%%  穝
clear all;
close all;
clc;

%%  把计 ㎝ 跑计 ﹍эよ

index = [1:1:900];
training_CamGes_G = [];
training_feature_CamGes1 = [];
load('CamGesData_groundtruth.mat');
load('CamGesData.mat');
video_dataset = CamGesData;
cross_set = 180;
set_class = 5;
training_feature_CamGes = zeros(390,180,720,5);



%%
for j = 1:set_class
training_index = (((j-1)*cross_set)+1):(j*cross_set);
if j == 1
    test_all_index = ((j*cross_set)+1):(set_class*cross_set);
elseif j == 5
    test_all_index = 1:((j-1)*cross_set);
else
    test_all_index = [1:((j-1)*cross_set) ((j*cross_set)+1):(set_class*cross_set)];
end

for i = 1:length(test_all_index)
    tic
    fprintf(1,'i=%d\n',i);
    
    test_index = test_all_index(i);                                         % 琵跑计嘿碞来
    test_ans = CamGesData_groundtruth(test_index);                          % test data氮
    
    % 砞﹚ training data ㎝ test data 砞﹚ㄢ礚data
    training_data = CamGesData(:,training_index);
    test_data = CamGesData(:,test_index);
    training_groundtruth = CamGesData_groundtruth(:,training_index);
    
   
    for k = 1:length(training_data)
        G_distance = geodesic_distance6(training_data{k},test_data{1});
        training_feature_CamGes(:,k,i,j) = G_distance;
    end

    toc
end
end


save('training_feature_CamGes.mat','training_feature_CamGes');


