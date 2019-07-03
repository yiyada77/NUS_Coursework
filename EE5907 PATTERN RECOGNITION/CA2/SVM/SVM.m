%init
close all;clear;clc;

%load 
load face.mat;

M=mean(TrData,2);
TrData=TrData-M;
TeData=TeData-M;
PIE=TeData(:,1:1020);
OWN=TeData(:,1021:1023);
PIEL=TeLabel(1:1020);
OWNL=TeLabel(1021:1023);
[U,~,~]=svd(TrData);
%reduce to 80D & 200D
% d=[80,200];
% for i=1:2
for K=80
%     K=d(i);
    TRAIN_img=TrData'*U(:,1:K);
    PIE_img=PIE'*U(:,1:K);
    OWN_img=OWN'*U(:,1:K);
    %svm
    SVMStruct=svmtrain(TrLabel,TRAIN_img,'-t 0  -c 1');
    ACC_PIE=svmpredict(PIEL,PIE_img,SVMStruct);
    ACC_OWN=svmpredict(OWNL,OWN_img,SVMStruct);
end


