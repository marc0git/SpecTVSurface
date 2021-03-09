
function g_tot= draw_shape(M,n)



M.VERT=M.VERT-mean(M.VERT);
g_tot=zeros(M.n,1);







for i=1:n
    clear h dd k  
%plot_mesh_tri(M,M.VC/255)

plot_mesh(M); colormap(white);
h=images.roi.Freehand(gca);
h.draw
h.Waypoints=logical(ones(size(h.Waypoints,1),1));

dd=h.get.Position;


ax=gca;
[az,el] = view(ax);

V=M.VERT;
% rotate by 90 degrees
Rx90 = [1 0 0; 0 cos(-pi/2) -sin(-pi/2);0 sin(-pi/2) cos(-pi/2)];
% rotatation according to elevation from view of t
Rx = [1 0 0; 0 cos(el*pi/180) -sin(el*pi/180);0 sin(el*pi/180) cos(el*pi/180)];
% rotation according to azimuth of view of t
Rz = [cos(-az*pi/180) -sin(-az*pi/180) 0; sin(-az*pi/180) cos(-az*pi/180) 0;0 0 1];
% rotation matrix that will rotate mesh to
R = (Rx90*Rx*Rz);
R = R(1:2,:);
view_V = [V] * R';
% use zero for z values
view_V(:,3) = 0;
g=1.0*inpolygon(view_V(:,1),view_V(:,2),dd(:,1),dd(:,2));


A=adjacency_mat(M);
A(find(1-g),:)=0;
plot_mesh(M);
g=n_power(A,delta(M,pickPoint(gcf,M)),100);
g=double(g>0);


cc=[1 1 1 ; 1 0 0];

plot_mesh(M,g);colormap(cc)
drawnow

g_tot=g_tot+ g;
plot_mesh(M,g_tot);colormap(cc);

end

function [f]=n_power(A,f,k)
for jj=1:k
    f=A*f;
end
end
function [d]=delta(M,k)
d=zeros(M.n,1);
d(k)=1;
end



end