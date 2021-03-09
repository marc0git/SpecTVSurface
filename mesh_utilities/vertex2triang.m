function centr = vertex2triang(M,f)
tri=M.TRIV;
%A=calc_tri_areas(M);
%AA=lumpedAreas(M);
centr=(f(tri(:,1),:)+f(tri(:,2),:)+f(tri(:,3),:))/3;


end
