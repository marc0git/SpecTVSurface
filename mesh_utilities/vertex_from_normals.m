
function [V]=vertex_from_normals(M,n)
%vertex_from_normals solves the screened poisson equation, on the domain M, associated to the minimization problem: \min_V  ||\nabla V - W ||_2^2 +eps||V-V0||_2^2 computing new vertices  coordinates according to the vector field W obtained from the normal vector field n, solving a
%screened poisson equation, according to M.Kazhdhan, H.Hoppe "Screened
%Poisson Surface Reconstruction"
tic
eps=1e-10;
n=n./normv(n);
G=grad(M.VERT,M.TRIV);
D=div(M.VERT,M.TRIV);
M.A=lumpedAreas(M);
D=M.A*D;

vv=G*M.VERT;

[M.S,~,M.A]=calc_LB_FEM(M);

if size(n,1)>M.m
    w=vv-sum(vv.*n,2).*n;
    eps
    
else
    vv=reshape(vv,[],3,3);
    for i=1:3
        w(:,i,:)= squeeze(vv(:,i,:))-sum(squeeze(vv(:,i,:)).*n,2).*n;
    end
end

V=zeros(M.n,3);
w=reshape(w,[],3);

s=sparse(eps*M.A*M.VERT+D*reshape(w,[],3));


V= (eps*M.A*speye(M.n)-M.S)\(s);

%center the result (removes additionally degre of freedom from the
%solution)
V = V - mean(V);

toc
end









