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
L=1000;
alpha=[0.01, 0.05];
[n,m]=size(data_countries);
temp=1;
Rmax=0;
Rvalues=zeros(5,1);


%% Calculate Positivity Rate for 5 Countries and Greece

for i=1:5
   [temp] = Group58Exe5Fun1(country(i),rawEU,ECDC);
   data_countries(:,i)=temp(:);
end

PR_Gr = Group58Exe5Fun2(EODY);

%% Parametric and Randomization tests

for i=1:m
    for a=1:2
        lowlim=round((alpha(a)/2)*L);
        upplim=round((1-alpha(a)/2)*L);
        tcrit=tinv(1-alpha(a)/2,n-2);
        
        combined_data=[data_countries(:,i) PR_Gr(:)];
        temp=corrcoef(combined_data);
        R=temp(1,2);
        Rvalues(i)=R;
        
        rV = NaN*ones(L,1);
        for j=1:L
            random_data=[combined_data(:,1) combined_data(randperm(n),2)];
            temp=corrcoef(random_data);
            rV(j)=temp(1,2);
        end
        
        t=R*sqrt((n-2)/(1-R^2));
        tV=rV.*sqrt((n-2)./(1-rV.^2));
        sorted_t=sort(tV);
        t_lower=sorted_t(lowlim); 
        t_upper=sorted_t(upplim);
        
        fprintf('For %s (with alpha=%3.2f) :\n',country(i),alpha(a));
        if abs(t) > tcrit
            fprintf('Parametric test: abs(t-statistic)=%2.3f > %1.3f -> reject H0 \n',abs(t),tcrit);
        else
            fprintf('Parametric test: abs(t-statistic)=%2.3f < %1.3f -> accepted H0 \n',abs(t),tcrit);
        end
        if t < t_lower || t > t_upper
            fprintf('Randomization test: t-statistic=%2.3f not in [%1.3f,%1.3f] -> reject H0 \n \n',t,t_lower,t_upper);
        else
            fprintf('Randomization test: t-statistic=%2.3f in [%1.3f,%1.3f] -> accepted H0 \n \n',t,t_lower,t_upper);
        end   
        
    end
end
[Rmax,i]=max(Rvalues(:));

fprintf('The country with the greatest correlation coefficient is %s with %f', country(i), Rmax)


%% Conclusion
%apo tis 5 epilegmenes xwres [Slovakia, Poland, Portugal, Slovenia, Spain]
%i poreia tou evdomadiaiou deikti thetikotikas tis Elladas sxedizetai perissotero me
%tis Slovakias gia to teleutaio trimhno


