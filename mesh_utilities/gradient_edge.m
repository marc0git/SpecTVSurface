
function G=gradient_edge(M)
% computes the edge gradient G for a mesh M
%calc list of edges
M.E=edges(M.TRIV);
E=M.E;
%[VT,~]=edge_triangle_adjacency(M);
%partial=1;

% if partial
%      i=boundary_faces(M.TRIV);
%      [a,id]=ismember(i,M.E,'rows');
%      i(logical(1-a),:)=fliplr(i(logical(1-a),:));
%      assert(sum(ismember(i,M.E,'rows'))==size(i,1))
%      [a,id]=ismember(i,M.E,'rows');
% end

 % build sign matrix
%  J=zeros(size(M.TRIV,1),3);
% for j=1:M.m
%     t=M.TRIV(j,:);
%     e12=t([1 2]);
%     e23=t([2 3]);
%     e31=t([3 1]);
%     idx=ismember([e12;e23;e31],M.E,'rows');
%     idx=double(idx);
%     idx(idx==0)=-1;
%     J(j,:)=idx';
% end

%faster
edges_ordin=[M.TRIV(:,1:2);M.TRIV(:,2:3);M.TRIV(:,[3 1])];
idx=ismember(edges_ordin,M.E,'rows');
idx=double(idx);
 ee=edges_ordin;
ee(logical(1-idx),:)=fliplr( ee(logical(1-idx),:));
 [~,I]=ismember(ee,M.E,'rows');
 
 L=1:M.m;

L=[L';L';L'];
% VTH=VT(I,:);

idx(idx==0)=-1;

J=reshape(idx,[],3);



%edge gradient
 G=sparse(I,L(:),J(:),size(E,1),size(M.TRIV,1));
 
 
end
    
    
 
    