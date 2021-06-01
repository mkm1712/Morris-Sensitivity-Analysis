function [EE] = Morris_Measures(k, Sam, Out, p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[sam_r,sam_c]=size(Sam);
r = sam_r/(k+1);
EE(1:k,1:r)=zeros;
Delt = p/(2*(p-1));

for i=1:r
    Sam_r = Sam((i-1)*(k+1)+1:i*(k+1),:);
    Out_r = Out((i-1)*(k+1)+1:i*(k+1),1);
    
    
    for ii = 1:k
        if isequal(Sam_r(ii+1,:),Sam_r(ii,:))==1
            %EE(:,ii)=zeros;
            fprintf('\n Trajectory has non-unique sample points.\n');
        end
        for j=1:k  
            if Sam_r(ii+1,j)-Sam_r(ii,j)>0
                EE(j,i)=Out_r(ii+1,1)-Out_r(ii,1);
            elseif Sam_r(ii+1,j)-Sam_r(ii,j)<0
                EE(j,i)=-(Out_r(ii+1,1)-Out_r(ii,1));
            end
        end
    end
end

EE = EE/Delt;

end

