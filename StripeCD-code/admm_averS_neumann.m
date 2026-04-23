function [sol,B,hisfval] = admm_averS_neumann(I,lambda,direction,perc,print) %direction控制是否旋转图像
% F = X + B*E  ( Image = Latent Clean + Stripe, E is row vector with all one, B is stripe location column vector)
% default case: stripe is horizontal

% Solve  min_B \||B||_{1} + lambda*||Grad_{y}*(B*E - F)||_{1}
% by ADMM which is get the saddle point of the ALM (scaled form):
% parameters for the first term:Y,L1/r; for the second term: W, L2/s
% the meaning of the first term 行条带位置约束, the second term 去条带后垂直梯度平滑

% ||Y||_{1} +  r/2*||B - Y + L1/r||_{2}^2
% +...lambda*||W||_{1} + s/2 *||Grad_{y}*(B*E - F) - W + L2/s||_{2}^2

% I: input image (should be a gray-scale/single channel image)
% lambda: regularization parameter
% direction:  0 for horizontal(default), 1 for vertical
% print: wheather plot the results or not, 1 yes ,0 not(default) 

if ~exist('print','var')
    print = 0;
end

% normalization  
MaxPixVal = max(max(I));
I = I/MaxPixVal;

if direction == 1
    I = rot90(I);
end

m0 = size(I,1);  % 超像素个数

% neumann boundary condition
fI = flipud(I);  % 上下翻转矩阵
Rb = ceil(perc*m0);   %perc 固定为1/20  %向上取整ceil
I = [fI(m0-Rb+1:end,:);I;fI(1:Rb,:)];

[m,n] = size(I);

maxiter = 1000;       % the max iteration number
gamma = 1.618;       % the parameter within (0,1.618] used to update lagrangian multiplier 
tol = 1e-5;          % parameter for stopping the ADMM 


r = 10;     % the penalty parameter
s = 10;     % the penalty parameter

% initial value 
B = zeros(m,1);
E = ones(1,n);
F_v =  Grad(I,2); 

L1 = zeros(m,1);
L2 = zeros(m,n);

eigsDytDy = abs(psf2otf([1;-1],[m,1])).^2;  % 竖直梯度且垂直条带(这里可以就用1维的，不用扩展) 
                                            % Grad_{y}*(B*E) = Grad_{y}*(B)*E,谱分解那可直接基于一维做，即用一维傅里叶求解
hisfval = [];
hisffit = [];
hisfreg1 = [];


%% Main loop
rc = tol + 1;    % to make the main loop going on 
iter = 0;        % to count the seps used in the main loop 
while iter<= maxiter %%&& rc >= tol    %&& ovalf <= valf    
    iter = iter+1;
    % ==================
    %   Shrinkage Step
    % ==================
    Y = B + L1/r;                      
    W = Grad(B*E,2) - F_v + L2/s;      
     
    % 范数求解
    Y = max(abs(Y) - 1/r, 0).*sign(Y); 
    W = max(abs(W) - lambda/s, 0).*sign(W);
           
    % ==================
    %     B-subprolem
    % ==================
    
    Bp = B;
    B = r*(Y - L1/r) + s*Dive(F_v + W - L2/s,2)*E';
    B = fft2(B)./(r + s*eigsDytDy*n );
    B = real(ifft2(B)); 
    
    rc = norm(B*E - Bp*E,'fro')/norm((I-B*E),'fro'); 
    [valf,ffit,freg1] = fval(B,E,I,lambda);    %目标函数值

    hisfval = [valf;hisfval];    
    hisffit = [ffit;hisffit];
    hisfreg1 = [freg1;hisfreg1];
    
   

    % ====================================
    %    Update Lagrangian multiplier
    % ====================================
    L1 = L1 + gamma*r*(B - Y);
    L2 = L2 + gamma*s*(Grad(B*E,2) - F_v - W); 
    
    if print 
        figure(1)  
        imshow([I,I-B*E,B*E],[])
        fprintf('Iter: %d, Function value: %4.2e\n,  rc: %4.2e\n',iter,valf,rc);
    end
  
end

sol = I-B*E;
Strp=B*E;
% figure()
% imshow(Strp,[]);title('Strp')
% figure;
% subplot(131);imshow(I,[]);title('DI')
% subplot(132);imshow(Strp,[]);title('Stripe')
% subplot(133);imshow(sol,[]);title('Background')
% neumann boundary condition
sol = sol(Rb+1:Rb+m0,:);
B = B(Rb+1:Rb+m0);

if direction == 1
    sol = rot90(sol,-1);
    B = rot90(B,-1);
end


% normalization 逆向与剪枝
sol(sol(:)<0) = 0;
sol(sol(:)>1) = 1;
sol = sol*MaxPixVal;


%% nested functions

function DX = Grad(X,mode)  % 梯度
    % Forward finite difference operator
    % diff(X,N,DIM) the Nth difference function along dimension DIM.
    if mode == 1
        DX = [diff(X,1,2), X(:,1) - X(:,end)]; % x direction
    else
        DX = [diff(X,1,1); X(1,:) - X(end,:)]; % y direction
    end
end


function DtX = Dive(X,mode)
    % Transpose of the forward finite difference operator
    if mode == 1
        DtX = [X(:,end) - X(:, 1), -diff(X,1,2)]; % x direction
    else
        DtX = [X(end,:) - X(1, :); -diff(X,1,1)]; % y direction
    end
end


function [f,ffit,freg1] = fval(B,E,I,lambda)
    ffit  = abs(B);
    freg1 = abs(Grad(B*E - I,2));  
 
    ffit  =  sum(ffit(:));
    freg1 =  sum(freg1(:));
 
    f = lambda*freg1 + ffit;
end


end