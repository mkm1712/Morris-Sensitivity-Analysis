function [EE] = Morris_Measure_Radial(k, Sam, Opt_Val, p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[sam_r,sam_c]=size(Sam);
r = sam_r/(k+1);
EE(1:k,1:r)=NaN;
Delt = p/(2*(p-1));
for i=1:r
    EE(:,i)=EE_Rad_Traj(Sam((i-1)*(k+1)+1:i*(k+1),:),Opt_Val((i-1)*(k+1)+1:i*(k+1),1));
end
EE = EE/Delt;
end

