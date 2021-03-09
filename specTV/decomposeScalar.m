

function [sub,phi,tv_score]=decomposeScalar(M,f,alpha,nComp,reductionParam,nonuniform)
%decomposeScalar: apply the spectral TV decomposition to ascalar signal f defined on the vertices of the
%domain M, applying the algorithm 3 in the paper, where:
%-alpha is the maximum time of diffusion
%-nComp is the number fo spectral components to be computed
%-reductionParam is the scale parameter for alpha
%-nonuniform is a binary flag indicating whether alpha is scaled non-uniformily
thresh=1e-4; thsubh2=1e-4;

%% build gradient and divergence operators on surfaces for TV

K=grad(M.VERT,M.TRIV);
D=div(M.VERT,M.TRIV);
eold=inf;

%estimate operator norm to bound the time steps according to \sigma \tau =
%\frac{\min(||e|| e \in edges)}{||K||_op} where ||.||_op is the operator
%norm with \sigma= \tau =1/pt
% we adapt in practice  \sigma \tau=\frac{1}{||K||_op} as it is numerically
% stable and speed up the computation
pt=normest(K);





%% actual decomposition

vt=zeros(M.n,1);
v =zeros(M.n,1) ;
%f=f-mean(f);
%initialize primal signal u as the mean vtor of f
u =ones(size(f,1),1)* mean(f); %scalar
%initialize dual signal q as the vtorial signal of zeros 
q = zeros(size(K,1),1);% scalar

%initialize spectral components
sub=zeros(size(f,1),nComp);
old_R=zeros(size(f,1),nComp);


%maximum number of iterations for the PDHG algorithm
maxiter =3000;


tic



%time=0;


for k=1:nComp
    %rescale the maximum number operation to speed up the algorithm
    maxiter = max(maxiter*0.95,100);
    
    %define the proximal operator F*
    proxFstar =@(data,param)data./max(1,repmat(sqrt((sum(reshape((data.^2),[],3),2))),3,1));%EuclideanL2norm
    %define the proximal operator G
    proxG = @(data,param)L2squaredProx(data, param/alpha, f+v); %u = (data + Param/regu.*f+v)./(1 + Param/regu);
    
    
    
    
    sub(:,k)=u;
    
    %v(:,k)=vt;
    
    %time(k)=1./(alpha);
    %compute the total variation of the solution
    tv_score(k)=sum(total_variation(M,u));
    
    %compute the solution to \min_u TV(u) + 1/(2*alpha) ||u-(f+v)||^2 via
    %the PDHG algorithm
    [u,q, ~,e] =  PDHG_ACC(proxFstar, proxG, K,D, u,q, 0.7/alpha, 1/pt,1/pt,maxiter);
    
    
    alphaOld = alpha;
    
    
    if nonuniform==0
        %scale alpha  for uniform timescale
        alpha = max(alpha -reductionParam,1e-6);
        %vt=v-(v + (f - u))*alpha/alphaOld;%*abs(alpha-alphaOld);
        v = (v + (f - u))*alpha/alphaOld;%*abs(alpha-alphaOld);
        
    else
        %scale alpha for a non uniform (fewer componenets needed for non
        %trivial functions)
        alpha = alpha *reductionParam;
        
        v = (v + (f - u))* alpha/alphaOld;
        
        %vt=v-(f - u)*alpha/alphaOld;
    end
    
    %different termination criteria
    %based on error of the solution
     %if abs(e-eold)<thresh
    %break
    % end
    %based on convergence to the solution
    %if abs(u-f)<thresh
    %break
    % end
    eold=e;
    
end
toc

phi=sub;



%compute derivatives
for i=2:size(sub,2)
    phi(:,i)=(phi(:,i)-sub(:,i-1));
end

phi=phi(:,1:k);
sub=sub(:,1:k);




