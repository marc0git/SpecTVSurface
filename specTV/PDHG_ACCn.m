
function [u, q,i,e] = PDHG_ACCn(proxFstar, proxG, K,D, u,q, gamma,sigma,tau,maxiter)
%PDHG_ACC_n: implements the accelerated version of the Primal Dual Hybird
%Gradient of: A.Chambolle, T.Pock "A first-order primal-dual algorithm for convex problemswith applications to imaging" (https://hal.archives-ouvertes.fr/hal-00490826/document)
% this version iteratively projects the primal signal u on the unit
% sphere,as it is implemented to work for normal vector field signals.

i=1;
err = inf;
u_bar = u;
errThresh=1e-3;
%theta=1;


uold = u;
while (i<maxiter)&&(err>errThresh)
    
    %update primal and dual variables
    
    q = proxFstar(q +sigma.*(K*u_bar), sigma);
    
    %size(u)
    uold=u;
    u = proxG(u+tau.*((D)*q), tau);
    
    %     %primal residual
    %     p=abs((uold-u)/tau-D*(qold-q));
    %     %dual residual
    %     d=abs((qold-q)/sigma-K*(uold-u));
    %     P(i)=sum(p);
    %     Dd(i)=sum(d);
    u = u./normv(u);
    
    %adapt parameters
    theta = 1/sqrt(1+2*gamma*tau);
    tau = theta*tau;
    sigma = sigma/theta;
    
    %extrapolate
    u_bar = u + theta*(u-uold);
    u_bar=u_bar./normv(u_bar);
    
    
    
    
    err=norm(u-uold);
    e=err;
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

