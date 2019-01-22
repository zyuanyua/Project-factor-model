function [D] = dnan( D )
D(find(isnan(D(:,1))),:)=[];
D(find(isnan(D(:,2))),:)=[];
end

