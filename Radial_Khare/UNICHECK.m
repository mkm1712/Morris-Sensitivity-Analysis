function [P_] = UNICHECK(P,r)
%Function to check uniquesness of positions
n=length(P);
for i=1:n-1
    if ((P(n,1)==P(i,1))||((mod(P(n,1),2)==0)&&((P(n,1)-1)==P(i,1)))||((mod(P(n,1),2==1)&&((P(n,1)+1==P(i,1))))))
        P(n,1)=2*randi(r,1,1)+randi([0,1],1,1);
        if(P(n,1)==2*r+1)
            P(n,1)=2*randi(r,1,1)+randi([0,1],1,1);
        end
    end
end
P_=P(n,1);
end

