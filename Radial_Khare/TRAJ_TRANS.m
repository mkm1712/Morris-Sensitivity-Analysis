function [traj_trans] = TRAJ_TRANS(traj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[n,m]=size(traj);
for i=1:n
    for j=1:m
        if traj(i,j)==0.125
            traj(i,j)=0;
        else
            if traj(i,j)==0.375
                traj(i,j)=1/3;
            else
                if traj(i,j)==0.625
                    traj(i,j)=2/3;
                else
                    traj(i,j)=1;
                end
            end
        end
    end
end
traj_trans=traj;
end

