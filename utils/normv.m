function nn = normv(V,varargin)
if size(varargin,1)>0
    if varargin{1}==1
    nn = sqrt(sum(reshape(V.^2,[],3),2));
    else
        nn = sqrt(sum(reshape(V.^2,[],2),2));
    end
else
nn = sqrt(sum(V.^2,2));
end