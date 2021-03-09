
function [sub,phi]= decomposeNormals(M,f,alpha,nComp,reductionParam,nonuniform,g)
%decomposeNormals: apply the spectral TV decomposition to a normal vector field f, defined on the triangles of the
%domain M, applying the algorithm 3 in the paper, where:
%-alpha is the maximum time of diffusion
%-nComp is the number fo spectral components to be computed
%-reductionParam is the scale parameter for alpha
%-nonuniform is a binary flag indicating whether alpha is scaled non-uniformily

%% build the edge gradient and divergence operators on surfaces for TV
K=gradient_edge(M);
A=edges_legths(M);
%AA=spdiag(1./calc_tri_areas(M));
D=-K'*spdiag(A);

%estimate operator norm to bound the time steps according to \sigma \tau =
%\frac{\min(||e|| e \in edges)}{||K||_op} where ||.||_op is the operator
%norm with \sigma= \tau =1/pt
% we adapt in practice  \sigma \tau=\frac{1}{||K||_op} as it is numerically
% stable and speed up the computation

pt=max(normest(K));

%threshold for different termination criteria(not active by default)
thresh=1e-4;
%% actual decomposition

%initialize primal and dual vector/tensor fields
u=f;
sub=zeros(size(f,1),3,nComp);
q = zeros(size(K,1),3);% vectorial


v=0;

%maximum number of iterations for the PDHG algorithm
iter=1000;

disp("Start the spectral decomposition")
tic
for k=1:nComp
    %rescale the maximum number operation to speed up the algorithm
    iter = max(iter*0.95,100);
    
    %define the proximal operator F*
    proxFstar= @(data,param)data./max(1,sqrt(sum((data.^2).*A,2)));

    sub(:,:,k)=u;
    
    
    %define the proximal operator G
    if (isscalar(g))
        %standard proximal operator 
        proxG= @(data,param)L2squaredProx(data, param/alpha, (f+v));
    else
        %proximal operator with local support based on g
        proxG = @(data,param)L2squaredProxMasked(data, param/alpha, f+v,f,g); %gu = (data + Param/regu.*f+v)./(1 + Param/regu);
    end
    
    %compute the solution to \min_u TV(u) + 1/(2*alpha) ||u-(f+v)||^2 via
    %the PDHG algorithm
    [u,q, ~,e] =  PDHG_ACCn(proxFstar, proxG, K,D, u,q, 1,1/pt,1/pt, iter);
    
    
    repParamOld = alpha;
    if nonuniform==0
        %scale alpha  for uniform timescale
        alpha = max(alpha -reductionParam,1e-5);
        
    else
        %scale alpha for a non uniform (fewer componenets needed for non
        %trivial functions)
        alpha = alpha *reductionParam;
    end
    
    v = (v + (f - u))*alpha/repParamOld;

    
    
     %different termination criteria
    %based on error of the solution
     %if abs(e-eold)<thresh
    %break
    % end
    %based on convergence to the solution
    %if abs(u-f)<thresh
    %break
    
    eold=e;
    
end
toc

phi=sub;


%compute derivatives

for i=2:size(phi,3)
    phi(:,:,i)=phi(:,:,i)-sub(:,:,i-1);
end
phi=phi(:,:,1:k);
sub=sub(:,:,1:k);

disp("Ended succesfully")
end




