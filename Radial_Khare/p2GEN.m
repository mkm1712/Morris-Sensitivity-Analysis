function [P1] = p2GEN(r)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
L1=0;
L2=0;

L1max=10;
L2max=1;

P1(1:r,1)=NaN;
c = 1;
count = 1;

for i=1:randi(100)
    randi(20);
end

while (c==1)
    x=randi(2);
    if (x==1)&&(L1<L1max)
        L1=L1+1;
        P1(count,1)=0;
        count=count+1;
    end
    if (x==2)&&(L2<L2max)
        L2=L2+1;
        P1(count,1)=1;
        count=count+1;
    end
    if (L1==L1max)&&(L2==L2max)
        c = 0;
    end
end

end

