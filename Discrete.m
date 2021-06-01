function [ modFacSamples ] = Discrete(OptimizedTraj,...
    numElements,element,Weight)
%This program mapps factor trajectories from U[1:0] to Discrete 
%distribution.  requires:
%               tempFacSamples(factor coordinates)
%               numElements       = # values in discrete dist
%               element           = eleament values in dist
%               Weight            = weight of each corresponding element

        % convert weights into cdf probabilities
        Prob(1,1) =  Weight(1,1);
        for j=1:numElements-1;
            Prob(j+1,1)=Prob(j,1)+Weight(j+1);
        end
        
        %collect sample data
        tempFacSamples=OptimizedTraj;

        %mapping
        for jj=1:length(tempFacSamples);
            sample=tempFacSamples(jj);

            ll=find(Prob > sample,1);%find index of prob > sample
            if (sample == 1)
                ll=length(Prob);
            end
            modFacSamples(jj,1)= element(ll);
        end
end

