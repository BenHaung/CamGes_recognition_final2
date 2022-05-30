%%  刷新
clear all;
close all;
clc;

%%  參數 和 變數 初始修改地方

counter_error = zeros(9,9,5);
best_counter_error = zeros(10,10);
best_counter_error(1,1) = 0;
best_counter_error(2,1)= 1;
best_counter_error(3,1)= 2;
best_counter_error(4,1)= 3;
best_counter_error(5,1)= 4;
best_counter_error(6,1)= 5;
best_counter_error(7,1)= 6;
best_counter_error(8,1)= 7;
best_counter_error(9,1)= 8;
best_counter_error(10,1)= 9;
best_counter_error(1,2)= 1;
best_counter_error(1,3)= 2;
best_counter_error(1,4)= 3;
best_counter_error(1,5)= 4;
best_counter_error(1,6)= 5;
best_counter_error(1,7)= 6;
best_counter_error(1,8)= 7;
best_counter_error(1,9)= 8;
best_counter_error(1,10)= 9;
best_counter_error = cat(3,best_counter_error,best_counter_error);
best_counter_error = cat(3,best_counter_error,best_counter_error);
best_counter_all = zeros(5,20);
index = 1:900;
training_CamGes_G = [];
training_feature_CamGes1 = [];
load('CamGesData_groundtruth.mat');
load('training_feature_CamGes.mat');
between_CCA_PA = 195;
cross_set = 180;
set_class = 5;
training_real_index = zeros(90,1);
% plot_recognition1 = zeros(4,30);
% plot_recognition2 = zeros(30,1);
temp_answer = zeros(720,5);
groundtruth = [];
W = 1:30;
AAA = zeros(set_class-1,1);
training_index = (((set_class-1)*cross_set)+1):(set_class*cross_set);
space = 65; 

for round = 1:20
for l1 = 1:1
for l2 = 1:1
    
error_index1 = [];
error_index2 = [];
error_index3 = [];
for set_Cam = 1:set_class-1
    test_all_index = ((set_Cam-1)*cross_set)+1:((set_Cam)*cross_set);


for real_t = 1:9
   U_index = sort(randsample(20,10));  % 隨機挑選 frame 的 index
   training_real_index((real_t-1)*10+1:(real_t)*10) = U_index + ((real_t-1)*20);
end

for i = 1:length(test_all_index)
    
    
    groundtruth = CamGesData_groundtruth;


    test_index = test_all_index(i);                                         % 讓變數名稱一看就懂
    test_ans = CamGesData_groundtruth(test_index);                          % test data的答案
    
    % 設定 training data 和 test data 設定兩者已無共同data
    training_data = training_feature_CamGes(:,training_real_index,i,set_Cam);

    training_groundtruth = CamGesData_groundtruth(:,training_index(training_real_index));

    test_CCA = training_feature_CamGes(1:between_CCA_PA,:,i,set_Cam);
    test_PA = training_feature_CamGes((between_CCA_PA+1):(2*between_CCA_PA),:,i,set_Cam);    
    
    test_CCA_temp = [];
    test_PA_temp = [];
    for XXX = 1:3
       tempA = test_CCA(1+((XXX-1)*space):(XXX*space),:); 
       test_CCA_temp = cat(1,test_CCA_temp,tempA(1:round,:)); 
       tempA = test_PA(1+((XXX-1)*space):(XXX*space),:); 
       test_PA_temp = cat(1,test_PA_temp,tempA(1:round,:));         
    end
    test_CCA = test_CCA_temp;
    test_PA = test_PA_temp;
    
    
[not_you1 CCA_ans_index] = sort(sum(test_CCA),'descend');
[not_you2 PA_ans_index] = sort(sum(test_PA));
temp3 = [groundtruth(CCA_ans_index(1:W(l2)))];
% groundtruth(CCA_ans_index(1:W(l2)))
BB = unique([groundtruth(CCA_ans_index(1:W(l1))) ]);
% 
BB_ans = zeros(size(BB));
for oo=1:length(BB)
    BB_ans(oo)=length(find(temp3==BB(oo)));
end
[temp1 temp11] = max(BB_ans);

    counter_error(test_ans,BB(temp11),set_Cam) = counter_error(test_ans,BB(temp11),set_Cam)+1;  

% temp_index = find(PA_ans_index >= i);
% PA_ans_index(temp_index) = PA_ans_index(temp_index)+1;
% temp_index = find(CCA_ans_index >= i);
% CCA_ans_index(temp_index) = CCA_ans_index(temp_index)+1;
% error_index1 = cat(1,error_index1,PA_ans_index(1:W(l1)));
% error_index2 = cat(1,error_index2,PA_ans_index(1:W(l2)));
% error_index3 = cat(1,error_index3,CCA_ans_index(1:W(l1)));
    
end

accuracy = counter_error(1,1,set_Cam)+counter_error(2,2,set_Cam)+counter_error(3,3,set_Cam)+ ...
    counter_error(7,7,set_Cam)+counter_error(8,8,set_Cam)+counter_error(9,9,set_Cam)+ ...
    counter_error(4,4,set_Cam)+ counter_error(5,5,set_Cam)+counter_error(6,6,set_Cam);
accuracy = accuracy ./ 180
plot_recognition1(l1,l2,set_Cam) = accuracy;
% plot_recognition2(l2) = accuracy;

if AAA(set_Cam) < accuracy
    AAA(set_Cam) = accuracy;
    best_rhp1 = W(l1);
    best_rhp2 = W(l2);
    best_counter_error(2:10,2:10,set_Cam) = counter_error(:,:,set_Cam);
%     best_error_index1 = error_index1;
%     best_error_index2 = error_index2;
%     best_error_index3 = error_index3;
%     best_answer2 = temp_answer;
end
% counter_error
% counter_error(2:14,2:14) = zeros(13,13);
counter_error(:,:,set_Cam) = zeros(9,9);
% counter_error_final(2:10,2:10,set_Cam) = zeros(9,9);
end
end
end
best_counter_error
best_counter_all(1:4,round) = AAA;
best_counter_all(5,round) = mean(AAA);
AAA = zeros(4,1);
end

CCA_rho = best_counter_all;


for round = 1:20
for l1 = 1:1
for l2 = 1:1
    
error_index1 = [];
error_index2 = [];
error_index3 = [];
for set_Cam = 1:set_class-1
    test_all_index = ((set_Cam-1)*cross_set)+1:((set_Cam)*cross_set);


for real_t = 1:9
   U_index = sort(randsample(20,10));  % 隨機挑選 frame 的 index
   training_real_index((real_t-1)*10+1:(real_t)*10) = U_index + ((real_t-1)*20);
end

for i = 1:length(test_all_index)
    
    
    groundtruth = CamGesData_groundtruth;


    test_index = test_all_index(i);                                         % 讓變數名稱一看就懂
    test_ans = CamGesData_groundtruth(test_index);                          % test data的答案
    
    % 設定 training data 和 test data 設定兩者已無共同data
    training_data = training_feature_CamGes(:,training_real_index,i,set_Cam);

    training_groundtruth = CamGesData_groundtruth(:,training_index(training_real_index));

    test_CCA = training_feature_CamGes(1:between_CCA_PA,:,i,set_Cam);
    test_PA = training_feature_CamGes((between_CCA_PA+1):(2*between_CCA_PA),:,i,set_Cam);    
    
    test_CCA_temp = [];
    test_PA_temp = [];
    for XXX = 1:3
       tempA = test_CCA(1+((XXX-1)*space):(XXX*space),:); 
       test_CCA_temp = cat(1,test_CCA_temp,tempA(1:round,:)); 
       tempA = test_PA(1+((XXX-1)*space):(XXX*space),:); 
       test_PA_temp = cat(1,test_PA_temp,tempA(1:round,:));         
    end
    test_CCA = test_CCA_temp;
    test_PA = test_PA_temp;
    
    
[not_you1 CCA_ans_index] = sort(sum(test_CCA),'descend');
[not_you2 PA_ans_index] = sort(sum(test_PA));
temp3 = [groundtruth(PA_ans_index(1:W(l2)))];
% groundtruth(CCA_ans_index(1:W(l2)))
BB = unique([ groundtruth(PA_ans_index(1:W(l1)))]);
% 
BB_ans = zeros(size(BB));
for oo=1:length(BB)
    BB_ans(oo)=length(find(temp3==BB(oo)));
end
[temp1 temp11] = max(BB_ans);

    counter_error(test_ans,BB(temp11),set_Cam) = counter_error(test_ans,BB(temp11),set_Cam)+1;  

% temp_index = find(PA_ans_index >= i);
% PA_ans_index(temp_index) = PA_ans_index(temp_index)+1;
% temp_index = find(CCA_ans_index >= i);
% CCA_ans_index(temp_index) = CCA_ans_index(temp_index)+1;
% error_index1 = cat(1,error_index1,PA_ans_index(1:W(l1)));
% error_index2 = cat(1,error_index2,PA_ans_index(1:W(l2)));
% error_index3 = cat(1,error_index3,CCA_ans_index(1:W(l1)));
    
end

accuracy = counter_error(1,1,set_Cam)+counter_error(2,2,set_Cam)+counter_error(3,3,set_Cam)+ ...
    counter_error(7,7,set_Cam)+counter_error(8,8,set_Cam)+counter_error(9,9,set_Cam)+ ...
    counter_error(4,4,set_Cam)+ counter_error(5,5,set_Cam)+counter_error(6,6,set_Cam);
accuracy = accuracy ./ 180
plot_recognition1(l1,l2,set_Cam) = accuracy;
% plot_recognition2(l2) = accuracy;

if AAA(set_Cam) < accuracy
    AAA(set_Cam) = accuracy;
    best_rhp1 = W(l1);
    best_rhp2 = W(l2);
    best_counter_error(2:10,2:10,set_Cam) = counter_error(:,:,set_Cam);
%     best_error_index1 = error_index1;
%     best_error_index2 = error_index2;
%     best_error_index3 = error_index3;
%     best_answer2 = temp_answer;
end
% counter_error
% counter_error(2:14,2:14) = zeros(13,13);
counter_error(:,:,set_Cam) = zeros(9,9);
% counter_error_final(2:10,2:10,set_Cam) = zeros(9,9);
end
end
end
best_counter_error
best_counter_all(1:4,round) = AAA;
best_counter_all(5,round) = mean(AAA);
AAA = zeros(4,1);
end

best_counter_all
    best_rhp1
    best_rhp2 
PA_rho = best_counter_all;    
% index1 = UCF_groundtruth(best_error_index1(:,1:2));    
% PA_index = UCF_groundtruth(error_index1);  
% index3 = UCF_groundtruth(best_error_index3(:,1:2));    
% CCA_index = UCF_groundtruth(error_index3);    
    
%%  畫圖區

% 畫 P(W1|x)的取線
plot(1:20,PA_rho(1,:),'r');hold on;       
%畫超過 boundary 的剩餘P(W1|x)曲線
plot(1:20,CCA_rho(1,:),'b');hold on;
 %畫 P(W1|x)的取線

xlabel(' d 值','fontweight','bold','fontsize',14);
ylabel('辨識率','fontweight','bold','fontsize',14);
title('set1 參數值 d 的影響','fontweight','bold','fontsize',14);
legend('PA','CCA');
set(gca,'YGrid','on')

    
% xlabel('一般 KNN 的 K 值','fontweight','bold','fontsize',14);
% ylabel('辨識率','fontweight','bold','fontsize',14);
% title('一般 KNN 的參數影響','fontweight','bold','fontsize',14);
% % legend('1-NN','2-NN','3-NN','4-NN');
% set(gca,'YGrid','on')    
    
    
    
    
