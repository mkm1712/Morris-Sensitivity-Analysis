function [del] = DEL_CHECK(delta,NumFact)
%Function DEL_CHECK provides a check to see if the del vectors for
%individual trajectories are unique or not
[m,n]=size(delta);
A(1:m-1,1)=NaN;
flag=0;
for i=1:1000*NumFact
    if flag==1
        del=delta(m,1);
        break;
    end
    for j=1:m-1
        b=[delta(j,1);delta(m,1)];
        A(j,1)=diff(b);
    end
    c=Count(A,'==0');
    if c==0
        flag=1;
    else
        delta(m,1)=randi([1,NumFact],1,1);
    end
end

