function S_tri = calc_tri_areas(M)



N = cross(M.VERT(M.TRIV(:,1),:)-M.VERT(M.TRIV(:,2),:), M.VERT(M.TRIV(:,1),:) - M.VERT(M.TRIV(:,3),:));
S_tri = 1/2*normv(N);
% S_tri=spdiag(S_tri);
% S_tri = zeros(size(M.TRIV,1),1);
% % 
% for k=1:size(M.TRIV,1)
%     e1 = M.VERT(M.TRIV(k,3),:) - M.VERT(M.TRIV(k,1),:);
%     e2 = M.VERT(M.TRIV(k,2),:) - M.VERT(M.TRIV(k,1),:);
%     S_tri(k) = 0.5*norm(cross(e1,e2));
% end

end
