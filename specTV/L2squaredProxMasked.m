function u=L2squaredProxMasked(proxArgument, proxParam, f, g,mask)
u = (proxArgument + proxParam.*f)./(1 + proxParam);
u(mask,:)=g(mask,:);
end