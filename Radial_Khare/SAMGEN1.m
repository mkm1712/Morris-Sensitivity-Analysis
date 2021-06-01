function [P1] = SAMGEN1(r)
%Function returns a vector of size 2*r containing first and last points of
%r trajectories for one factor/parameter

%1. Function is hard coded for 4 levels i.e. p=4

%2. p=4 means, given factor can have 4 values 1/8, 3/8, 5/8 and 7/8

%3. If there are r trajectories r/2 trajectories will have 1/8 as their
%   first or last point. Same is true for 3/8, 5/8 and 7/8

%4. P11, P12, P13 and P14 are vectors of length r/2. 
%   P11 corresponds to trajectories starting or ending on 1/8
%   Similarly P12, P13 and P14 correspond to 3/8, 5/8 and 7/8

%5. Desired 'delta' value for p=4 is 2/3 which upon appropriate rescaling
%   becomes 1/2
%   Hence elements of P11 and P13 form pairs. In other words if first point
%   of the trajectory is 1/8 last point will be 5/8. Similarly P12 and P14
%   form pairs

P11(1:r/2,1)=zeros;
P13(1:r/2,1)=zeros;
P12(1:r/2,1)=zeros;
P14(1:r/2,1)=zeros;

for i=1:1000
    count=i;
%Function FIRST_QT_GEN returns trajectories corresponding to factor/parameter value 1/8
    P11=FIRST_QT_GEN(r);
%If the element of P11(:,1) is even -> Last point of the trajectory, else
%first point
    P11_mod=mod(P11(:,1),2);
    
%Function 'Count' returns number of elements in a matrix equal to the
%specified value
    c=Count(P11_mod,'==0');%Counting number of trajectories with 1/8 as the last point
    
%We want our samples to be uniform.    
%If r is even, c should be r/4
    if((mod(r/2,2)==0)&& (c==r/4))
        flag=1;
        break;
    end
%If r is odd, c should be (r/2-1)/2 or (r/2+1)/2
    if((mod(r/2,2)~=0)&&(((r/2-1)/2 ==c)||((r/2+1)/2 ==c)))
        flag=1;
        break;
    end
end
P11;

%Filling up positions of 3/8 based on positions of 1/8 
for ii=1:r/2
    if mod(P11(ii,1),2)==0
        P13(ii,1)=P11(ii,1)-1;
    else
        P13(ii,1)=P11(ii,1)+1;
    end
end
P13;

%P_d contains trajectory numbers which either start or end on 1/8
P_d=P11/2;
P_d_(1:r/2,1)=NaN;
for k=1:r/2
    if(mod(P_d(k,1),1)>0)
        P_d_(k,1)=ceil(P_d(k,1));
    else
        P_d_(k,1)=P_d(k,1);
    end
end
P_d_=sort(P_d_);

%Vector r_traj will store remaining trajectory numbers 
r_traj(1:r/2,1)=NaN;
for l=1:r/2
    if(l==1)
        c=1;
        for ll=1:r/2
            if (P_d_(ll,1)~=c)
                r_traj(l,1)=c;
                break;
            else
                c=c+1;
            end
        end
    else
        c=r_traj(l-1,1);
        c=c+1;
        for lll=1:r/2
            if(P_d_(lll,1)==c);
                c=c+1;
            else
            end
        end
        r_traj(l,1)=c;
    end
end       
r_traj;

%Generation of P12
if (mod(r/2,2)==0)%If r is even
    c1=r/2/2;
    flag = 0;
    for m1=1:4*r
        flag;
        if flag == 1
            break;
        else                   
            P12(1:r/2,1)=randi([0,1],r/2,1);
            c=Count(P12,'==0');
            if (c==c1)
                flag = 1;
                break;
            end
        end
    end
end
if (mod(r/2,2)~=0)%If r is odd
    c1=((r/2)-1)/2;
    c2=((r/2)+1)/2;
    flag = 0;
    for m1=1:4*r
        flag;
        if flag == 1
            break;
        else                   
            P12(1:r/2,1)=randi([0,1],r/2,1);
            c=Count(P12,'==0');
            if (c==c1 || c==c2)
                flag = 1;
                break;
            end
        end
    end
end
P12;%Vector of length r/2 with values 0 or 1
P12=2.*r_traj-1+P12;
P12;%Vector with positions of 3/8 

%Generation of vector P14 based on P12
for n1=1:r/2
    if (mod(P12(n1,1),2)==0)
        P14(n1,1)=P12(n1,1)-1;
    else
        P14(n1,1)=P12(n1,1)+1;
    end
end
P14;

%Vector P1 contains first and last points of r trajectories
P1(1:2*r,1)=zeros;
for n2=1:2*r
    for n3=1:r/2
        if P11(n3,1)==n2
            P1(n2,1)=1/8;
        else
            if P12(n3,1)==n2
                P1(n2,1)=3/8;
            else
                if P13(n3,1)==n2
                    P1(n2,1)=5/8;
                else
                    if P14(n3,1)==n2
                        P1(n2,1)=7/8;
                    end
                end
            end
        end
    end
end
P1;  
end

