%init 
close all;clear;clc;

%load files
img1=imread('frc1.tif');
img2=imread('frc2.tif');

%establish point correspondences manually
%cpselect(img1,img2);
%save('struct_inria8.mat','cpstruct');
load('struct_frc16.mat');
p=cpstruct.inputPoints';%2*n
p_prime=cpstruct.basePoints';
N=length(p);

F=estimatedF(p,p_prime,N);
F

displayEpipolarF(img1,img2,F);