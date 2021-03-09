function [H]= Pfilter(S,thresh,type)
%Pfilter: applies different kind of filters to the input vector S,
%specififed by the type argument:
%"hpf" : apply an high pass filter selecting all the frequencies above the
%threshold "tresh". If "thresh" is zero then the threshold value can be
%selected by hand on the plotted spectrum
%"lpf" : apply an low pass filter selecting all the frequencies below the
%threshold "tresh". If "thresh" is zero then the threshold value can be
%selected by hand on the plotted spectrum
%"band" : apply an band pass filter selecting all the in a band, select by
%the user interactively. "tresh"argument  must be zero.


 H=zeros(1,size(S,2));
switch type
case 'hpf'
    if thresh<=0
        plot(S);
        drawnow
        y=pickThresh(gcf);
    else
        y=thresh;
    end
[~,id]=find(S>y);
 H(id)=1;
case 'lpf'
    if thresh<=0
        plot(S);
        drawnow
        y=pickThresh(gcf);
    else
        y=thresh;
    end
 [~,id]=find(S<y);
 H(id)=1;
case 'band'
    assert(thresh<=0,"thresh argument must be zero")
     if thresh<=0
        plot(S(2:end));
        drawnow
        [y,y1]=pickregion(gcf);
      y=[round(y(1)),round(y1(1))];
      y=sort(y);
      hold off
    end
 H(y(1):y(2))=1;

 H(1)=1;
plot(S.*H)
    otherwise
        error("type of filter unknown")
    
end
end
