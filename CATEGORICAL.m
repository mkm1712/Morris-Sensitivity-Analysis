function [modSampF,SNT] = CATEGORICAL(NumCat,NumTraj,Samp)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x = linspace(1,NumCat,NumCat);
Y = nchoosek(x,2); %Unique combinations of categories
y (1:length(Y),1:2)=NaN;
SNT = length(Y); %Number of unique combinations of categories

% Shuffling values in alternate rows from Y
for pp = 1:length(Y)
    if mod(pp,2) == 0
        y(pp,1) = Y(pp,2);
        y(pp,2) = Y(pp,1);
    else
        y(pp,1) = Y(pp,1);
        y(pp,2) = Y(pp,2);
    end
end

%NumTraj1 is max of (1) number of traj to be generated and (2) number of
%unique combinations of categories
if NumTraj > length(y)
    NumTraj1 = length(y);
else
    NumTraj1 = NumTraj;
end


% z stores index of unique combinations
% indices are selected randomly such that they are unique
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


% Check if number of trajectories to be generated is greater than number of
% combinations of categories
Rat = NumTraj/NumTraj1;
RatFl = floor (Rat);
MAdd = mod(NumTraj,NumTraj1);


% If NumTraj > NumTraj1
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
% figure(1)
% hist(ZZ);

ZZ;
ZZE = ZZ;
for mm=1:length(ZZ)
    if rem(mm,2)==0
        ZZE(mm,1)=ZZ(mm-1,1);
        ZZE(mm-1,1)=ZZ(mm,1);
    end
end
[ZZ,ZZE];
NumFact = (length(Samp)/NumTraj)-1;
b = 2;
modSamp_O(1:NumTraj1*(1+NumFact),1) = NaN;
modSamp_O(1,1) = ZZ(1,1);
modSamp_E = modSamp_O;


ZC = 2;

for ii=1:NumTraj1
    ii;
        modSamp_O((ii-1)*(NumFact+1)+1,1) = ZZ(2*(ii-1)+1,1);
        for nn = 2:NumFact+1
            if Samp((ii-1)*(NumFact+1)+nn,1) ~= Samp((ii-1)*(NumFact+1)+1,1)
                modSamp_O((ii-1)*(NumFact+1)+nn,1) = ZZ(2*ii,1);
            else
                modSamp_O((ii-1)*(NumFact+1)+nn,1) = ZZ(2*(ii-1)+1,1);
            end
        end
end
%modSamp_O = modSamp;

for jj=1:NumTraj1
    jj;
        modSamp_E((jj-1)*(NumFact+1)+1,1) = ZZE(2*(jj-1)+1,1);
        for nnn = 2:NumFact+1
            if Samp((jj-1)*(NumFact+1)+nnn,1) ~= Samp((jj-1)*(NumFact+1)+1,1)
                modSamp_E((jj-1)*(NumFact+1)+nnn,1) = ZZE(2*jj,1);
            else
                modSamp_E((jj-1)*(NumFact+1)+nnn,1) = ZZE(2*(jj-1)+1,1);
            end
        end
end
[modSamp_O,modSamp_E];
modSamp = [modSamp_O;modSamp_E];
length(modSamp)/(NumFact+1);

%%%%%%%%
NR = floor(NumTraj/(2*NumTraj1));
modNR = rem(NumTraj,(2*NumTraj1));

if NR >= 1
    ctNR = 1;
    while ctNR <= NR;
        if ctNR == 1
        modSampF = modSamp;
        ctNR = ctNR+1;
        else
            modSampF = [modSampF;modSamp];
            ctNR = ctNR+1;
        end
    end
end

if (modNR ~= 0) && (NR ~= 0)
    AdTraj = NumTraj - NR*2*NumTraj1;
    AdSamp = modSamp(1:AdTraj*(NumFact+1),1);
    modSampF = [modSampF;AdSamp];
end

if (modNR ~= 0) && (NR == 0)
    AdTraj = NumTraj - NR*2*NumTraj1;
    AdSamp = modSamp(1:AdTraj*(NumFact+1),1);
    modSampF = AdSamp;
end

  
    

% figure(2)
% hist(modSampF)
end

