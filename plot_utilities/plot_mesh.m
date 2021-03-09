function [p]= plot_mesh(M,varargin)
%bwr=load('bluewhitered.mat');
%bwr=bwr.bluewhitered;
m=0;
if size(varargin)>0
    C=cell2mat(varargin(1));

    if size(M)==[1,1]
        p=trisurf(M.TRIV,M.VERT(:,1),M.VERT(:,2),M.VERT(:,3),C,varargin{2:end});
        m=max(abs(C));
    else
    

        p=scatter3(M(:,1),M(:,2),M(:,3),'.','CData',C);

    end
else if size(M)==[1,1]
        p=trisurf(M.TRIV,M.VERT(:,1),M.VERT(:,2),M.VERT(:,3));%varargin{2:end});
    else
    

        p=scatter3(M(:,1),M(:,2),M(:,3),'.',varargin{2:end});

    end
end
axis equal; axis off
view([0 90])
% if size(varargin,2)>1
%     colormap(varargin{2})
% end
%colormap(bwr)
%caxis([-m m])
%shading interp
% if size(varargin,2)>1
%     colormap(varargin{2})
% end

end

