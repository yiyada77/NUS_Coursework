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
%train set
rand_index=randperm(N,2);% randomly choose 2 centres
center=double(train_data(:,rand_index));

% N=length(train_classlabel);
%trainIdx=find(train_classlabel==1|train_classlabel==7); %find the location of classes 1,7
% train_label_1=train_data(:,trainIdx);
trainIdx_0=find(train_classlabel==0|train_classlabel==2|train_classlabel==3|train_classlabel==4|train_classlabel==5|train_classlabel==6|train_classlabel==8|train_classlabel==9);
% train_label_0=train_data(:,trainIdx_0);
% rand_index_1=randperm(size(train_label_1,2),1);% randomly choose 2 centres
% rand_index_0=randperm(size(train_label_0,2),1);% randomly choose 2 centres
% center(:,1)=train_data(:,rand_index_1);
% center(:,2)=train_data(:,rand_index_0);

% %train set
% rand_index=randperm(N,2);% randomly choose 2 centres
% center=train_data(:,rand_index);

for i=1:100 %loop untill convergence
    distance1=dist(train_data',center(:,1));%calculate train data distance to 1,2
    distance2=dist(train_data',center(:,2));
    center1ind=find(distance1>distance2);
    center2ind=find(distance1<distance2);
    cluster1=train_data(:,center1ind);%divide into 2 part
    cluster2=train_data(:,center2ind);

    error_dist_1=sum(dist(cluster1',center(:,1)))/length(cluster1);
    error_dist_2=sum(dist(cluster2',center(:,2)))/length(cluster2);
    
    center(:,1)=mean(cluster1,2);
    center(:,2)=mean(cluster2,2);
    cluster1=[];
    cluster2=[];
end
figure(1)
tmp1=reshape(center(:,1),28,28); 
subplot(2,2,1);
imshow(zscore(tmp1));
title('center 1');
tmp2=reshape(center(:,2),28,28);
subplot(2,2,2);
imshow(zscore(tmp2));
title('center 2');

train_1=double(train_data(:,trainIdx));
mean_1=mean(train_1,2);
subplot(2,2,3);
imshow(zscore(reshape(mean_1,28,28)));
title('mean 1');
train_0=double(train_data(:,trainIdx_0));
mean_0=mean(train_0,2);
subplot(2,2,4);
imshow(zscore(reshape(mean_0,28,28)));
title('mean 0');

width=7;
lambda=0;
phi=zeros(N,2);
for i=1:N
    for j=1:2
        r=dot(train_data(:,i)-center(:,j),train_data(:,i)-center(:,j));
        phi(i,j)=exp(r/(-2*width.^2));
    end
end
phi=[ones(N,1),phi];
%w=pinv(phi'*phi+lambda*eye(2+1))*phi'*TrLabel';%get the unique solution w
w=pinv(phi)*TrLabel';
TrPred=phi*w;
%test data
phi_test=zeros(N_test,2);%initialize phi_test
for i=1:N_test
    for j=1:2
        r=dot(test_data(:,i)-center(:,j),test_data(:,i)-center(:,j));
        phi_test(i,j)=exp(r/(-2*width.^2));
    end
end
phi_test=[ones(N_test,1),phi_test];
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
figure(2)
plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('train data','test data');
%axis([-0.04,0.65,0.2,0.8]);
title(['The performance of the RBFN, when regulation=',num2str(lambda)]);
xlabel('threshold');
ylabel('accuracy');
atr=max(TrAcc);
ate=max(TeAcc);