function [ slic_S_value ] = getLR( DI,F_count,slic_L,slic_N)    % F_count为特征通道数量 slic_L,为时相分割结果， slic_N为超像素个数
DI_Reshape = reshape(DI,[],F_count);
SLIC_Feature_Map = zeros(slic_N,F_count);

%% combinde matrix 行为超像素个数，列为特征通道数
for i = 1:slic_N
    block_index = find(slic_L == i - 1);
    f = DI_Reshape(block_index,:);
    f = mean(f);
    SLIC_Feature_Map(i,:) = f;

%% modified by BY 2022/09/30
%     s =std( DI_Reshape(block_index,:),0,1);
%     SLIC_Feature_Map(i,:)=f./s;
end

% lamda = double(slic_N)^(-1/2);
% lamda = 0.03; %for SB
% lamda = 0.007; %for BA
% % lamda = 0.03; %for He
% % % [L,S,Y] = singular_value_rpca(SLIC_Feature_Map,lamda);
% opts.loss = 'l1'; 
% % opts.DEBUG = 1;
% [L,S,obj,err,iter] = rpca(SLIC_Feature_Map,lamda,opts);

%% test added by BY
% slic_S = zeros(size(slic_L));
% slic_S_t=zeros(size(DI));
% for j=1:F_count
%     for i=1:slic_N
%         block_idx=find(slic_L == i-1);
%         slic_S(block_idx)=S(i,j);        
%     end
%     slic_S_t(:,:,j)=slic_S;
% end
%% %%%%%%%%%%%%%

% New method based on LXX
direction = 0;    % 0 for horizontal(default), 1 for vertical  0为水平，1为垂直方向
lambda = 50;       % 抹条带强度
perc = 1/20;
print = 0;        % 显示中间结果
[background,meanChange] = admm_averS_neumann(SLIC_Feature_Map,lambda,direction,perc,print);
L=SLIC_Feature_Map-background;
L=L-min(min(L));
% L(L<0)=0;
% L=abs(L);
%% %%%%%%%%%%%%%%%%

S_norm_1 = zeros(slic_N,1);
for i = 1:slic_N
    S_norm_1(i) = norm(L(i,:),1);  % 1范数：为所有元素绝对值之和，即sum(abs(A))
end
% S_norm_1=(S_norm_1-min(S_norm_1(:)))/(max(S_norm_1(:))-min(S_norm_1(:)));
% S_norm_1=sum(L,2);
% S_norm_1=max(L,[],2);

%figure,imshow([SLIC_Feature_Map background L],[])

[v,index] = sort(S_norm_1,'descend');

percent = 5;
vU = prctile(v,100-percent);
vD = prctile(v,percent);

v(v(:)>vU) = vU;
v(v(:)<vD) = vD;

slic_S = zeros(size(slic_L));
slic_S_value = zeros(size(slic_L));
for i = 1:slic_N
    block_index = find(slic_L == (index(i) - 1));
    slic_S(block_index) = slic_N - i;
    slic_S_value(block_index) = v(i);
end
end