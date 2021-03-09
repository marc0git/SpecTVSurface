%TV Decomposition of a scalar signal minimal example (replicate example in figure 4 of the paper)

clear ; clc; close all
addpath(genpath('./'))

%% load data
path="./DATA/bob.off";
M=load_off(path);
%% build the scalar signal as a sum of 3 gaussian centered at different points, with different variance

g=gaussian_indicator(M,3605,0.03);
g=g+gaussian_indicator(M,224,0.007);
g=g+gaussian_indicator(M,4478,0.001);


plot_mesh(M,g)

%% set the hyperparameters for the decomposition
%alpha corresponds to the maximum diffusion time
alpha=1;
%Ncomp is the number of spectral components to be computed
Ncomp=50;
%nonuniform: binary flag indicating whether alpha is scaled uniformly 
nonuniform=0;
%regFact: is the scale factor for alpha
if nonuniform
    %alpha is updated as \alpha_{t+1}=reg_fact*\alpha_t
    regFact=0.96;
else
    %alpha is updated as \alpha_{t+1}=\alpha_t -reg_fact*\alpha
    regFact=1/100;
end
%% compute the time scale
tt=timescale_iss(alpha,regFact,Ncomp,nonuniform);
%tt= fliplr(1./tt);%corresponds to the correct time scale on the x-axis according to the computation of the backward flow (see in the appendix)
%% compute the spectral decomposition

[M.sub,M.phi,tv_score]=decomposeScalar(M,g,alpha,Ncomp,regFact,nonuniform);


%% comparison with the forward flow
%[M.sub,~,M.phi,M.res]=forwardFlow(M,g,0.01,comp);

%% compute the tv spectrum
close all
M.A=lumpedAreas(M);

S=(sum(abs(M.A*M.phi)));

%% plot the TV spectrum (time vs spectral amplitude) and the TV energy
%
subplot(121)
plot(tt,S)
xlabel("$t$","Interpreter","latex")
ylabel("$S(t)$","Interpreter","latex")
title("TV spectrum")


subplot(122)
plot(tt,tv_score)
xlabel("$t$","Interpreter","latex")
ylabel("$TV(u(t))$","Interpreter","latex")
title("TV energy")
set(gcf, 'Color', 'w');

%%
ff=figure('OuterPosition',[1 1 1000 1000]);
cam=[0 90];
set(gcf, 'Color', 'w');

for i=1:size(M.phi,2)%:-1:1
    
    
    subplot(221)
    
    p=plot_mesh(M,sum(M.phi(:,1:i),2));render_options(p);%caxis([0,max(g)]);view(cam);  shading interp; camlight;lighting gouraud;render_options(p);%rotate(p,[0 1 0],-20);%p.SpecularExponent=100;p.SpecularStrength=1;p.DiffuseStrength=0.8;
    title("$\int_M \phi(t) dt$","Interpreter","latex")
    subplot(222)
    %show single components
    p=plot_mesh(M,(M.phi(:,i)));render_options(p);colorbar;
    
    title("$ \phi(t)$","Interpreter","latex")
    
    subplot(2,2,[3 4])
    plot(S)
    hold on
    plot(S(1:i),'r','LineWidth',1)
    xlabel('t')
    ylabel('S(t)')
    hold off
    
    
    %pause(0.2)
    drawnow;
end


%% select the peaks
%either by applying a manual bandpass filter to the spectrum
%e.g.
%h1=Pfilter(S,0,'band');
%h2=Pfilter(S,0,'band');
%h3=Pfilter(S,0,'band');
% or by using an automatic heuristic to find all the peaks above a certain
% treshold and select all the values in the peak until the monotonically
% decrease/increase
%e.g.
% idxs=findpeaks(S);
% 
% h1=zeros(1,size(S,2));
% h2=zeros(1,size(S,2));
% h3=zeros(1,size(S,2));
% h1(idxs{1})=1;
% h2(idxs{2})=1;
% h3(idxs{3})=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%
%the masks for this particular example are precomputed
h1=zeros(1,size(S,2));
h2=zeros(1,size(S,2));
h3=zeros(1,size(S,2));
h1(8)=1;
h2(13)=1;
h3(24)=1;


%% plot the results (akin to figure 4 in the paper)

%create a  simple colormap
a=[ 255,166,0;0 110 180];
a=a/255.;
jmax=5;
cmap=zeros(jmax,3);
cmap(1,:)=a(1,:);
for i=2:jmax
    cmap(i,:)=a(2,:);
end

figure(6)
subplot(2,4,[1,2])

p=plot_mesh(M,sum(M.phi,2));caxis([0.2,max(g)]);render_options(p)
subplot(2,4,[3,4]);
plot(linspace(0,2,size(S,2)),S,'LineWidth',1)
figure(4)
subplot(2,4,6)
p=plot_mesh(M,sum(h1.*M.phi,2));caxis([0.2,max(g)]);render_options(p)
subplot(2,4,7)
p=plot_mesh(M,sum(h2.*M.phi,2));caxis([0.2,max(g)]);render_options(p)

subplot(2,4,8)
p=plot_mesh(M,sum(h3.*M.phi,2));caxis([0.2,max(g)]);render_options(p)

%colormap(cmap)


figure(5)
subplot(2,4,6)
plot(linspace(0,2,size(S,2)),h1.*S,'r','LineWidth',1); ylim([0 max(S)]);
subplot(2,4,7);
plot(linspace(0,2,size(S,2)),h2.*S,'r','LineWidth',1);ylim([0 max(S)]);
subplot(2,4,8)
plot(linspace(0,2,size(S,2)),h3.*S,'r','LineWidth',1);ylim([0 max(S)]);

for i=[6,7,8]
    figure(4)
    subplot(2,4,i)
    a1=gca;
    figure(5)
    subplot(2,4,i)
    a2=gca;
    inset(a1,a2,figure(6),0.09);
end
set(gcf, 'Color', 'w');
close("5")
close("4")
colormap(cmap)


