function cmp=extract_cmp(prechange,postchange,gt,ori_pre,ori_post,i)
[m,n,c]=size(prechange);
dif=abs(prechange-postchange);
aa=dif(:,:,1);
imshow(aa)
for band = 1:c
    % 获取当前波段
    current_band = dif(:, :, band);
    
    % 生成文件名
    filename = sprintf(strcat('G:\\LRCD\\LR\\Fig_results-0504\\seldifmatlab\\', 'band_', num2str(band), '.tif'));
    
    % 保存图片，使用 tif 格式支持无损保存
    imwrite(current_band, filename);
end

imt = cat(3, ori_pre, ori_pre); 
pcat=getPCA(imt);
[T_L1,T_N1] = slicmex(pcat,1000,10 );
% dif=(dif-mean(dif, [1 2]))./(std(dif,0, [1 2]));
% dif_std=std(dif,0,[1,2]);

%extract the first three components
T1=getPCA(ori_pre);
T2=getPCA(ori_post);
gT1=T1;
gT2=T2;

% % save(strcat('G:\LRCD\LR-python\mat-pca\SB_T1_s',num2str(i),'.mat'), 'T1');
% % save(strcat('G:\LRCD\LR-python\mat-pca\SB_T2_s',num2str(i),'.mat'), 'T2');
% 
% % SLIC super pixel generation
[T12_L1,T12_N1] = slicmex(T1,1000,10 );
[T21_L1,T21_N1] = slicmex(T2,1000,10);
[T12_L2,T12_N2] = slicmex(T1,1500,10);
[T21_L2,T21_N2] = slicmex(T2,1500,10);
[T12_L3,T12_N3] = slicmex(T1,2000,10);
[T21_L3,T21_N3] = slicmex(T2,2000,10);
[T12_L4,T12_N4] = slicmex(T1,2500,10);
[T21_L4,T21_N4] = slicmex(T2,2500,10);
[T12_L5,T12_N5] = slicmex(T1,3000,10);
[T21_L5,T21_N5] = slicmex(T2,3000,10);
% % % [T12_L6,T12_N6] = slicmex(T1,3500,10);
% % % [T21_L6,T21_N6] = slicmex(T2,3500,10);
% % % [T12_L7,T12_N7] = slicmex(T1,4000,10);
% % % [T21_L7,T21_N7] = slicmex(T2,4000,10);
% BW = boundarymask(T12_L1);
% A = ones(size(BW));
% figure;imshow(imoverlay(A,BW,'red'),'border','tight');
% BW = boundarymask(T21_L1);
% A = ones(size(BW));
% figure;imshow(imoverlay(A,BW,'red'),'border','tight');
BW = boundarymask(T_L1);
A = ones(size(BW));
% figure;imshow(imoverlay(A,BW,'red'),'border','tight');

% save('J:\experiment\VSwin\pyproject\DeepUnfolding\Saha_NoEdge\Datalist\slicseg\hersegcat1000.mat', 'T_L1');
% save('J:\experiment\VSwin\pyproject\DeepUnfolding\Saha_NoEdge\Datalist\slicseg\hersegpre1000.mat', 'T12_L1');
% save('J:\experiment\VSwin\pyproject\DeepUnfolding\Saha_NoEdge\Datalist\slicseg\hersegpost1000.mat', 'T21_L1');
% % % % difb1 = dif(:,:,1);
% % figure;imshow(imoverlay(dif(:,:,1),BW,'red'),'border','tight');
% % BW = boundarymask(T21_L1);
% % figure;imshow(imoverlay(A,BW,'blue'),'border','tight');
% % figure;imshow(imoverlay(dif(:,:,1),BW,'blue'),'border','tight');
% % figure;imshow(dif(:,:,1),'border','tight');
% % figure;imshow(prechange(:,:,1),'border','tight');
% % BW = boundarymask(gt);
% % for s=1000:500:3000
% %     k=1;
% %     data1=load(strcat('G:\LRCD\LR-python\mat-pca\seg\LSC\BA_T1_s',num2str(i),'_LSC_seg',num2str(s),'.mat'));
% %     T12_L1 = int32(data1.T1seg);
% %     T12_N1 = unique(T12_L1); 
% % end
% %%%%%%%%%%%%% other segmentations
% scene = 'HE';
% segmethod = 'LSNET';
% data1_L1=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T1_s',num2str(i),'_',segmethod,'_seg',num2str(1000),'.mat'));
% T12_L1 = int32(data1_L1.T1seg);
% T12_N1 = length(unique(T12_L1)); 
% data2_L1=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T2_s',num2str(i),'_',segmethod,'_seg',num2str(1000),'.mat'));
% T21_L1 = int32(data2_L1.T2seg);
% T21_N1 = length(unique(T21_L1)); 
% 
% data1_L2=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T1_s',num2str(i),'_',segmethod,'_seg',num2str(1500),'.mat'));
% T12_L2 = int32(data1_L2.T1seg);
% T12_N2 = length(unique(T12_L2)); 
% data2_L2=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T2_s',num2str(i),'_',segmethod,'_seg',num2str(1500),'.mat'));
% T21_L2 = int32(data2_L2.T2seg);
% T21_N2 = length(unique(T21_L2)); 
% 
% data1_L3=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T1_s',num2str(i),'_',segmethod,'_seg',num2str(2000),'.mat'));
% T12_L3 = int32(data1_L3.T1seg);
% T12_N3 = length(unique(T12_L3)); 
% data2_L3=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T2_s',num2str(i),'_',segmethod,'_seg',num2str(2000),'.mat'));
% T21_L3 = int32(data2_L3.T2seg);
% T21_N3 = length(unique(T21_L3)); 
% 
% data1_L4=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T1_s',num2str(i),'_',segmethod,'_seg',num2str(2500),'.mat'));
% T12_L4 = int32(data1_L4.T1seg);
% T12_N4 = length(unique(T12_L4)); 
% data2_L4=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T2_s',num2str(i),'_',segmethod,'_seg',num2str(2500),'.mat'));
% T21_L4 = int32(data2_L4.T2seg);
% T21_N4 = length(unique(T21_L4)); 
% 
% data1_L5=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T1_s',num2str(i),'_',segmethod,'_seg',num2str(3000),'.mat'));
% T12_L5 = int32(data1_L5.T1seg);
% T12_N5 = length(unique(T12_L5)); 
% data2_L5=load(strcat('G:\LRCD\LR-python\mat-pca\seg-0504\',segmethod,'\',scene,'_T2_s',num2str(i),'_',segmethod,'_seg',num2str(3000),'.mat'));
% T21_L5 = int32(data2_L5.T2seg);
% T21_N5 = length(unique(T21_L5)); 

%forward
slic_S_1_f = getLR(dif,c,T12_L1,T12_N1);    % c为通道数量 T12_L1为根据T1时相的尺度1分割结果， T12_N1为超像素个数
slic_S_2_f = getLR(dif,c,T12_L2,T12_N2);
slic_S_3_f = getLR(dif,c,T12_L3,T12_N3);
slic_S_4_f = getLR(dif,c,T12_L4,T12_N4);
slic_S_5_f = getLR(dif,c,T12_L5,T12_N5);
% slic_S_6_f = getLR(dif,c,T12_L6,T12_N6);
% slic_S_7_f = getLR(dif,c,T12_L7,T12_N7);
% cmp_f=cat(3, slic_S_1_f,slic_S_2_f,slic_S_3_f);
% figure;imshow(imoverlay(slic_S_1_f/max(slic_S_1_f(:)),BW,'red'),[]);title('SLIC-1-forward');
% slic_S_1_f=imguidedfilter(slic_S_1_f,gT1);
% slic_S_2_f=imguidedfilter(slic_S_2_f,gT1);
% slic_S_3_f=imguidedfilter(slic_S_3_f,gT1);
% slic_S_4_f=imguidedfilter(slic_S_4_f,gT1);
% slic_S_5_f=imguidedfilter(slic_S_5_f,gT1);

%backward
slic_S_1_b = getLR(dif,c,T21_L1,T21_N1);  % c为通道数量 T21_L1为根据T2时相的尺度1分割结果， T21_N1为超像素个数
slic_S_2_b = getLR(dif,c,T21_L2,T21_N2);
slic_S_3_b = getLR(dif,c,T21_L3,T21_N3);
slic_S_4_b = getLR(dif,c,T21_L4,T21_N4);
slic_S_5_b = getLR(dif,c,T21_L5,T21_N5);
% slic_S_6_b = getLR(dif,c,T21_L6,T21_N6);
% slic_S_7_b = getLR(dif,c,T21_L7,T21_N7);
% cmp_b=cat(3,slic_S_1_b,slic_S_2_b,slic_S_3_b);
% figure;imshow(imoverlay(slic_S_1_b/max(slic_S_1_b(:)),BW,'red'));title('SLIC-1-backward');
% slic_S_1_b=imguidedfilter(slic_S_1_b,gT2);
% slic_S_2_b=imguidedfilter(slic_S_2_b,gT2);
% slic_S_3_b=imguidedfilter(slic_S_3_b,gT2);
% slic_S_4_b=imguidedfilter(slic_S_4_b,gT2);
% slic_S_5_b=imguidedfilter(slic_S_5_b,gT2);


%前后向融合都使用
slic_S_1=fw_bw_fuse(slic_S_1_f,slic_S_1_b);
slic_S_2=fw_bw_fuse(slic_S_2_f,slic_S_2_b);
slic_S_3=fw_bw_fuse(slic_S_3_f,slic_S_3_b);
slic_S_4=fw_bw_fuse(slic_S_4_f,slic_S_4_b);
slic_S_5=fw_bw_fuse(slic_S_5_f,slic_S_5_b);
% slic_S_6=fw_bw_fuse(slic_S_6_f,slic_S_6_b);
% slic_S_7=fw_bw_fuse(slic_S_7_f,slic_S_7_b);
%只使用前向策略
% slic_S_1=fw_bw_fuse(slic_S_1_f,slic_S_1_f);
% slic_S_2=fw_bw_fuse(slic_S_2_f,slic_S_2_f);
% slic_S_3=fw_bw_fuse(slic_S_3_f,slic_S_3_f);
% slic_S_4=fw_bw_fuse(slic_S_4_f,slic_S_4_f);
% slic_S_5=fw_bw_fuse(slic_S_5_f,slic_S_5_f);
%只使用后向策略
% slic_S_1=fw_bw_fuse(slic_S_1_b,slic_S_1_b);
% slic_S_2=fw_bw_fuse(slic_S_2_b,slic_S_2_b);
% slic_S_3=fw_bw_fuse(slic_S_3_b,slic_S_3_b);
% slic_S_4=fw_bw_fuse(slic_S_4_b,slic_S_4_b);
% slic_S_5=fw_bw_fuse(slic_S_5_b,slic_S_5_b);

slic_S_1=(slic_S_1-mean(slic_S_1,'all'))/std(slic_S_1,0,'all');
slic_S_2=(slic_S_2-mean(slic_S_2,'all'))/std(slic_S_2,0,'all');
slic_S_3=(slic_S_3-mean(slic_S_3,'all'))/std(slic_S_3,0,'all');
slic_S_4=(slic_S_4-mean(slic_S_4,'all'))/std(slic_S_4,0,'all');
slic_S_5=(slic_S_5-mean(slic_S_5,'all'))/std(slic_S_5,0,'all');
% slic_S_6=(slic_S_6-mean(slic_S_6,'all'))/std(slic_S_6,0,'all');
% slic_S_7=(slic_S_7-mean(slic_S_7,'all'))/std(slic_S_7,0,'all');
% cmp=cat(3,slic_S_1,slic_S_1);
% cmp=cat(3,slic_S_1,slic_S_2);
% cmp=cat(3,slic_S_1,slic_S_2,slic_S_3);
% cmp=cat(3,slic_S_1,slic_S_2,slic_S_3,slic_S_4);
cmp=cat(3,slic_S_1,slic_S_2,slic_S_3,slic_S_4,slic_S_5);
% cmp=cat(3,slic_S_1,slic_S_2,slic_S_3,slic_S_4,slic_S_5,slic_S_6);
% cmp=cat(3,slic_S_1,slic_S_2,slic_S_3,slic_S_4,slic_S_5,slic_S_6,slic_S_7);
end