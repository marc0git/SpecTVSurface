% SPECTRAL TV DECOMPOSITION
clear ; clc ; close all
addpath(genpath('./'))
%% load data
path="./DATA/garg.off";
M=load_off(path);
% center and scale mesh

M.VERT = M.VERT - mean(M.VERT);
M.VERT = M.VERT./max(std(M.VERT));


%compute the normal vector field of M
u0 = compute_normals(M);




%% set the hyperparameters for the decomposition
%alpha corresponds to the maximum diffusion time
alpha=100;
%Ncomp is the number of spectral compnonuniformnts to be computed
Ncomp=40;
%nonuniform: binary flag indicating whether alpha is scaled uniformly 
nonuniform=1;
%regFact: is the scale factor for alpha
if nonuniform
    %alpha is updated as \alpha_{t+1}=reg_fact*\alpha_t
    regFact=0.8;
else
    %alpha is updated as \alpha_{t+1}=\alpha_t -reg_fact*\alpha
    regFact=1/100;
end





tt=timescale_iss(alpha,regFact,Ncomp,nonuniform);

[M.sub,M.phi]=decomposeNormals(M,u0,alpha,Ncomp,regFact,nonuniform,1);






%% compute and plot the TV spectrum
M.A=diag(calc_tri_areas(M));

S=(sum(abs(diag(M.A).*normv(M.phi))));
S=squeeze(S)';

figure
j=plot(S);
xlabel("$t$","Interpreter","latex")
ylabel("$S(t)$","Interpreter","latex")
title("TV spectrum")
%% starts the interactive GUI according to the computed decomposition
M.f=u0;
S(1)=1e-5;
start_gui(S,M)

