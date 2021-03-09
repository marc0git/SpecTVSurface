function E = edges(F)
  % EDGES Compute the unique undireced edges of a simplicial complex
  % 
  % E = edges(F)
  %
  % Input:
  %  F #F x simplex-size  matrix of indices of simplex corners
  % Output:
  %  E edges in sorted order, direction of each is also sorted
  %
  % Example:
  %   % get unique undirected edges
  %   E = edges(F);
  %   % get unique directed edges
  %   E = [E ; E(:,2) E(:, 1)];
  % 
  % Copyright 2011, Alec Jacobson (jacobson@inf.ethz.ch)
  %

  % all combinations of edges
  n = size(F,2);

  e = nchoosek(1:n,2);
  A = sparse(F(:,e(:,1)),F(:,e(:,2)),1,max(F(:)),max(F(:)));
  [EI,EJ] = find(tril(A+A'));
E = [EJ EI];
end 