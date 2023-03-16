%Efseveia Nestoropoulou
%Christina Koutsi
clear;
clc;
close all; 

%% Load data
[EODY,txt,rawGR] = xlsread('FullEodyData_1_2.xlsx');
PR_Day_Gr=zeros(90,30);
deaths_day=zeros(90,1);
adjR2 = zeros(16,1);
X = zeros(90,30,2);
Y = zeros(90,2);
Rsq = @(ypred,y) 1 - (sum((y - ypred).^2))/(sum((y - mean(y)).^2));
adjRsq = @(ypred,y,n,k) 1 - ((n-1)/(n - (k+1)))*(sum((y - ypred).^2)/sum((y - mean(y)).^2));


%% First Period
%starting date -> 10/08/2020 : index= 143
index = 143;
for i=1:90
    if isnan(EODY(index+i,5))
        deaths_day(i,1)=0;
    else
        deaths_day(i,1)=EODY(index+i,5);
    end
    
    for j=1:30
        PR_Day_Gr(i,j) = Group58Exe8Fun1(index+i-j,2020,EODY); 
    end
end

X(:,:,1)=PR_Day_Gr;
Y(:,1)=deaths_day; 

%% Second period

%starting date -> 26/04/2021 : index= 402
index = 402;
for i=1:90
    if isnan(EODY(index+i,5))
        deaths_day(i,1)=0;
    else
        deaths_day(i,1)=EODY(index+i,5);
    end
    
    for j=1:30
        PR_Day_Gr(i,j) = Group58Exe8Fun1(index+i-j,2020,EODY); 
    end
end

X(:,:,2)=PR_Day_Gr;
Y(:,2)=deaths_day; 

%% Normal linear regression
for k = 1:2
    linearRegression = fitlm(X(:,:,k),Y(:,k));
    b = table2array(linearRegression.Coefficients);
    b = b(:,1);

    Ypred = [ones(length(X(:,:,k)),1) X(:,:,k)]*b;
    errors = Y(:,k) - Ypred;
    se = sqrt(sum(errors.^2)/(length(Y(:,k)) - length(b)));
    R2 = Rsq(Ypred,Y(:,k));
    adjR2(1) = adjRsq(Ypred,Y(:,k),length(Y(:,k)),length(b));
    if k ==1
        fprintf('\n---------------[1st period]---------------\n');
        fprintf('Normal Linear Regression: adjRsq= %f \n',adjR2(1))
    elseif k==2
        fprintf('\n---------------[2nd period]---------------\n');
        fprintf('Normal Linear Regression: adjRsq =%f \n',adjR2(1))
    end
        
 %% PCR

    [n,p]=size(X(:,:,k));

    [PCALoadings,PCAScores,PCAVar] = pca(X(:,:,k),'Economy',false);
    PCAVar = PCAVar/sum(PCAVar);
    figure(k);
    plot(1:p,cumsum(100*PCAVar),'-bo');
    xlabel('Number of PCA components');
    ylabel('Percent Variance Explained in Y');
    grid on;
    title([' Period ' num2str(k)]);

    l = 15:1:30;

    for i = 1:15
        betaPCR = regress(Y(:,k)-mean(Y(:,k)), PCAScores(:,1:l(i)));
        betaPCR = PCALoadings(:,1:l(i))*betaPCR;
        betaPCR = [mean(Y(:,k)) - mean(X(:,:,k))*betaPCR; betaPCR];
        yfitPCR = [ones(n,1) X(:,:,k)]*betaPCR;

        adjR2(i+1) = adjRsq(yfitPCR,Y(:,k),length(Y(:,k)),length(betaPCR));
        fprintf('PCR with %d independant variables: adjRsq = %f\n',l(i),adjR2(i+1));
    end
    if k==1
        fprintf('We chose k = 19 independent variables as the best tradeoff with adjRsq = %f\n',adjR2(6)); 
    else 
        fprintf('We chose k = 16 independent variables as the best tradeoff with adjRsq = %f\n',adjR2(3)); 
    end
end

%% Conclusion 
%H proti periodos einai to 2020 sthn arxi tis pandimias kai ta dedomena den
%isos den antapokrinontai plirws ston deikti thetikotitas. Stin deuterh
%periodo eimaste sto 2021 kai exoume pio akrivh kai olokliromena
%deigmata,to opoio fainetai kai apo to adjusted R^2. 
