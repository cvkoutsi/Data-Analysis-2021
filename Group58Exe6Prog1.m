%Christina Koutsi 
%Efseveia Nestoropoulou
clear;
clc;
close all; 

%% Set Variables
[ECDC,txt1,rawEU] = xlsread('ECDC-7Days-Testing.xlsx');
[EODY,txt,rawGR] = xlsread('FullEodyData_1_2.xlsx');
country={'Slovakia', 'Poland' ,'Portugal' ,'Slovenia' ,'Spain'};
country=string(country);

data_countries=zeros(13,5);
PR_Gr=zeros(13,1);
[n,m]=size(data_countries);
temp=1;
L=1000;
Rvalues=zeros(5,1);
sample_mean=zeros(m);
r_values=zeros(L,2);

%% Calculate Positivity Rate for 5 Countries and Greece

for i=1:5
   [temp] = Group58Exe6Fun1(country(i),rawEU,ECDC);
   data_countries(:,i)=temp(:);
end

PR_Gr = Group58Exe6Fun2(EODY);

%% Find The Two Countries with the Greatest Correlation Coefficient

for i=1:m
    combined_data=[data_countries(:,i) PR_Gr(:)];
    temp=corrcoef(combined_data);
    R=temp(1,2);
    Rvalues(i)=R;
end

[Rmax1,i1]=max(Rvalues(:));
Rvalues(i1)=0;
[Rmax2,i2]=max(Rvalues(:));

fprintf('The two countries are: \n')
fprintf('%s with %f \n', country(i1),Rmax1)
fprintf('%s with %f \n', country(i2), Rmax2)

%% Randomization Test

%for the first country
for j=1:L
    zM = [data_countries(:,i1) PR_Gr(randperm(n))];
    tempM=corrcoef(zM);
    r_values(j,1) = tempM(1,2);
end

%for the second country
for j=1:L
    zM = [data_countries(:,i2) PR_Gr(randperm(n))];
    tempM=corrcoef(zM);
    r_values(j,2) = tempM(1,2);
end

for i=1:m
    sample_mean(i) = r_values(i,1)- r_values(i,2);
end
ci = bootci(1000,@mean,sample_mean);

if (0<ci(2)) && (0>ci(1))
    fprintf('The two values are not significant indifferent')
else
    fprintf('The two values are significant indifferent')
end

%% Conclusion 

% it seems the correlation coefficients for the two pairs are not
% significantly indifferent 
