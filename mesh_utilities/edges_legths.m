function L=edges_legths(M)
%computes the edges lengths of M
E = edges(M.TRIV);

V=M.VERT;
L=normv(V(E(:,2),:)- V(E(:,1),:));

end