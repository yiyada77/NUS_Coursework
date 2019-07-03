%init
close all;clear;clc;

%init train&test matrix
trainC=cell(1,119); %70%
testC=cell(1,51);  %30%
TrData=zeros(1024,2387);
TrLabel=zeros(2387,1);
TeData=zeros(1024,1023);
TeLabel=zeros(1023,1);

%select pie randomly
idx_pie=randperm(67,20);
idx=randperm(170);
for i=1:20
    path=dir(strcat('PIE/',num2str(idx_pie(i)),'/*.jpg'));
    for j=1:119
        trainC{j}=imread(strcat('PIE/',num2str(idx_pie(i)),'/',path(idx(j)).name));    
    end
    for j=120:170
        testC{j-119}=imread(strcat('PIE/',num2str(idx_pie(i)),'/',path(idx(j)).name));
    end
    %train set
    Img=double(cell2mat(trainC));
    Img=reshape(Img,[1024,119]);
    TrData(:,((i-1)*119+1):((i-1)*119+119))=Img;
    TrLabel(((i-1)*119+1):((i-1)*119+119))=idx_pie(i)*ones(119,1);
    %test set
    Img=double(cell2mat(testC));
    Img=reshape(Img,[1024,51]);
    TeData(:,((i-1)*51+1):((i-1)*51+51))=Img;
    TeLabel(((i-1)*51+1):((i-1)*51+51))=idx_pie(i)*ones(51,1);
end

%process self pics
path=dir('*.png');
I=zeros(1024,10);
for i=1:10
    img=imread(path(i).name);
    img=rgb2gray(imresize(img,[32,32]));
    img=reshape(img,[1024,1]);
    I(:,i)=img;
end
TrData(:,2381:2387)=I(:,1:7);
TrLabel(2381:2387)=0;
TeData(:,1021:1023)=I(:,8:10);
TeLabel(1021:1023)=0;

%save
save('face.mat','TrData','TrLabel','TeData','TeLabel'); %data for PCA,LDA,SVM
%save('faceCNN.mat','TrData','TrLabel','TeData','TeLabel');  %data for CNN






