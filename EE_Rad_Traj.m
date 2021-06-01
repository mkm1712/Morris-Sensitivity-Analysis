function [EEr] = EE_Rad_Traj(Sam,Opt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

EEr(1:length(Opt)-1,1)=NaN;

for i=2:length(Opt)
    if isequal(Sam(i-1,:),Sam(i,:))==1
        fprintf('\n Trajectory has non-unique sample points.\n');
    end
    if (Sam(i,i-1)-Sam(1,i-1))>0
        EEr(i-1,1)=Opt(i,1)-Opt(1,1);
    elseif (Sam(i,i-1)-Sam(1,i-1))<0
        EEr(i-1,1)=-(Opt(i,1)-Opt(1,1));
    elseif(Sam(i,i-1)-Sam(1,i-1))==0
        EEr(i-1,1)=0;
    end
end
EEr;end

