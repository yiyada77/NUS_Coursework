%init
close all;clear;clc;

%Data process
%0-ship .  1-deer
file_dir0='../group_2/ship/';%路径前缀
file_dir1='../group_2/deer/';
img_list0=dir(strcat(file_dir0,'*.jpg'));%格式 img_ship_list1.name = 000.jpg
img_list1=dir(strcat(file_dir1,'*.jpg'));%返回当前路径中的所有文件以及文件夹所组成的列表

image_c0=cell(1,500);
image_c1=cell(1,500);

for i=1:500
    img_name0 = strcat(file_dir0,img_list0(i).name);%得到完整的路径
    img_name1 = strcat(file_dir1,img_list1(i).name);
    img_rgb0=imread(num2str(img_name0));%将每张图片读出 rgb
    img_rgb1=imread(num2str(img_name1));
    image_c0{:,i}=img_rgb0;
    image_c1{:,i}=img_rgb1;
end

image_mat0=cell2mat(image_c0);
image_mat1=cell2mat(image_c1);
img_gray0=rgb2gray(image_mat0);%灰度化
img_gray1=rgb2gray(image_mat1);
train_image0=reshape(img_gray0,1024,500);
train_image1=reshape(img_gray1,1024,500);

%combine ship and deer to generate train and validation set
train_set=horzcat(train_image0(:,1:450),train_image1(:,1:450));
valid_set=horzcat(train_image0(:,451:500),train_image1(:,451:500));
train_set=double(train_set);
valid_set=double(valid_set); 

%save train set and validation set
save('train_set.mat','train_set');
save('valid_set.mat','valid_set');

%Generate Training Set and Validation Set
TrainSet=horzcat(train_image0(:,1:450),train_image1(:,1:450));
ValSet=horzcat(train_image0(:,451:500),train_image1(:,451:500));
TrainSet=double(TrainSet);
ValSet=double(ValSet);
%Save Result
save('TrainSet.mat','TrainSet');
save('ValSet.mat','ValSet');