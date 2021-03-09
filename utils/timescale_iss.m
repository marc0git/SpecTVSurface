function t=timescale_iss(reg, regFact,comp,nonuniform)

if nonuniform==1
alpha=reg;
for i=1:comp
    t(i)=1/alpha;
    alpha=alpha*regFact;
end
t=cumsum(t);

else
   
    alpha=reg;
    
for i=1:comp
    t(i)=1/alpha;
    alpha=max(alpha-regFact,1e-8);
end
t=cumsum(t);

end