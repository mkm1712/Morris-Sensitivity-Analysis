function [P1] = p10GEN(r)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
L1=0;
L2=0;
L3=0;
L4=0;
L5=0;
L6=0;
L7=0;
L8=0;
L9=0;
L10=0;
L1max=r/10;
L2max=L1max;
L3max=L1max;
L4max=L1max;
L5max=L1max;
L6max=L1max;
L7max=L1max;
L8max=L1max;
L9max=L1max;
L10max=L1max;
P1(1:r,1)=NaN;
c = 1;
count = 1;

for i=1:randi(100)
    randi(20);
end

while (c==1)
    x=randi(10);
    if (x==1)&&(L1<L1max)
        L1=L1+1;
        P1(count,1)=0;
        count=count+1;
    end
    if (x==2)&&(L2<L2max)
        L2=L2+1;
        P1(count,1)=1/9;
        count=count+1;
    end
    if (x==3)&&(L3<L3max)
        L3=L3+1;
        P1(count,1)=2/9;
        count=count+1;
    end
    if (x==4)&&(L4<L4max)
        L4=L4+1;
        P1(count,1)=3/9;
        count=count+1;
    end
    if (x==5)&&(L5<L5max)
        L5=L5+1;
        P1(count,1)=4/9;
        count=count+1;
    end
    if (x==6)&&(L6<L6max)
        L6=L6+1;
        P1(count,1)=5/9;
        count=count+1;
    end
    if (x==7)&&(L7<L7max)
        L7=L7+1;
        P1(count,1)=6/9;
        count=count+1;
    end
    if (x==8)&&(L8<L8max)
        L8=L8+1;
        P1(count,1)=7/9;
        count=count+1;
    end
    if (x==9)&&(L9<L9max)
        L9=L9+1;
        P1(count,1)=8/9;
        count=count+1;
    end
    if (x==10)&&(L10<L10max)
        L10=L10+1;
        P1(count,1)=1;
        count=count+1;
    end
    
    
    if (L1==L1max)&&(L2==L2max)&&(L3==L3max)&&(L4==L4max)...
            &&(L5==L5max)&&(L6==L6max)&&(L7==L7max)&&(L8==L8max)...
            &&(L9==L9max)&&(L10==L10max)
        c = 0;
    end
end

end




