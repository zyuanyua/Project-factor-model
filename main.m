
% Loading data
D=xlsread('***.xlsx'); % Loading data of a single factor
returnr=xlsread('returnrate.xlsx');  % loading data of return
for i=size(returnr,1)+1:size(D,1)
    for j=1:size(returnr,2)
        returnr(i,j)=NaN;
    end
end

for i=2:size(D,2)
    %Crossing the extremum out
    D(:,i)=mrev(mrev(D(:,i)));
   
    temp=dnan([D(:,i) returnr(:,i)]);
   
    %Standardization 
    temp(:,1)=strd(temp(:,1));
    
    %Calculate IC
    temp1=dnan([D(:,i-1) returnr(:,i-1)]);
    IC(i-1)=corr(temp1(:,1),temp1(:,2),'type','Spearman');
    
    %Calculate the number of shares 
    nos(i-1)=round(size(temp,1)/10);
    
    %Change positive and negative sign
    if IC(i-1)>0     
        temp=sortrows(temp,-1);
    else
        temp=sortrows(temp,1);
    end
    temp=temp(:,2);
    
    %Compute return per month
   for k=1:9
       ttreturn(k,i-1)=0;
       for j=1:nos(i-1)
           ttreturn(k,i-1)=ttreturn(k,i-1)+temp((k-1)*nos(i-1)+j,1);
       end
       ttreturn(k,i-1)=ttreturn(k,i-1)/nos(i-1);
   end
   ttreturn(10,i-1)=sum(temp(9*nos(i-1)+1:size(temp,1)))/(size(temp,1)-9*nos(i-1));
end
ttreturn=ttreturn';  %ttreturn is Quarterly yield of ten srtategies
%%
%Compute total return
ttreturn1=zeros(size(ttreturn,1),2*size(ttreturn,2));
ttreturn1(:,1)=ttreturn(:,1);
ttreturn1(:,2)=ttreturn(:,1);
for i=3:size(ttreturn1,2)
    if mod(i,2)==1
       ttreturn1(:,i)=ttreturn(:,(i+1)/2);
       ttreturn1(:,i+1)= ttreturn1(:,i);
    end
end
for i=1:size(ttreturn1,2)
    for j=2:size(ttreturn1,1)
        if mod(i,2)==0
            ttreturn1(j,i)=ttreturn1(j,i)+ttreturn1(j-1,i);
        end
    end
end
for i=1:size(ttreturn1,2)
    if mod(i,2)==0
        ttreturn2(:,i/2)=ttreturn1(:,i);
    end
end
%Plot curve of total return
x=[1:size(ttreturn2,1)];
plot(x,ttreturn2(:,1)',x,ttreturn2(:,2)',x,ttreturn2(:,3)',x,ttreturn2(:,4)',x,ttreturn2(:,5)',x,ttreturn2(:,6)',x,ttreturn2(:,7)'...
    ,x,ttreturn2(:,8)',x,ttreturn2(:,9)',x,ttreturn2(:,10)'),xlabel('times'),ylabel('total return'),legend('0-0.1','0.1-0.2'...
    ,'0.2-0.3','0.3-0.4','0.4-0.5','0.5-0.6','0.6-0.7','0.7-0.8','0.8-0.9','0.9-1','Location','NorthWest')
%%
%Calculate winning rate, annual return rate, Sharp ratio
for j=1:size(ttreturn,2)
    k=0;
    for i=1:size(ttreturn,1)
       if  ttreturn(i,j)>0
           k=k+1;
       end
    end
    WinRate(j)=k/size(ttreturn,1);
   if size(ttreturn2,1)>100
        AnnualRate(j)=mean(ttreturn(:,j))*12;
        SharpeRatio(j)=((mean(ttreturn(:,j))-0.03/12)*sqrt(12))/std(ttreturn(:,j));
    else
        AnnualRate(j)=mean(ttreturn(:,j))*3;
        SharpeRatio(j)=((mean(ttreturn(:,j))-0.03/3)*sqrt(3))/std(ttreturn(:,j));
    end

end
%Calculating the Maximum loss Rate
ttreturn3=ttreturn+1;
for i=1:size(ttreturn3,2)
    MaxDrawdown(i)=inf;
    for j=1:size(ttreturn3,1)
        for k=j:size(ttreturn3,1)
            MaxDrawdownTemp=ttreturn3(k,i)/ttreturn3(j,i)-1;
            if MaxDrawdownTemp<MaxDrawdown(i)
                MaxDrawdown(i)=MaxDrawdownTemp;
            end
        end
    end
end
Data=cell(5,11);
Data(:,1)={'rank','winning probability','annual return ','sharp ratio','Maximum loss Rate'};
Data(1,2:11)={0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1};
%Data is table of 'rank','winning probability','annual return ','sharp ratio','Maximum loss Rate'
for j=2:11
    Data(2,j)={WinRate(j-1)};
    Data(3,j)={AnnualRate(j-1)};
    Data(4,j)={SharpeRatio(j-1)};
    Data(5,j)={MaxDrawdown(j-1)};
end
%%
%Output
xlswrite('roa_result',ttreturn1)

