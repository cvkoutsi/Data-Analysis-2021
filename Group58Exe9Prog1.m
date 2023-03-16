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

Rsq = @(ypred,y) 1 - (sum((y - ypred).^2))/(sum((y - mean(y)).^2));
adjRsq = @(ypred,y,n,k) 1 - ((n-1)/(n - (k+1)))*(sum((y - ypred).^2)/sum((y - mean(y)).^2));


%% starting date -> 26/04/2021 : index= 402
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

X=PR_Day_Gr;
Y=deaths_day; 
[n,k]=size(X);
Ybar = zeros(18,5);
c = cvpartition(n,'KFold',5);

for l =1:5
    idxtrain = training(c,1);
    idxtest = test(c,1);

    %figure out train and test samples
    Xtrain = zeros(length(idxtrain),30);
    Xtest = zeros(length(idxtest),30);
    y = zeros(length(idxtrain),1);
    for i = 1:n
        if idxtrain(i) 
            Xtrain(i,:) = X(i,:);
            y(i) = Y(i);
        end
        if idxtest(i)
            Xtest(i,:) = X(i,:);
        end

    end
    Xtrain( all(~Xtrain,2), : ) = [];
    Xtest( all(~Xtest,2), : ) = [];
    y( all(~y,2), : ) = [];
    
    %train the model
    linearRegression = fitlm(Xtrain,y);
    b = table2array(linearRegression.Coefficients);
    b = b(:,1);
    %test the model by computing the prediction for the left-out data points
    
    Ybar(:,l) = [ones(18,1) Xtest]*b;
    c = repartition(c);
end
Ypred = [Ybar(:,1);Ybar(:,2);Ybar(:,3);Ybar(:,4);Ybar(:,5)]; 
Ypred = sort(Ypred,1);
Y = sort(Y,1);
adjR2 = adjRsq(Ypred,Y,length(Y),length(b));
adjR2_1 = 0.847842;

fprintf('adjRsq from exercise 8: adjRsq = %f\n',adjR2_1);
fprintf('adjRsq with cross validation: adjRsq = %f',adjR2);

%% Conclusion
%Apo ta apotelesmata vlepoume oti petuxainoume kalutero adjRsq me th
%diastavrwmenh epikurwsh. Epomenws, to montelo pou vriskoume me thn diastavrwmenh 
%epikurwsh einai katallhlo gia provlepseis.
