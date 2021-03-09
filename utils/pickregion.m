function [y,y1] = pickregion(figure)
sel=getrect(figure);
%fprintf(1,'Press any key when you have selected the threshold value .\n');
%pause;
y=sel(1);
y1=sel(1)+sel(3);
end