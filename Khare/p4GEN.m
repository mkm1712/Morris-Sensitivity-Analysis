function [P1] = p4GEN(r)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
L1=0;
L2=0;
L3=0;
L4=0;
L1max=r/4;
L2max=L1max;
L3max=L1max;
L4max=L1max;
P1(1:r,1)=NaN;
c = 1;
count = 1;

for i=1:randi(100)
    randi(20);
end

while (c==1)
    x=randi(4);
    if (x==1)&&(L1<L1max)
        L1=L1+1;
        P1(count,1)=0;
        count=count+1;
    end
    if (x==2)&&(L2<L2max)
        L2=L2+1;
        P1(count,1)=1/3;
        count=count+1;
    end
    if (x==3)&&(L3<L3max)
        L3=L3+1;
        P1(count,1)=2/3;
        count=count+1;
    end
    if (x==4)&&(L4<L4max)
        L4=L4+1;
        P1(count,1)=1;
        count=count+1;
    end
    if (L1==L1max)&&(L2==L2max)&&(L3==L3max)&&(L4==L4max)
        c = 0;
    end
end
end

