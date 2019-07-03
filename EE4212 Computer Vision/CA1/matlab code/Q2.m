%init
close all;clear;clc;

%load image
I=im2double(imread('image001.png'));

%SVD
[U,S,V]=svd(I);

%plot singular value spectrum
%plot(diag(S),'b');

%compress image
K=100;%20,40,60,80
Sk=S(1:K,1:K);
Uk=U(:,1:K);
Vk=V(:,1:K);
Imk=Uk*Sk*Vk';
imshow(Imk);
