function [ modFacSamples ] = Uniform( OptimizedTraj,IntLB,IntUB,...
               Weight,NumIntervals )
%This program mapps factor trajectories from U[1:0] toUniform 
%distribution.  requires:   Optimized Trajectories(factor coordinates)
%                           IntLB = vector of interval lower bounds
%                           IntUB = vector of interval Upper bounds
%                           Weight= interval weighting
%                           i     = counter
 
       %collect sample data
       tempFacSamples=OptimizedTraj; 
       modFacSamples(1:size(OptimizedTraj),1)=zeros; 


        

        %if there is a single interval
        if NumIntervals == 1;
            modFacSamples = IntLB + (IntUB - IntLB) * tempFacSamples;
        else

            % for multiple intervals

             % convert weights into cdf probabilities
            Prob(1,1) =  Weight(1,1);
            for j=1:size(Weight)-1;
                Prob(j+1,1)=Prob(j,1)+Weight(j+1);
            end


            %Find what interval the sample is in 
            for j=1:size(tempFacSamples);
                sample=tempFacSamples(j); 
                ll=find(Prob> sample,1);%find index of prob > sample
                if ll == 1
                    tempWeight=Weight(ll,1);
                    sample=sample/tempWeight;
                    modFacSamples(j,1)= IntLB(ll,1) + (IntUB(ll,1) -.....
                        IntLB(ll,1)) * sample;
                else
                    tempWeight=Weight(ll,1);
                    sample=(sample-Prob(ll-1,1))/tempWeight;
                    modFacSamples(j,1)= IntLB(ll,1) + (IntUB(ll,1) -.....
                        IntLB(ll,1)) * sample; 
                end

            end
        end
        clear IntLB
        clear IntUB
        clear Prob
        clear Weight
end    



