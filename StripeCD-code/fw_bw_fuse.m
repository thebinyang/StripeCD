function fusedimage=fw_bw_fuse(forward, backward)

%% Method 1: Using the Maximum
fusedimage=zeros(size(forward));
dif=forward-backward;
idx1=find(dif>=0);
fusedimage(idx1)=forward(idx1);
idx2=find(dif<0);
fusedimage(idx2)=backward(idx2);

%% Method 2: Using the Mean
% fusedimage=0.5*(forward+backward);
end