%Efseveia Nestoropoulou
%Christina Koutsi
clear;
clc;
close all; 

%% Load data
[EODY,txt,rawGR] = xlsread('FullEodyData_1_2.xlsx');
PR_day=zeros(29);
deaths_day=zeros(29);
Tube_day=zeros(29);
Tube_unvax_day=zeros(29);
Case_over_65_day=zeros(29);
adjR2 = zeros(16,1);

varnameM = str2mat('Daily Deaths','Positivity Rate','Tubed','Tubed Unvax','Cases over 65');
alpha = 0.05;

Rsq = @(ypred,y) 1 - (sum((y - ypred).^2))/(sum((y - mean(y)).^2));
adjRsq = @(ypred,y,n,k) 1 - ((n-1)/(n - (k+1)))*(sum((y - ypred).^2)/sum((y - mean(y)).^2));

%% starting date -> 29/11/2021 : index = 619
%end date -> 27/12/2021: week=52 index=648
index = 619;
j=20;
for i=1:29
    if isnan(EODY(index+i,5))
        deaths_day(i)=0;
    else
        deaths_day(i)=EODY(index+i,5);
    end
    
    if isnan(EODY(index+i-j+1,7))
        Tube_day(i)=0;
    else
        Tube_day(i)=EODY(index+i-j+1,7);
    end
    if isnan(EODY(index+i-j+1,8))
        Tube_unvax_day(i)=0;
    else
        Tube_unvax_day(i)=EODY(index+i-j+1,8);
    end
    Case_over_65_day(i)=EODY(index+i-j+1,42)-EODY(index+i-j,42);
    PR_day(i) = Group58Exe8Fun1(index+i-j,2021,EODY); 

end
xM=[PR_day(:,1) Tube_day(:,1) Tube_unvax_day(:,1) Case_over_65_day(:,1)];
yV=deaths_day(:,1); 
k = size(xM,2);
n = length(yV);
zcrit = norminv(1-alpha/2);

%% Plots for every variable
for i=1:k
    x1M = [ones(n,1) xM(:,i)];
    [b1V,b1int,stats1] = regress(yV,x1M);
    yhat1V = x1M * b1V;
    e1V = yV-yhat1V;
    se12 = (1/(n-2))*(sum(e1V.^2));
    se1 = sqrt(se12);
    my = mean(yV);
    R21 = 1-(sum(e1V.^2))/(sum((yV-my).^2));
    adjR21 =1-((n-1)/(n-2))*(sum(e1V.^2))/(sum((yV-my).^2));
    estar1V = e1V / se1;

    figure((i-1)*2+1)
    clf
    plot(xM(:,i),yV,'.')
    hold on
    plot(xM(:,i),yhat1V,'r')
    title(sprintf('x=%s, R^2=%1.5f adjR^2=%1.5f',deblank(varnameM(i+1,:)),R21,adjR21))
    
    figure(i*2)
    clf
    plot(yV,estar1V,'o')
    hold on
    ax = axis;
    plot([ax(1) ax(2)],[0 0],'k')
    plot([ax(1) ax(2)],zcrit*[1 1],'c--')
    plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
    xlabel('y')
    ylabel('e^*')
    title(sprintf('diagnostic plot, x=%s',deblank(varnameM(i+1,:))));
end

%% Full Model
my = mean(yV);
xregM = [ones(n,1) xM];
[ballV,ballint,rall,rallint,statsall] = regress(yV,xregM);
yhatallV = xregM * ballV;
eallV = yV-yhatallV;
seall2 = (1/(n-(k+1)))*(sum(eallV.^2));
seall = sqrt(seall2);
R2all = 1-(sum(eallV.^2))/(sum((yV-my).^2));
adjR2all =1-((n-1)/(n-(k+1)))*(sum(eallV.^2))/(sum((yV-my).^2));
estarallV = eallV / seall;

fprintf('FULL MODEL: \n');
fprintf('x-variable \t beta \t estimate \t 95%% CI \n');
fprintf('const \t beta0 \t %2.5f \t [%2.5f,%2.5f] \n',ballV(1),ballint(1,1),ballint(1,2));
for i=2:k+1
    fprintf('%s \t beta%d \t %2.5f \t [%2.5f,%2.5f] \n',deblank(varnameM(i,:)),...
        i-1,ballV(i),ballint(i,1),ballint(i,2));
end

fprintf('\n R^2 = %1.5f   adjR^2=%1.5f \n',R2all,adjR2all);
fprintf('\n');

zcrit = norminv(1-alpha/2);
figure(k*2+1)
clf
plot(yV,estarallV,'o')
hold on
ax = axis;
plot([ax(1) ax(2)],[0 0],'k')
plot([ax(1) ax(2)],zcrit*[1 1],'c--')
plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
xlabel('y')
ylabel('e^*')
title('diagnostic plot, full model');

%% Predict Deaths for 28/12/2021
linearRegression = fitlm(xM,yV);
b = table2array(linearRegression.Coefficients);
b = b(:,1);

x0=[2.7 635 540 209];
Ypred = [ones(1,1) x0(1,:)]*b;
fprintf('Predicted deaths for 28/12/2021 are: %3.0f \n',Ypred)


%% Conclusion
%The predicted value seems to be accurate. The values for x0 were taken
%from the diagrams of the website that we were given. As expected, the
%positivity rate is the variable that affects th most the daily deaths.

