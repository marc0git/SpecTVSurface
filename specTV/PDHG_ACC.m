
function [u, q,i,e] = PDHG_ACC(proxFstar, proxG, K,D, u,q, gamma,sigma,tau,maxiter)
%PDHG_ACC: implements the accelerated version of the Primal Dual Hybird
%Gradient of: A.Chambolle, T.Pock "A first-order primal-dual algorithm for convex problemswith applications to imaging" (https://hal.archives-ouvertes.fr/hal-00490826/document)
i=1;
err = inf;
u_bar = u;
errThresh=1e-5;
%theta=1;

uold = u;
while (i<maxiter)&&(err>errThresh)
    
    %update primal and dual variables
    qold=q;
    q = proxFstar(q +sigma.*(K*u_bar), sigma);
    
    %size(u)
    uold=u;
    u = proxG(u+tau.*((D)*q), tau);
    
    %primal residual
    % primal=abs((uold-u)/tau+D*(qold-q));
    %  primal=sum(primal)
    %     %dual residual
    % dual=abs((qold-q)/sigma-K*(uold-u));
    % dual=sum(dual)
    %  P(i)=sum(sum(primal));
    %  Dd(i)=sum(sum(dual));
    
    
    
    theta = 1/sqrt(1+2*gamma*tau);
    tau = theta*tau;
    sigma = sigma/theta;
    
    %extrapolate
    u_bar = u + theta*(u-uold);
    
    err=norm(u-uold);
    
    i=i+1;
    
    if mod(i,30)==0
        uold = u;
        
    end
    
end
disp("N_iters:")
disp(i)
disp("err")
disp(err)
disp("norm_u")
disp(norm(u))
e=norm(u);


