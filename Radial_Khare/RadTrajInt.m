function [radtraj] = RadTrajInt(FP,LP)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

radtraj(1:length(FP)+1,1:length(FP))=NaN;
radtraj(1,:)=FP(:,:);
for i=1:length(FP)
    FPTemp=FP(1,:);
    FPTemp(1,i)=LP(1,i);
    radtraj(i+1,:)=FPTemp;
end

end

