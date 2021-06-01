function [] = EE_plots(mu_star,mu,sigma,labels,Opt_Name,NumTraj,NumFact,ModName,i)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
MU_STAR(1:length(mu),1)=NaN;
MU = MU_STAR;
SIGMA = MU;
ct=0;
for ii = 1:length(mu)
    if mu_star(ii)==abs(mu(ii))
        MU_STAR(ct+1)=mu_star(ii);
        MU(ct+1)=mu(ii);
        SIGMA(ct+1)=sigma(ii);
        ct = ct+1;
    end
end

figure(i);
subplot(1,2,1)
scatter(mu_star(:,1),sigma(:,1),'*');
a=max(mu_star);
b=max(sigma);
c=[a,b];
d=max(c)*1.3;
axis([0 d 0 d],'square');
[srt_mus,musI]=sort(mu_star,'descend');
%if NumFact>5
%    for j=1:ceil(0.2*NumFact)
%        text(srt_mus(j),sigma(musI(j)), labels{musI(j)}, 'horizontal','left', 'vertical','bottom');
%    end    
%else
text(mu_star(:,1),sigma(:,1), labels(:,1:NumFact), 'horizontal','left', 'vertical','bottom');
%end
grid on;
hold on;
scatter(MU_STAR(1:ct),SIGMA(1:ct),'o','filled');
f=linspace(0,d/1.2,10000);
plot(f,f,'--k');
text(d/1.15,d/1.15,'\mu^*=\sigma','Rotation',45);
hold on;
%plot(2/sqrt(NumTraj)*f,f,'r');
xlabel('\mu^*');
ylabel('\sigma');
title(Opt_Name);
box on;


subplot(1,2,2)
scatter(mu(:,1),sigma(:,1),'*')
a=max(abs(mu));
b=max(abs(sigma));
c=[a,b];
d=max(c)*1.3;
axis([-d d 0 d],'square');
[srt_mu,muI]=sort(abs(mu),'descend');
%if NumFact>5
%    for j=1:ceil(0.2*NumFact)
%        text(srt_mu(j),sigma(muI(j)), labels{muI(j)}, 'horizontal','left', 'vertical','bottom');
%    end    
%else
text(mu(:,1),sigma(:,1), labels(:,1:NumFact), 'horizontal','left', 'vertical','bottom');
%end

grid on;
hold on;
scatter(MU(1:ct),SIGMA(1:ct),'o','filled');

f=linspace(0,d,10000);
plot(2/sqrt(NumTraj)*f,f,'-k');
text(2*d*0.9/sqrt(NumTraj),d*.9,'\leftarrow \mu=2SEM');
hold on;
plot(-2/sqrt(NumTraj)*f,f,'-k');
text(-2*d*0.9/sqrt(NumTraj),d*.9,'\leftarrow \mu=-2SEM');
xlabel('\mu');
ylabel('\sigma');
title(Opt_Name);
box on;
set(gcf,'PaperOrientation','landscape','PaperUnits','normalized','PaperPosition', [0 0 1 1]);
saveas(gcf,[ModName 'Fig' num2str(i)],'pdf');

end
