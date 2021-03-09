function idx=pickPoint(figure, mesh)

datacursormode on
dcm_obj = datacursormode(figure); 

fprintf(1,'Press any key when you have selected your vertex.\n');
pause;
a = getCursorInfo(dcm_obj);
p = a.Position;

searchResult = (mesh.VERT==repmat(p,size(mesh.VERT,1),1));
searchResult = searchResult(:,1)&searchResult(:,2)&searchResult(:,3);

idx = find(searchResult);
datacursormode off
end