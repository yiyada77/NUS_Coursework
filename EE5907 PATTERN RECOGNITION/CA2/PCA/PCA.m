%init
close all;clear;clc;

%load 
load face.mat;
%500 sample
idx=randperm(2387,500);
S=TrData(:,idx);
SL=TrLabel(idx);
class=unique(SL);
S=S-mean(S,2);
X=S*S';
[U,~,~]=svd(X);
%reduce to 2D & 3D
PCA_2D=S'*U(:,1:2);
PCA_3D=S'*U(:,1:3);
%visualize 2D & 3D
figure(1)
for i=1:length(class)
    if class(i)==0 %highlight myself face 
        p=find(SL==0);
        scatter(PCA_2D(p,1),PCA_2D(p,2),400,'d','r');
        hold on; 
    else
        title('2D PCA');
        p=find(SL==class(i));
        scatter(PCA_2D(p,1),PCA_2D(p,2),'+');
        hold on;
    end 
end
figure(2)
for i=1:length(class)
    if class(i)==0
        p=find(SL==0);
        scatter3(PCA_3D(p,1),PCA_3D(p,2),PCA_3D(p,3),400,'d','r');
        hold on; 
    else
        title('3D PCA');
        p=find(SL==class(i));
        scatter3(PCA_3D(p,1),PCA_3D(p,2),PCA_3D(p,3),'+');
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
%whole images
%test classification
M=mean(TrData,2);
TrData=TrData-M;
TeData=TeData-M;
PIE=TeData(:,1:1020);
OWN=TeData(:,1021:1023);
d=[40,80,200];
[U,~,~]=svd(TrData*TrData');
for i=1:3
    K=d(i);
    TRAIN_img=TrData'*U(:,1:K);
    PIE_img=PIE'*U(:,1:K);
    OWN_img=OWN'*U(:,1:K);    
    %knn & accuracy
    PIE_idx=knnsearch(TRAIN_img,PIE_img);
    OWN_idx=knnsearch(TRAIN_img,OWN_img);
    PIE_acc=sum(TrLabel(PIE_idx)==TeLabel(1:1020))/1020;
    OWN_acc=sum(TrLabel(OWN_idx)==TeLabel(1021:1023))/3;
    display(['K =',num2str(K),', accuracy of PIE = ',...
        num2str(PIE_acc),', accuracy of OWN = ',num2str(OWN_acc)]);
end
