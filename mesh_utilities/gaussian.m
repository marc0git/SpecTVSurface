function g=gaussian(M,pt,v)
%%% define a gaussian on a mesh M, centered at point pt, with variance v
if pt==0
    plot_mesh(M);
    pt=pickPoint(figure(1),M);
    pt
end

pt=M.VERT(pt,:);

p0=sum((pt-M.VERT).^2,2);

%p0=sum(abs(pt-M.VERT),2);
g=exp(-p0./v); %divide by 100 == adjust the variance 

end

