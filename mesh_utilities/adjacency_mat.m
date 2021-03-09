function [Ad,E] = adjacency_mat(M)
n=size(M.VERT,1);
T=M.TRIV;
I = [T(:,1);T(:,2);T(:,3)];
J = [T(:,2);T(:,3);T(:,1)];
Ad=sparse(I,J,1,n,n);
E=[I,J];
end


