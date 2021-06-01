function [t_d] = DIST1(t1,t2,NumFact)
%DIST1 Calculates the Euclidean distances between trajectories t1 and t2
%Inputs: t1, t2 and NumFact
%Output: Euclidean distance between t1 and t2
%   Detailed explanation goes here
sum=0;
for i=1:NumFact+1
    for j=1:NumFact+1
        sum1=0;
        a(1,1:NumFact)=t1(i,:)-t2(j,:);
        b(1,1:NumFact)=a.^2;
        for ii=1:NumFact
            sum1=sum1+b(1,ii);
        end
        sum=sum+sqrt(sum1);
    end
end
t_d=sum;
end

