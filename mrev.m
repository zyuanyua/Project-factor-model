function [ D ] = mrev( D )
%Median method de-extremum
n=size(D,2);
for i=1:n-1
    temp=D(:,i);
    Dm=med(temp);
    Diad=abs(temp-Dm);
    Dmad=med(Diad);
    for j=1:size(temp,1);
        if temp(j,1)>=Dm+3*Dmad
            upper=Dm+3*Dmad;
            if D(j,i)>upper
                D(j,i)=NaN;
            end
        else
            lower=Dm-3*Dmad;
            if D(j,i)<lower
                D(j,i)=NaN;
            end
        end
    end
end

