function [ D ] = strd( D )
%±ê×¼»¯
n=size(D,2);
for i=1:n
    temp1=D(:,i);
    avg=mean(temp1);
    st=std(temp1);
    temp1=(temp1-avg)/st;
    D(:,i)=temp1;
end


