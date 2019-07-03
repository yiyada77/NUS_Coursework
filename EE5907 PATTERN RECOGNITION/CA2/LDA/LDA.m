%init
close all;clear;clc;

%load 
load face.mat;
%500 sample
idx=randperm(2387,1100);
S=TrData(:,idx);
SL=TrLabel(idx);
MS=mean(S,2);
C=tabulate(SL); %class

% mu=zeros(1024,length(C));
Sw=zeros(1024,1024);
Sb=zeros(1024,1024);
for i=1:length(C)
    idx=find(SL==C(i,1));
    x=S(:,idx);
%     mu(:,i)=mean(x,2);
    Si=(x-mean(x,2))*(x-mean(x,2))'./C(i,2);
    
    Sw=Sw+0.01*C(i,3).*Si;
    Sb=Sb+0.01*C(i,3)*(mean(x,2)-MS)*(mean(x,2)-MS)';
end
W=Sw\Sb;
[U,~,~]=svd(W);
%reduce to 2D & 3D
LDA_2D=S'*U(:,1:2);
LDA_3D=S'*U(:,1:3);
%visualize 2D & 3D
figure(1)
for i=1:length(C)
    if C(i,1)==0 %highlight myself face 
        p=find(SL==0);
        scatter(LDA_2D(p,1),LDA_2D(p,2),400,'d','r');
        hold on; 
    else
        title('2D LDA');
        p=find(SL==C(i,1));
        scatter(LDA_2D(p,1),LDA_2D(p,2),'+');
        hold on;
    end 
end
figure(2)
for i=1:length(C)
    if C(i,1)==0
        p=find(SL==0);
        scatter3(LDA_3D(p,1),LDA_3D(p,2),LDA_3D(p,3),400,'d','r');
        hold on; 
    else
        title('3D LDA');
        p=find(SL==C(i,1));
        scatter3(LDA_3D(p,1),LDA_3D(p,2),LDA_3D(p,3),'+');
        hold on;
    end 
end
%visualize 3 eigenfaces
figure(3)
subplot(1,3,1);    
imshow(reshape(U(:,1),32,32),[]),title('face 1');
subplot(1,3,2);
imshow(reshape(U(:,2),32,32),[]),title('face 2');
subplot(1,3,3);
imshow(reshape(U(:,3),32,32),[]),title('face 3');

%500 sample over
% whole images
% test classification
PIE=TeData(:,1:1020);
OWN=TeData(:,1021:1023);

M_ALL=mean(TrData,2);
C_ALL=tabulate(TrLabel); %class

Sw_ALL=zeros(1024,1024);
Sb_ALL=zeros(1024,1024);
for i=1:length(C_ALL)
    idx=find(TrLabel==C_ALL(i,1));
    x=TrData(:,idx);
    Si_ALL=(x-mean(x,2))*(x-mean(x,2))'./C_ALL(i,2);
    
    Sw_ALL=Sw_ALL+0.01*C_ALL(i,3).*Si_ALL;
    Sb_ALL=Sb_ALL+0.01*C_ALL(i,3)*(mean(x,2)-M_ALL)*(mean(x,2)-M_ALL)';
end
W_ALL=Sw_ALL\Sb_ALL;
[U_ALL,~,~]=svd(W_ALL);
d=[2,3,9];
for i=1:3
    K=d(i);
    TRAIN_img=TrData'*U_ALL(:,1:K);
    PIE_img=PIE'*U_ALL(:,1:K);
    OWN_img=OWN'*U_ALL(:,1:K);   
    %knn
    PIE_idx=knnsearch(TRAIN_img,PIE_img);
    OWN_idx=knnsearch(TRAIN_img,OWN_img);
    PIE_acc=sum(TrLabel(PIE_idx)==TeLabel(1:1020))/1020;
    OWN_acc=sum(TrLabel(OWN_idx)==TeLabel(1021:1023))/3;
    display(['K =',num2str(K),', accuracy of PIE = ',...
        num2str(PIE_acc),', accuracy of OWN = ',num2str(OWN_acc)]);
end