%init
close all;clear;clc;

%read images
A=double(imread('A8.png'));
figure(3)
imshow(uint8(A));
B=double(imread('B8.png'));
figure(2)
imshow(uint8(B));

[Arow,Acol]=size(A(:,:,1));
[Brow,Bcol]=size(B(:,:,1));
%para set
iteration=5;
patch_size=5;
r=0.5*(patch_size-1);%half patch size
radius0=0.5*max(Brow,Bcol);
alpha=0.5;
patch_construct=0;
B_pad=nan(Brow+2*r,Bcol+2*r,3);
B_pad(r+1:Brow+r,r+1:Bcol+r,:)=B;
%NNF matrix
NNF=cat(3,randi([1+r,Arow-r],[Brow,Bcol]),randi([1+r,Acol-r],[Brow,Bcol]));
%init
D=zeros(Brow,Bcol); 
for i=1:Brow
    for j=1:Bcol
        D(i,j)=SSD(NNF(i,j,1),NNF(i,j,2),A,B_pad,i,j,r);
    end
end
% iteration steps
for k=1:iteration
    if mod(k,2) % even/odd logic  odd 
        seq_i=1:Brow;
        seq_j=1:Bcol;
    else
        seq_i=Brow:(-1):1;
        seq_j=Bcol:(-1):1;
    end     
    for i=seq_i % propagation  
        for j=seq_j
            if mod(k,2)% odd              
                up=D(max(i-1,1),j);
                left=D(i,max(j-1,1));
                Now=D(i,j);
                Top=(NNF(max(i-1,1),j,1) + 1 <= Arow - r); 
                Left=(NNF(i,max(j-1,1),2) + 1 <= Acol - r);
                if (Top && up<Now && up < left) % propagate from top
                    NNF(i,j,1)=NNF(i-1,j,1)+1;
                    NNF(i,j,2)=NNF(i-1,j,2);
                    D(i,j)=SSD(NNF(i,j,1),NNF(i,j,2),A,B_pad,i,j,r);
                elseif (Left && left<up && left < Now) % propagate from left
                    NNF(i,j,1)=NNF(i,j-1,1);
                    NNF(i,j,2)=NNF(i,j-1,2)+1;
                    D(i,j)=SSD(NNF(i,j,1),NNF(i,j,2),A,B_pad,i,j,r);
                end
            else % even           
                down=D(min(i+1,Brow),j);
                right=D(i,min(j+1,Bcol));
                Now=D(i,j);
                Down=(NNF(min(i+1,Brow),j,1) - 1 > r);
                Right=(NNF(i,min(j+1,Bcol),2) - 1 > r); 
                if (Down && down<Now && down < right) % propagate from top
                    NNF(i,j,1)=NNF(i+1,j,1)-1;
                    NNF(i,j,2)=NNF(i+1,j,2);
                    D(i,j)=SSD(NNF(i,j,1),NNF(i,j,2),A,B_pad,i,j,r);
                elseif (Right && right<down && right < Now) % propagate from left
                    NNF(i,j,1)=NNF(i,j+1,1);
                    NNF(i,j,2)=NNF(i,j+1,2)-1;
                    D(i,j)=SSD(NNF(i,j,1),NNF(i,j,2),A,B_pad,i,j,r);
                end
            end           
            % random search
            count=0;
            centeri=NNF(i,j,1);
            centerj=NNF(i,j,2);
            while true
                R=floor((alpha.^count)*radius0);
                if R<1
                    break;
                end
                % search boundary
                newi=randi([max(centeri-R,1+r),min(centeri+R,Arow-r)]);
                newj=randi([max(centerj-R,1+r),min(centerj+R,Acol-r)]);
                dis=SSD(newi,newj,A,B_pad,i,j,r);
                if (dis<D(i,j)) %find min
                    NNF(i,j,1)=newi;
                    NNF(i,j,2)=newj;
                    D(i,j)=dis;
                end
                count=count+1;
            end
        end 
    end      
    % reconstruction
    newB=zeros(size(B));  
    for i=1:Brow
        for j=1:Bcol
            newB(i,j,:)=A(NNF(i,j,1),NNF(i,j,2),:);
        end
    end
    figure(1);
    imshow(uint8(newB));  
    %drawnow  
end
% reconstruction
newB=zeros(size(B));
for i=1:Brow
	for j=1:Bcol
        newB(i,j,:)=A(NNF(i,j,1),NNF(i,j,2),:);
	end
end
figure(1);
imshow(uint8(newB));

function NNF=SSD(centeri,centerj,A,B_pad,i,j,r)
    D=A(centeri-r:centeri+r,centerj-r:centerj+r,:)-B_pad(i+r-r:i+2*r,j+r-r:j+2*r,:);
    D=D(~isnan(D(:)));
    NNF=sum(D.^2)/length(D); % normalise
end

