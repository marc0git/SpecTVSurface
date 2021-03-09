function g= gaussian_indicator(M,pt,var)
g=gaussian(M,pt,var);
%g=double(g>0.5);
g=double(g>mean(g));
%plot_mesh(M,g)
end