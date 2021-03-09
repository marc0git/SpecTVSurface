function u=L2squaredProx(proxArgument, proxParam, f)
u = (proxArgument + proxParam*f)./(1 + proxParam);
end


