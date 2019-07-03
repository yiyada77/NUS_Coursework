%init
close all;clear;clc;

%load files
load('mnist_m.mat');

N=length(train_classlabel);
N_test=length(test_classlabel);

trainIdx=find(train_classlabel==1|train_classlabel==7); %find the location of classes 1,7
testIdx=find(test_classlabel==1|test_classlabel==7);

TrLabel=zeros(1,N);
TeLabel=zeros(1,N_test);
TrLabel(trainIdx)=1;%the selected two classes should be assigned the label 1
TeLabel(testIdx)=1;
lambda=0;%regulation factor

rand_index=randperm(N,2);% randomly choose centres
M=train_data(:,rand_index);
countM=size(M,2);

width=7; 
% dist_M=dist(M',M);
% max_dist=max(max(dist_M));
% dist_M(dist_M==0)=inf;
% min_dist=min(min(dist_M));
% coef=countM/(-(max_dist-min_dist).^2);

phi=zeros(N,countM);
for i=1:N
    for j=1:countM
        r=dot(train_data(:,i)-M(:,j),train_data(:,i)-M(:,j));
        phi(i,j)=exp(r/(-2*width.^2));
    end
end
% phi=[ones(N,1),phi];
% w=pinv(phi'*phi+lambda*eye(countM+1))*phi'*TrLabel';%get the unique solution w
w=pinv(phi)*TrLabel';
TrPred=phi*w;
%test data
phi_test=zeros(N_test,countM);%initialize phi_test
for i=1:N_test
    for j=1:countM
        r=dot(test_data(:,i)-M(:,j),test_data(:,i)-M(:,j));
        phi_test(i,j)=exp(r/(-2*width.^2));
    end
end
%phi_test=[ones(N_test,1),phi_test];
TePred=phi_test*w;

%evaluate
TrAcc = zeros(1,1000);
TeAcc = zeros(1,1000);
thr = zeros(1,1000);

for i = 1:1000
t = (max(TrPred)-min(TrPred)) * (i-1)/1000 + min(TrPred); thr(i) = t;
TrAcc(i) = (sum(TrLabel(TrPred<t)==0) + sum(TrLabel(TrPred>=t)==1)) / N;
TeAcc(i) = (sum(TeLabel(TePred<t)==0) + sum(TeLabel(TePred>=t)==1)) / N_test;
end
plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('train data','test data');
%axis([-0.04,0.65,0.2,0.8]);
title(['The performance of the RBFN, when regulation=',num2str(lambda)]);
xlabel('threshold');
ylabel('accuracy');
atr=max(TrAcc);
ate=max(TeAcc);
