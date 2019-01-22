function [ md ] = med(a)
%find median
a1=sort(a);
ss=sum(isfinite(a1));
flag=mod(ss,2);
if flag==1
    md=a1((ss+1)/2);
else
    md=(a1(ss/2)+a1(ss/2+1))/2;
end

