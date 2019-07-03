%init
close all;clear;clc;

%read image
I_samp=double(imread('texture5.jpg'));

dim=ndims(I_samp);
if(dim==2)
    I_samp=repmat(I_samp,[1 1 3]);
end
% sigma=0.5;
% I_samp=imgaussfilt(I_samp,sigma);

N=size(I_samp,1);
size_block=39; 
iteration=11;
size_overlap=round(size_block/6);
%creat empty image
size_sny=iteration*size_block-(iteration-1)*size_overlap;
I_sny=zeros(size_sny,size_sny,3);
similarity=zeros(64-size_block,64-size_block);
%rand select initial block center
ini_row=randperm(N-size_block,1);
ini_col=randperm(N-size_block,1);
% %initial 
I_sny(1:size_block,1:size_block,:)=I_samp(ini_row:ini_row+size_block-1,ini_col:ini_col+size_block-1,:);

for i=1:iteration
    for j=1:iteration
        %localization       
        p_left=(i-1)*(size_block-size_overlap)+1;
        p_right=p_left+size_block-1;
        p_up=(j-1)*(size_block-size_overlap)+1;
        p_down=p_up+size_block-1;
        p_image=I_sny(p_left:p_right,p_up:p_down,:);
        %similarity
        for m=1:N-size_block
            for n=1:N-size_block
                tmp=I_samp(m:m+size_block-1,n:n+size_block-1,:);
                similarity(m,n)=sum((p_image(:)>0).*(p_image(:)-tmp(:)).^2);
            end
        end
        %find max similarity
        [row,col]=find(similarity==min(min(similarity)),1);
        I_sny(p_left:p_right,p_up:p_down,:)=I_samp(row:row+size_block-1,col:col+size_block-1,:); 

        %Minimum Error Boundary Cut
        %vertical cut start
        temp=I_samp(row:row+size_block-1,col:col+size_block-1,:);%closest block
        path_record=sum((p_image(:,size_block-size_overlap+1:end,:)-temp(:,1:size_overlap,:)).^2,3);
        tmp_3=zeros(1,3);
        idx=zeros(size(path_record,1),1);
        for p=1:size(path_record,1)
            k=size(path_record,1)-p+1;           
            if(k==size(path_record,1)) %k is the last row
                min_p=find(path_record(k,:)==min(path_record(k,:)),1);
            else
                min_p=find(tmp_3==min(tmp_3),1);
            end           
            idx(k)=min_p;
            if k>1
                if (1<min_p)&&(min_p<size_overlap)
                    tmp_3=path_record(k-1,min_p-1:min_p+1);
                else
                    if min_p==1
                        tmp_3=path_record(k-1,min_p:min_p+2);
                    else
                        tmp_3=path_record(k-1,min_p-2:min_p);
                    end
                end
            end      
        end
        for q=1:size(path_record,1) %paste            
            temp(q,1:idx(q),:)=p_image(q,1:idx(q),:);            
        end
        %vertical cut over
        
        %horizontal cut start
        if i>1 %from 2rd row        
            u_left=(i-2)*(size_block-size_overlap)+1;
            u_right=u_left+size_block-1;
            u_image=I_sny(u_left:u_right,p_up:p_down,:);
            u_path_record=sum((u_image(size_block-size_overlap+1:end,:,:)-temp(1:size_overlap,:,:)).^2,3);
            u_path_record=u_path_record';
            tmp_3=zeros(1,3);
            idx=zeros(size(u_path_record,1),1);
            for p=1:size(u_path_record,1)
                k=size(u_path_record,1)-p+1;           
                if(k==size(u_path_record,1)) %k is the last row
                    min_p=find(u_path_record(k,:)==min(u_path_record(k,:)),1);
                else
                    min_p=find(tmp_3==min(tmp_3),1);
                end           
                idx(k)=min_p;
                if k>1
                    if (1<min_p)&&(min_p<size_overlap)
                        tmp_3=u_path_record(k-1,min_p-1:min_p+1);
                    else
                        if min_p==1
                            tmp_3=u_path_record(k-1,min_p:min_p+2);
                        else
                            tmp_3=u_path_record(k-1,min_p-2:min_p);
                        end
                    end
                end
            end            
            for q=1:size(u_path_record,1) %paste            
                temp(1:idx(q),q,:)=u_image((size_block-size_overlap):(size_block-size_overlap+idx(q)-1),q,:);            
            end                      
        end        
        %horizontal cut over  
        if j==1
           temp=I_samp(row:row+size_block-1,col:col+size_block-1,:);
        end
        I_sny(p_left:p_right,p_up:p_down,:)=temp; 
        imshow(uint8(I_sny));
    end    
end

