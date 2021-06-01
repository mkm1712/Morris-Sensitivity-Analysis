function [y] = Repeat_Count(x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
m=length(x(:,1));
y=0;
for i=1:m-1
    for j=i+1:m
        if (x(i,:)-x(j,:))==0
            y=y+1;
            break;
        else
            y=y+0;
        end
    end
end
end

