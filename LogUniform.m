function [ modFacSamples ] = LogUniform(OptimizedTraj,...
            IntLB,IntUB,Weight, NumIntervals)
%This program mapps factor trajectories from U[1:0] to LogUniform 
%distribution.  requires:   Optimized Trajectories(factor coordinates)
%                           IntLB = vector of interval lower bounds
%                           IntUB = vector of interval Upper bounds
%                           Weight= interval weighting
%                           i     = counter
 
 
 
 
        tempFacSamples=OptimizedTraj;
        modFacSamples(1:length(OptimizedTraj),1)=zeros;

 %For a a single interval

        if NumIntervals == 1;
            for kk=1:size(tempFacSamples);
                sample=tempFacSamples(kk);
                modFacSamples(kk,1) = IntLB*exp((log(IntUB)-.....
                    log(IntLB))*sample);
            end
        else

 % for multiple intervals

        % convert weights into cdf probabilities
        Prob(1,1) =  Weight(1,1);
        for j=1:size(Weight)-1;
            Prob(j+1,1)=Prob(j,1)+Weight(j+1);
        end


        %Find what interval the sample is in and calc
        for j=1:size(tempFacSamples);
            sample=tempFacSamples(j); 
            ll=find(Prob>= sample,1);%find index of prob > sample


            if ll == 1
                iweight= Weight(ll,1);
                sample = sample/iweight;
                modFacSamples(j,1)= IntLB(ll,1)....
                    *exp((log(IntUB(ll,1))-log(IntLB(ll,1)))*...
                    sample);
            else
                iweight= Weight(ll,1);
                sample = (sample-Prob(ll-1))/iweight;                        
                modFacSamples(j,1)= IntLB(ll,1)*...
                    exp((log(IntUB(ll,1))-log(IntLB(ll,1)))*...
                    sample); 
            end
        end
        
end

