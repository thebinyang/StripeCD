function [ out_img ] = getPCA(T1)
im_size = size(T1);
N = im_size(1) * im_size(2);
X = reshape(T1,N,[]);
[COEFF,SCORE,latent,tsquare] = pca(zscore(X));
Y=SCORE(:,1:3);
Y = reshape(Y,[im_size(1) im_size(2) 3]);
minA=min(min(min(Y)));maxA=max(max(max(Y)));  
out_img = uint8((Y-minA) * 255 / (maxA-minA));
end