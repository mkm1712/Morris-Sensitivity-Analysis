function [c] = UNI_TRAJ(FirstPt)
%Function UNI_TRAJ compares first points of trajectories and returns c=0 if
%points are unique else c=1 i.e. non-unique trajectories
[m,n]=size(FirstPt);
c=0;
for i=1:m-1
    if FirstPt(m,:)==FirstPt(i,:);
        fprintf('\n Error: Non-unique Trajectories\n')
        c=1;
        break;
    end
end
end

