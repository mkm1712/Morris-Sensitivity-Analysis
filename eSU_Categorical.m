clear;
clc;
NumCate = 4;
NumTraj = 22;
x = linspace(1,NumCate,NumCate);
y = nchoosek(x,2);
y = [y(:,2),y(:,1)];

if NumTraj > length(y)
    NumTraj1 = length(y);
else
    NumTraj1 = NumTraj;
end

z(1:NumTraj1,1)=NaN;

for i = 1:NumTraj1
    if i == 1
        z(i,1) = randi(length(y));
    else
        a = randi(length(y));
        while ismember(a,z(1:i-1,1))
            a = randi(length(y));
        end
        z(i,1) = a;
    end
end
% for ii = 1:length(z)
%     Z(ii,:) = y(z(ii,1),:);
% end
% Z
Rat = NumTraj/NumTraj1
RatFl = floor (Rat)
MAdd = mod(NumTraj,NumTraj1)

if Rat > 1
    ZZ(1:2*(RatFl*NumTraj1+MAdd),1) = NaN;
    for jj = 1:length(z)
        ZZ(2*(jj-1)+1,:) = y(z(jj,1),1);
        ZZ(2*jj,:) = y(z(jj,1),2);
    end
    for jjj = 1:RatFl
        ZZ((jjj-1)*2*length(z)+1:jjj*2*length(z),1) = ZZ(1:2*length(z),1);
        if jjj == RatFl
            ZZ(jjj*2*length(z)+1:jjj*2*length(z)+2*MAdd,1)=ZZ(1:2*MAdd,1);
        end
    end
else
    ZZ(1:2*NumTraj1,1) = NaN;
    for kkk = 1:length(z)
        ZZ(2*(kkk-1)+1,:) = y(z(kkk,1),1);
        ZZ(2*kkk,:) = y(z(kkk,1),2);
    end
    
end
    
   
hist(ZZ)
ZZ
length(ZZ)

   