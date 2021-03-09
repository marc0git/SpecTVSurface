function [N,lengths] =compute_normals(M)

edge1=M.VERT(M.TRIV(:,2),:)-M.VERT(M.TRIV(:,1),:);

edge2=M.VERT(M.TRIV(:,3),:)-M.VERT(M.TRIV(:,1),:);

N=cross(edge1,edge2);

lengths=sqrt(sum(N.^2,2));
N=N./lengths;
end