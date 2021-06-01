function [FacNames1] = FacNameString(FacNames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i=2:length(FacNames)
    if i==2
        FacNames1=strcat(FacNames(1),',',FacNames(i));
    else
        FacNames1=strcat(FacNames1,',',FacNames(i));
    end
end
end

