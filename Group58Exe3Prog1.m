%Efseveia Nestoropoulou
%Christina Koutsi
clear;
clc;
close all; 
data_Gr = zeros(12,1);
data_Eu = zeros(12,1);

%% Load data
[EODY,txt,rawGR] = xlsread('FullEodyData_1_2.xlsx');
[ECDC,txt1,rawEU] = xlsread('ECDC-7Days-Testing.xlsx');

%% Find the week that Positivity Rate is Max in Slovakia
[date_20,date_21] = Group58Exe1Fun1(ECDC,rawEU);
year = str2num(date_21(1:end-4));
week = str2num(date_21(7:end));

%% Calculate Positivity Rate
for i = 1:12
    [PR_Day_Gr,PR_Gr,PR_Eu] = Group58Exe3Fun1(week,year,EODY,ECDC,rawEU);
    [confidenceGR,diafora_me_EU]= Group58Exe3Fun2(PR_Day_Gr,PR_Eu);
    data_Gr(i) = PR_Gr;
    data_Eu(i) = PR_Eu;
    week = week-1;
end

figure()
plot(1:12,data_Gr,'-o');
hold on;
plot(1:12,data_Eu,'-x');
hold off;
legend('Positivity Rate of Greece','Positivity Rate of Europe');

%% Conclusion
% It seems that the positivity rate of Greece is smaller than the
% positivity rate of Europe and there is a significant difference between
% the two values for the most of the months.
