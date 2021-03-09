function idx_all=findpeaks(X)
n=max(size(X));
idx=[];
idx_all={};
thresh=mean(abs(diff(X)));
th=mean(X(2:end));
for i=2:n-1
    if X(i)>X(i-1) && X(i+1)<X(i) && X(i)>=mean(th)
        idx(end+1)=i;
        l=i-1;
        u=i+1;
        while l>1 && u<n  && X(l)<X(l+1) && X(u)>X(u+1)
            idx(end+1)=u;
            idx(end+1)=l;
            l=l-1;
            u=u+1;
        end
    idx_all{end+1}=unique(idx);
    idx=[];  
    end
    
%     eps=mean(abs(diff(X)))-0.8*mean(abs(diff(X)));
%     for i=2:n-1
%         if X(i)>X(i-1)+eps && X(i+1)+eps<X(i) && X(i+2)<X(i+1) && X(i-2)<X(i-1)
%             idx(end+1)=i;
%             l=i-1;
%             u=i+1;
%             while l>1 && u<n  && X(l)<X(l+1) && X(u)>X(u+1)
%                 idx(end+1)=u;
%                 idx(end+1)=l;
%                 l=l-1;
%                 u=u+1;
%             end
%         end
%     end
    
    
end

    %idx=unique(idx);
    
end