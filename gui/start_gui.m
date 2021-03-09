function []=start_gui(S,M)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%start_gui:starts the interactive GUI to play along with the spectral
%decomposition, applying manual filters to the spectrum, apply localized filters, and resynthesisze
%the result 
%possible actions:
% -PinToZero : applied a band stop filter via drawing a rectangle area on
% the spectrum and  setting to zero all the selected frequencies
% -Double : applied an enhance filter via drawing a rectangle area on
% the spectrum and  doubling all the selected frequencies
% -Update : resynthesize the result on the domain accoridng to the current
% filter (i.e. it solve the screened poisson equation to get vertices
% coordinates from normals)
% -Undo : restarts the gui undoing all the changes to the mesh. It also
% restore the default mask (tunring local to global operations) (see the drawmask action) 
% -UndoSpectrum : retores the oringial spectrum (does not undo the changes to the mesh)
% -drawmask : allows the user to select a specic area on the mesh where the
% filters will be applied: it opens another plot where you first decides
% the camera angle w.r.t draw mask, then hitting the "fixcamera" button one
% can start drawing a closed region. Once finished, click with the mouse
% pointer in some place inside the region and the intersection between the
% region drawed an the mesh in the current fixed view will be the masked
% area
% -LiveUpdate : while toggled, allows the user to manually adjust single
% frequencies while updating the solution in real time (could be slow for
% large meshes)
% -exportMesh : save the current mesh to an .off file named
% "./DATA/TV_out_${CURRENT_DATE}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f=figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,1)
sphere=icosphere(3);

trisurf(sphere.TRIV,sphere.VERT(:,1),sphere.VERT(:,2),sphere.VERT(:,3),'FaceColor',[1 1 1],'EdgeColor',[1,1,1]);hold on;axis off; axis equal
w=plot_mesh(M.f,vertex2triang(M,M.VERT(:,1))); title('Normals');hold off;
colormap(gca,'parula')
subplot(1,3,2)
q=plot_mesh(M,M.VERT(:,1)); view([0 90]); colormap(parula);camlight head;rotate(q,[0,1,0],20);
%colormap(gca,'white')
subplot(1,3,3);
tsh=plot(S,'LineWidth',2);xlabel("$t$","Interpreter","latex")
ylabel("$S(t)$","Interpreter","latex")
title("TV spectrum")

clrs=[245/255, 245/255, 255/255];
%set(f, 'Color', clrs)

hold on;
und=M.VERT;

und_n=M.f;
bgcolor = f.Color;


warning('off','MATLAB:nearlySingularMatrix')





bl1 = uicontrol('Parent',f,'Style','pushbutton','Position',[50,90,83,23],...
    'String','Update','Callback',@update,'BackgroundColor',bgcolor);

b2 = uicontrol('Parent',f,'Style','pushbutton','Position',[50,70,83,23],...
    'String','Undo','Callback',@pushundo,'BackgroundColor',bgcolor);



b10 = uicontrol('Parent',f,'Style','pushbutton','Position',[50,170,83,23],...
    'String','Undospectrum','Callback',@undospectrum,'BackgroundColor',bgcolor);







b3 = uicontrol('Parent',f,'Style','pushbutton','Position',[50,50,83,23],...
    'String','PinToZero','Callback',@pin2zero,'BackgroundColor',bgcolor);

b4 = uicontrol('Parent',f,'Style','pushbutton','Position',[50,30,83,23],...
    'String','Double','Callback',@pindouble,'BackgroundColor',bgcolor);

b5 = uicontrol('Parent',f,'Style','pushbutton','Position',[50,110,83,23],...
    'String','ExportMesh','Callback',@exportMesh,'BackgroundColor',bgcolor);

b6 = uicontrol('Parent',f,'Style','togglebutton','Position',[50,130,83,23],...
    'String','LiveUpdate','Callback',@onvoiddown,'BackgroundColor',bgcolor);


b7 = uicontrol('Parent',f,'Style','pushbutton','Position',[50,150,83,23],...
    'String','drawmask','Callback',@draw_mask,'BackgroundColor',bgcolor);



bdh = scatter(...
    tsh.XData,tsh.YData,...
    50, 'r', 'fill','ButtonDownFcn',@onbtndown);

p = get(bdh,'Parent');
set(p,'ButtonDownFcn',@onvoiddown);

set(gcf, 'Windowkeypressfcn',@update )
    function onvoiddown(src,ev)
        % do nothing
    end


down_pos = [];
drag_pos = [];
down_V = [];
selected_v = [];

mask=ones(M.m,1);
flag_mask=0;

    function draw_mask(src,env)
        
        tmp=figure;
        ax=gca;
        plot_mesh(M);
        colormap(gca,'white');
        rotate3d on;
        bl1 = uicontrol('Parent',gcf,'Style','pushbutton','Position',[50,70,53,23],...
            'String','fixcamera','Callback',@fixcamera,'BackgroundColor',[0.8,0.8,0.8]);
        
        
        
        
        
        
        
        function  fixcamera(src,env)
            
            
            
            [az,el] = view(gca);
            
            
            V=M.VERT;
            % rotate by 90 degrees
            Rx90 = [1 0 0; 0 cos(-pi/2) -sin(-pi/2);0 sin(-pi/2) cos(-pi/2)];
            % rotatation according to elevation from view of t
            Rx = [1 0 0; 0 cos(el*pi/180) -sin(el*pi/180);0 sin(el*pi/180) cos(el*pi/180)];
            % rotation according to azimuth of view of t
            Rz = [cos(-az*pi/180) -sin(-az*pi/180) 0; sin(-az*pi/180) cos(-az*pi/180) 0;0 0 1];
            % rotation matrix that will rotate mesh to
            R = (Rx90*Rx*Rz);
            
            N=M;
            N.VERT=N.VERT*R';
            mask_tmp=draw_shape3(N,1);
            if flag_mask
                mask=or(mask,mask_tmp);
                
            else
                mask=mask_tmp;
            end
            flag_mask=0;
            
            close(tmp)
            mask=vertex2triang(M,mask);
            new_pos = get(bdh,'YData');
            dif=reshape(new_pos./S,1,1,[]);
            g=sum(mask.*(M.phi.*dif),3)+sum((1-mask).*(M.phi),3);%+M.res;
            g=g./normv(g);
            g=mask.*g+(1-mask).*M.f;
            %k=vertex2triang(M,g);
            
            X=vertex_from_normals(M,g);
            M.VERT=full(X);
            M.f=g;
            n=g;
            set(q,'Vertices',full(X))
            set(w,'XData',full(n(:,1)))
            set(w,'YData',full(n(:,2)))
            set(w,'ZData',full(n(:,3)))
            
        end
        
    end



    function exportMesh(src,ev)
        ax=subplot(132);
        h=findobj(ax,'Type','Patch');
        E={};
        E.TRIV=M.TRIV;
        E.n=M.n;
        E.m=M.m;
        E.VERT=h.Vertices;
        d=datestr(datetime);
        writeoff(['./DATA/TV_out',d,'.off'],E)
        disp('Mesh exported succesfully');
    end

    function update(src,ev)
        new_pos = get(bdh,'YData');
        dif=reshape(new_pos./S,1,1,[]);
        g=sum(mask.*(M.phi.*dif),3)+sum((1-mask).*(M.phi),3);%+M.res;
        g=g./normv(g);
        g=mask.*g+(1-mask).*M.f;
        %k=vertex2triang(M,g);
        
        X=vertex_from_normals(M,g);
        M.VERT=full(X);
        M.f=g;
        n=g;
        set(q,'Vertices',full(X))
        set(w,'XData',full(n(:,1)))
        set(w,'YData',full(n(:,2)))
        set(w,'ZData',full(n(:,3)))
        
    end

    function pushundo(src,ev)
        
        set(q,'Vertices',full(und))
        M.VERT=und;
        M.f=und_n;
        set(w,'XData',full(M.f(:,1)))
        set(w,'YData',full(M.f(:,2)))
        set(w,'ZData',full(M.f(:,3)))
        set(bdh, ... ...
            'YData', S);
        set(tsh, ...
            'YData', S);
        mask=ones(M.n,1);
        flag_mask=0;
        
    end

    function undospectrum(src,ev)
        set(bdh, ... ...
            'YData', S);
        set(tsh, ...
            'YData', S);
    end


    function pin2zero(src,ev)
        R=getrect;
        from=round(R(1));
        to=round(R(1)+R(3));
        to=min(size(S,2),to);
        S_pinned= get(bdh,'YData');
        S_pinned(from:to)=0;
        set(bdh, ... ...
            'YData', S_pinned);
        set(tsh, ...
            'YData', S_pinned);
        % down_V=S_pinned;
    end



    function pindouble(src,ev)
        R=getrect;
        from=round(R(1));
        to=round(R(1)+R(3));
        to=min(size(S,2),to);
        S_pinned= get(bdh,'YData');
        S_pinned(from:to)=[1:numel(from:to)].*S_pinned(from:to);
        set(bdh, ... ...
            'YData', S_pinned);
        set(tsh, ...
            'YData', S_pinned);
        % down_V=S_pinned;
    end



    function onbtndown(src,ev)
        selected_v = [];
        down_pos=get(gca,'currentpoint');
        set(gcf,'windowbuttonmotionfcn',@drag)
        set(gcf,'windowbuttonupfcn',@up)
        down_V = [...
            get(bdh,'XData')',...
            get(bdh,'YData')'];
    end

    function drag(src,ev)
        drag_pos=get(gca,'currentpoint');
        new_vert = down_V;
        if isempty(selected_v)
            [~,selected_v] = min(pdist2(drag_pos(1,1:2), new_vert(:,1:2)));
        end
        new_vert(selected_v,1) = drag_pos(1,1);
        new_vert(selected_v,2) = drag_pos(1,2);
        set(bdh, ... ...
            'YData', new_vert(:,2)');
        set(tsh, ...
            'YData', [new_vert(:,2)' ]);
        
        if b6.Value==1
            new_pos = get(bdh,'YData');
            dif=reshape(new_pos./S,1,1,[]);
            g=sum(mask.*(M.phi.*dif),3)+sum((1-mask).*(M.phi),3)%S+M.res;
            g=g./normv(g);
            g=mask.*g+(1-mask).*M.f;
            %k=vertex2triang(M,g);
            
            X=vertex_from_normals(M,g);
            M.VERT=full(X);
            M.f=g;
            n=g;
            set(q,'Vertices',full(X))
            set(w,'XData',full(n(:,1)))
            set(w,'YData',full(n(:,2)))
            set(w,'ZData',full(n(:,3)))
        end
        
        
        
    end


    function up(src,ev)
        set(gcf,'windowbuttonmotionfcn','');
        set(gcf,'windowbuttonupfcn','');
    end

end