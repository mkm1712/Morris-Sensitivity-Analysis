function [del] = UNI_DEL(NumFact)
%Function UNI_DEL generates a unique pertubation vector
del(1:NumFact,1)=zeros;

for j=1:NumFact
    del(j,1)=j;
    if j>1
        del(j,1)=DEL_CHECK(del(1:j,1),NumFact);%Function DEL_CHECK provides a check to see if the del vectors for individual trajectories are unique or not
    end
end
                    