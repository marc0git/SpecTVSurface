

function [h_main, h_inset]=inset(main_handle, inset_handle,f,inset_size)
% The function plotting figure inside figure (main and inset) from 2 existing figures.
% inset_size is the fraction of inset-figure size, default value is 0.35
% The outputs are the axes-handles of both.

if nargin==3
    inset_size=0.15;
     
end
 
%inset_size=inset_size*.7;
%figure
new_fig=f;
main_fig = findobj(main_handle,'Type','axes');
h_main = copyobj(main_fig,new_fig);
set(h_main,'Position',get(main_fig,'Position'))
inset_fig = findobj(inset_handle,'Type','axes');
h_inset = copyobj(inset_fig,new_fig);
ax=get(main_fig,'Position');
set(h_inset,'Position', [+ax(1)-0.4*inset_size ax(2)+ax(4)-inset_size*0.8 inset_size inset_size])