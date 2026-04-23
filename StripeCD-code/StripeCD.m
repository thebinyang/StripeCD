%LR CD by Bin Yang
clc;clear all;close all;
tic
addpath('G:\LRCD\LR\StripeCD-code\proximal_operators');
addpath('G:\LRCD\LR\StripeCD-code\SLIC_functions');

out=[];
for i=10:10:50   % i=10:10:50
    
    %% Load mat data
% %     Santa Barbara Dataset
%     prepath=['G:\LRCD\matSave\prechange_SB_', num2str(i), '.mat'];
%     postpath=['G:\LRCD\matSave\postchange_SB_',num2str(i),'.mat'];
%     gtpath= 'D:\002-Data\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\santaBarbara\mat\barbara_gtChanges.mat';
%     prechange=load(prepath);
%     prechange=double(prechange.data);
%     postchange=load(postpath);
%     postchange=double(postchange.data);
%     gt=load(gtpath);
%     gt=double(gt.HypeRvieW);
%     % We assign 0 to unchanged, 0.5 to unknown and 1 to changed pixels
%     gt_trans=zeros(size(gt));
%     gt_trans(gt==2)=0;
%     gt_trans(gt==0)=0.5;
%     gt_trans(gt==1)=1;
%     ori_pre=load("D:\002-Data\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\santaBarbara\mat\barbara_2013.mat");
%     ori_pre=double(ori_pre.HypeRvieW);
%     ori_post=load("D:\002-Data\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\santaBarbara\mat\barbara_2014.mat");
%     ori_post=double(ori_post.HypeRvieW);
% 
%     %Bay Area Dataset
%     prepath=['G:\LRCD\matSave\prechange_BA_',num2str(i),'.mat'];
%     postpath=['G:\LRCD\matSave\postchange_BA_',num2str(i),'.mat'];
%     gtpath= 'D:\002-Data\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\bayArea\mat\bayArea_gtChanges2.mat.mat';
%     prechange=load(prepath);
%     prechange=double(prechange.data);
%     postchange=load(postpath);
%     postchange=double(postchange.data);
%     gt=load(gtpath);
%     gt=double(gt.HypeRvieW);
% %     We assign 0 to unchanged, 0.5 to unknown and 1 to changed pixels
%     gt_trans=zeros(size(gt));
%     gt_trans(gt==2)=0;
%     gt_trans(gt==0)=0.5;
%     gt_trans(gt==1)=1;
%     ori_pre=load("D:\002-Data\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\bayArea\mat\Bay_Area_2013.mat");
%     ori_pre=double(ori_pre.HypeRvieW);
%     ori_post=load("D:\002-Data\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\bayArea\mat\Bay_Area_2015.mat");
%     ori_post=double(ori_post.HypeRvieW);

%     % Heminston Dataset
    prepath=['G:\LRCD\matSave\prechange_HE_',num2str(i),'.mat'];
    postpath=['G:\LRCD\matSave\postchange_HE_',num2str(i),'.mat'];
    %gtpath= "D:\002-Data\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\Hermiston\rdChangesHermiston_5classes.mat";
    gtpath= "G:\可变形非监督变化检测\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\Hermiston\rdChangesHermiston_5classes.mat";

    prechange=load(prepath);
    prechange=double(prechange.data);
    postchange=load(postpath);
    postchange=double(postchange.data);
    gt=load(gtpath);
    gt=double(gt.gt5clasesHermiston);
    gt(gt>0)=1;
    gt_trans=gt;
    %ori_pre=load("D:\002-Data\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\Hermiston\hermiston2004.mat");
    ori_pre=load("G:\可变形非监督变化检测\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\Hermiston\hermiston2004.mat");

    ori_pre=double(ori_pre.HypeRvieW);
   % ori_post=load("D:\002-Data\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\Hermiston\hermiston2007.mat");
    ori_post=load("G:\可变形非监督变化检测\015-HyperspectralCD-bayArea-Hermiston-santaBarbara\Hermiston\hermiston2007.mat");
    ori_post=double(ori_post.HypeRvieW);
% %  


    [m,n,p]=size(prechange);
%     figure
%     imshow(gt,'border','tight');

    dif=abs(prechange-postchange);

    %% channel selection method 1
    retainpercent=0.5;
    [row,col,nchannel]=size(dif);
    dif_std=std(dif,0,[1,2]);
    [std_value,std_idx]=sort(-dif_std);
    sidx=std_idx(1:round(nchannel*retainpercent));   % round 四舍五入函数
    sleband=length(sidx);
    dif=dif(:,:,sidx);
    % 只用方差的策略
    s_prechange=prechange(:,:,sidx);
    s_postchange=postchange(:,:,sidx);  
    
    s_prechange=(s_prechange-mean(s_prechange,[1 2]))./(std(s_prechange, 0, [1 2]));
    s_postchange=(s_postchange-mean(s_postchange, [1 2]))./(std(s_postchange,0, [1 2]));
    
    %% 提取change map probability
    cm=extract_cmp(s_prechange,s_postchange,gt_trans,ori_pre,ori_post,i);

    %% change detection method
    BM=pca_kmeans(cm,cm,3,0.99);

    % SB
%     if(BM(63,271)==1)
%         idx1=find(BM==1);
%         idx2=find(BM==0);
%         BM(idx1)=0;
%         BM(idx2)=1;
%     end

%     % BA
%     if(BM(187,92)==1)
%         idx1=find(BM==1);
%         idx2=find(BM==0);
%         BM(idx1)=0;
%         BM(idx2)=1;
%     end

% %     %% Hm
    if(BM(366,69)==1)
        idx1=find(BM==1);
        idx2=find(BM==0);
        BM(idx1)=0;
        BM(idx2)=1;
    end

%     %% Rv
%     if(BM(44,53)==1)
%         idx1=find(BM==1);
%         idx2=find(BM==0);
%         BM(idx1)=0;
%         BM(idx2)=1;
%     end

    figure;imshow(BM,[]);title('BM');
    [eva,value]=cd_evaluation(BM, gt_trans);
    
    out=[out;value];
    % 保存为PNG（无损格式，推荐单波段图像）
    save_path = 'G:/UF-experiemnt/Result/result-250603-1/compare_methods/StripeCD/Hermiston/';  % 保存路径（可修改）
    % 2. 判断目录是否存在，不存在则创建
    if ~exist(save_dir, 'dir')
        mkdir(save_dir);
    end
    imwrite(BM, [save_path,'result_seed',num2str(i),'.png']);  % 直接保存
end
toc
disp(['运行时间: ',num2str(toc)]);


