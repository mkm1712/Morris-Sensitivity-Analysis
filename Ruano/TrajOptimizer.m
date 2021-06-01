function [ data ] = TrajOptimizer( Outmatrix,NumFac,xmin,xmax,rCa,rMo )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% notes added by bob
% Inputs
%   rMo = number of oversampled trajectories (1,1)
%   rCa =  Final number of optimized trajectories(1,1)
%   NumFac  = number of factors (1,1)
%   ?x  = mean of factors (1,k)
%   xmin = lower bound of factors (1,k) =LB' from other scripts
%   xmax = upperbound of factors (1,k)  =UB' from other scripts

%     clc
%     clear all


    %rMo = 100;
    %rCa = 5;
    %k = 4 ;
    x = [0.5 0.5 0.5 0.5] ; 
    %xmin = [0 0 0 0] ;
    %xmax = [1 1 1 1] ;
    %Dprueba=[];
    dtras = [];
%     rCa = 80;
%     rMo = 1000;
%     k=17;
    Dmax =[]; 
    Optimiz =[];
    OptimizT =[];
    D =[];
    copt=[];
    sumad = 0;
    Dmax = 0;
    DmaxT = 0;
%     x = [-0.3	-0.01	0.2	-150	-1	100	-10	-5	-30	-5	18	-100	-1	100	-23	-11	2] ; 
%     xmin = x - abs(0.5*x);
%     xmax = x + abs(0.5*x);
%     Xcamp = [];
% aquí se calcula la matriz de distancias
    %load MatrixX100_20-1341        BOB itemized out for BOB run
%     load MorrisCampoDist20-1359;
X=Outmatrix;
    c1 =1;
%     for c1=1:rMo-1;
    while c1<=rMo-1;
%         for c(2)=c1+1:rMo;
        c2 = c1 + 1;
        while c2<=rMo;
            sumai =0;
            Xc1 = X(((NumFac+1)*(c1-1)+1):(NumFac+1)*c1,:);
            Xc2 = X(((NumFac+1)*(c2-1)+1):(NumFac+1)*c2,:);
            for i=1:NumFac+1;
                sumaj=0;
                for j=1:NumFac+1;
                    sumaz = 0;
                    for z=1:NumFac;
                        sumaz = sumaz + (Xc1(i,z)-Xc2(j,z))^2;
                    end
                    sumaj = sumaj+sqrt(sumaz);
                end
                sumai = sumai +sumaj;
            end
            d(c1,c2) = sumai;
            c2 = c2+1;
        end
        c1 = c1 +1;
    end
    
    flnm1 = strcat('MorrisCampoDist',num2str(rCa),'-',datestr(now,'HHMM')) ;   
    f3 = fullfile(pwd,flnm1) ;
    %save (f3, 'd')

%     load MorrisCampoDist5-1159 % cargo la matriz de distancias
    fila = ones(1,rMo);
    d = [d;fila];
    dtras = d';
    Dcua = dtras + d;
%     for p = 1: rCa-1;
    p=1;
    while p<=rCa-1;
        nc = p;
        i=1;
%         for i=1:rMo;
        while i<=rMo;
            j=1;
%             for j=1:rCa-nc;
            while j<=rCa-nc
                fila1 = Dcua(i,:);
                [a(j),g(j+nc)]= max(fila1);
                Dcua(i,g(j+nc))= 0;
                c(j+nc) = g(j+nc);
                j = j+1;
            end
            c(nc) = i;
%             for k=nc:(rCa-1); % esto es para hacer esto D3= sqrt(d(c(3),c(4))^2+d(c(3),c(5))^2+d(c(4),c(5))^2);
            k = nc;
            while k<=(rCa-1); % esto es para hacer esto D3= sqrt(d(c(3),c(4))^2+d(c(3),c(5))^2+d(c(4),c(5))^2);
%                 for m = k : (rCa-1);
                m = k;
                while m <= (rCa-1);
                    sumad = sumad + d(c(k),c(m+1))^2;
                    m = m+1;
                end
                k = k+1;
            end
            D= sqrt(sumad);
            sumad = 0;
            if D > Dmax;
                Dmax = D;
                Optimiz = [Dmax c];
                copt = c;
            end
            i = i+1;
        end
        
        Dcua = dtras + d;
        Dmax = 0;
%         for j = (nc-1):-1:1;
        j = nc-1;
        while j >=1;
%             for i=1:rMo;
            i = 1;
            while i<=rMo;
                c= copt;
                c(j) =i;
%                 for k=j:(rCa-1); % esto es para hacer esto D3= sqrt(d(c(3),c(4))^2+d(c(3),c(5))^2+d(c(4),c(5))^2);
                k =j;
                while k<=(rCa-1); % esto es para hacer esto D3= sqrt(d(c(3),c(4))^2+d(c(3),c(5))^2+d(c(4),c(5))^2);
%                     for m = k : (rCa-1);
                    m = k;
                    while m <= (rCa-1);
                        sumad = sumad + d(c(k),c(m+1))^2;
                        m = m+1;
                    end
                    k = k+1;
                end
                D = sqrt(sumad);
                sumad = 0;
                if D > Dmax;% && i~=c;
                    rep = 0;
%                     for n = j+1:rCa;
                    n = j+1;
                    while n <=rCa;
                        if i==c(n);
                            rep = 1;
                        end
                        n = n+1;
                    end
                    if rep == 0
                        Dmax = D;
                        Optimiz = [Dmax c];
                        copt = c;
                    end
                end
                i =i+1;
            end
            Dmax = 0;
            j = j-1;
        end
        if Optimiz(1,1) > DmaxT;
            DmaxT = Optimiz(1,1);
            OptimizT = [Optimiz nc];
        end
        p = p+1;
    end
%     load Matrix1000_15-2024
    OptimizT;
    data = OptimizT ;
    flnm0 = strcat('OptimizT_',num2str(rCa),'_',datestr(now,'HHMM'),'.txt') ;
    f2 = fullfile(pwd,flnm0) ;
%   dlmwrite(f2, data, 'delimiter', '\t', 'precision', 6) ;
    k=NumFac;
    for i = 1:rCa;
       Xcamp((i-1)*(k+1)+1:(k+1)*i,:)= X(((k+1)*(OptimizT(1,i+1)-1)+1):(k+1)*OptimizT(1,i+1),:);
    end

    Xval = ones(rCa*(k+1),1)*xmin + (ones(rCa*(k+1),1)*(xmax-xmin)).*Xcamp ;

    data = Xcamp ;
    flnm0 = strcat('MorrisSamplingMatrix1000 in txt_',num2str(rCa),'_',datestr(now,'HHMM'),'.txt') ;
    f2 = fullfile(pwd,flnm0) ;
  %  dlmwrite(f2, data, 'delimiter', '\t', 'precision', 6) ;
    



end

