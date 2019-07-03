%init
close all;clear;clc;

tic;
%load image
img=double(imread('cv2.png'));
%intrinsic para
[M,N,C]=size(img);
totalsizes=M*N;
RGB=reshape(img,[totalsizes,3]);
%extrinsic para
Numlables=2;
%kmeans
[init_lable,ctrs]=kmeans(RGB,Numlables);
%calculate distance
distance=zeros(Numlables,totalsizes);
for i=1:totalsizes
    for j=1:Numlables       
        distance(j,i)=dist(RGB(i),ctrs(j,:)');        
    end
end
%neighbour
Neig_R=neighbours4(RGB(:,1),M,N);
Neig_G=neighbours4(RGB(:,2),M,N);
Neig_B=neighbours4(RGB(:,3),M,N);
NeigM=(Neig_R+Neig_G+Neig_B)./3;
%GCO toolbox
h=GCO_Create(totalsizes,Numlables);
GCO_SetLabeling(h,init_lable);
GCO_SetDataCost(h,distance);
GCO_SetNeighbors(h,NeigM);
GCO_SetVerbosity(h,2);
GCO_SetLabelOrder(h,randperm(Numlables));
GCO_Expansion(h);
Labeling = GCO_GetLabeling(h);  
GCO_Delete(h);
%plot
img1=reshape(Labeling,M,N);
map=ctrs./255;
cmap=colormap(map);
img1=label2rgb(img1,cmap);
figure(1)
subplot(1,2,1);imshow(uint8(img));
title('The original');
subplot(1,2,2);imshow(uint8(img1));
title(['K=',num2str(Numlables)]);  
toc;
%user-defined function
function Neighbours = neighbours4(img,M,N)
    m = M;
    n = N;
    totalsizes = m*n;
    var_img = var(img(:));
    i1 = (1:totalsizes-m)';
    j1 = i1+m;
    for i = 1:n
        i2_tem(:,i) = (i-1)*m + (1:m-1)';
    end
    i2 = i2_tem(:);
    j2 = i2+1;
    ans1 = exp(-(img(i1(:))-img(j1(:))).^2/(2*var_img));
    ans2 = exp(-(img(i2(:))-img(j2(:))).^2/(2*var_img));
    all = [[i1;i2],[j1;j2],[ans1;ans2]];
    neighb = spconvert(all);
    neighb(totalsizes,totalsizes) = 0;
    Neighbours = neighb;
end