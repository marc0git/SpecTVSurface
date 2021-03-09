function [TV]=total_variation(M,f)
%total_variation: computes the total variation energy of function f on
%triangle mesh M defined as: \int_M || \nabla f(x) || dx , by default it outputs the not integrated function
T=M.TRIV;
V=M.VERT;
e2=V(T(:,2),:)-V(T(:,1),:);
e3=V(T(:,3),:)-V(T(:,1),:);
E2=normv(e2);
E3=normv(e3);
% E2=e2;
% E3=e3;
%Dx=[E2,E3];

E=dot(E2,E2,2);
G=dot(E3,E3,2);
F=dot(E2,E3,2);

% E=normv(dot(e2,e2));
%G=normv(dot(e3,e3));
% F=normv(dot(e2,e3));
% g=[E, F;
%    F ,G];
% 
% g_inv=1./det(g).*[G, -F;-F, E] ;

Fu=f(T(:,2),:)-f(T(:,1),:);
Fv=f(T(:,3),:)-f(T(:,1),:);


%RETURNS A VECTOR
TV=real(1/2*sqrt((Fu.^2).*G-2*(Fu.*Fv).*F+(Fv.^2).*E));



integrate=0;
if integrate
    %RETURNS A SCALAR
    A=1/2*normv(cross(e2,e3));
    TV=mean(A.*TV);
end



end
