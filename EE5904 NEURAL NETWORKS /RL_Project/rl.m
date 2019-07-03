%init
close all;clear;clc;

%load data
load('task1.mat');

%para
[state,action]=size(reward);
gamma=0.9;
hit=0;
ave_run_time=[];

for run=1:10
    tic;
    Q=zeros(state,action);
    Q1=zeros(state,action);
    trial=0;
    while trial<3000 
        Q1=Q;
        k=1;
        s=1;
        while s~=100
            epsilon=100/(100+k);
            alpha=epsilon;
            if alpha<0.005
                break;
            end
            
            val_act=find(reward(s,:)~=-1);
            if any(Q(s,:))
                p=rand;
                if p>=epsilon  %max
                    rand_idx=find(Q(s,val_act)==max(Q(s,val_act)));
                    idx=randperm(length(rand_idx),1); 
                    a=val_act(rand_idx(idx));
                else           %random
                    rand_idx=find(Q(s,val_act)~=max(Q(s,val_act)));
                    idx=randperm(length(rand_idx),1); 
                    a=val_act(rand_idx(idx));% randomly choose 1 action
                end
            else
                idx=randperm(length(val_act),1); 
                a=val_act(idx);
            end 
            switch a
                case 1
                    Q(s,a)=Q(s,a)+alpha*(reward(s,a)+gamma*max(Q(s-1,:))-Q(s,a));
                    s=s-1;
                case 2
                    Q(s,a)=Q(s,a)+alpha*(reward(s,a)+gamma*max(Q(s+10,:))-Q(s,a));
                    s=s+10;
                case 3
                    Q(s,a)=Q(s,a)+alpha*(reward(s,a)+gamma*max(Q(s+1,:))-Q(s,a));
                    s=s+1;
                case 4
                    Q(s,a)=Q(s,a)+alpha*(reward(s,a)+gamma*max(Q(s-10,:))-Q(s,a));
                    s=s-10;
            end
            k=k+1;
        end
        if Q1==Q
            break;
        end
        trial=trial+1;
    end
    %plot
    [~,route]=max(Q,[],2);
    toc;
    figure(run)
    title(['run = ',num2str(run),' , gamma = ',num2str(gamma),' , time = ',num2str(toc)]);
    grid on, hold on;
    ax=gca;
    ax.GridColor='k';
    ax.GridAlpha=0.5;
    axis([0 10 0 10],'square');
    text(9.3,0.5,'END','FontSize',14);
    
    i=1;
    z=1;
    total_reward=0;
    while i~=100 && z<100
        x=fix(i/10)+0.5;
        y=10.5-mod(i,10); % locate
        switch route(i)
            case 1
                scatter(x,y,75,'^','r'), hold on;
                total_reward=total_reward+gamma.^(z-1)*reward(i,1);
                i=i-1;
            case 2
                scatter(x,y,75,'>','r'), hold on;
                total_reward=total_reward+gamma.^(z-1)*reward(i,2);
                i=i+10;
            case 3
                scatter(x,y,75,'v','r'), hold on;
                total_reward=total_reward+gamma.^(z-1)*reward(i,3);
                i=i+1;
            case 4
                scatter(x,y,75,'<','r'), hold on;
                total_reward=total_reward+gamma.^(z-1)*reward(i,4);
                i=i-10;
        end
        z=z+1;
    end % draw path
    if i==state
        hit=hit+1;
        ave_run_time=[ave_run_time toc];
    end
end

execution_time=mean(ave_run_time);
disp(['No. of goal-reached runs :',num2str(hit)]);
disp(['Execution time :',num2str(execution_time), ' sec']);
disp(['Total Reward :',num2str(total_reward)]);