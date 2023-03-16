%Efseveia Nestoropoulou
%Christina Koutsi

%% Clear workspace and load data
clear;
clc;
close all; 
[ECDC,txt1,rawEU] = xlsread('ECDC-7Days-Testing.xlsx');

%% Initialisation

year=[2020 2021];
country={'Slovakia', 'Poland' ,'Portugal' ,'Slovenia' ,'Spain'}; %neighbor countries
country= string(country);
testData=zeros(9,2);
B=1000;
alpha =0.05;
lim=[floor((B+1)*alpha/2),floor((B+1)*(1-alpha/2))];

%% Compare for Slovakia

% Find the positivity rate for W42-50 for Slovakia 
for i=1:2
    testData(:,i) = Group58Exe4Fun1(year(i),country(1),rawEU,ECDC);
end

% Plot data
figure()
hold on;
plot(1:length(testData(:,1)),testData(:,1));
plot(1:length(testData(:,2)),testData(:,2));
hold off;
legend('2020 data','2021 data');
title('Slovakia positivity rate');
ylabel('Positivity Rate');

fprintf('For %s: \n', country(1,1))

% Parametric analysis
[h,p,ci,~] = ttest2(testData(:,1),testData(:,2));
if h==1
    fprintf('[Parametric Analysis] The null Hypothesis is rejected \n')
    if p<0.05
        fprintf('There is a significant difference with p-value: %f\n',p)
    else
        fprintf('[Parametric Analysis] There is not a significant difference with p-value: %f\n',p)
    end
elseif h==0
    fprintf('[Parametric Analysis] The null Hypothesis is accepted \n')
end

% Bootstrap analysis
sample_mean = mean(testData(:,1))-mean(testData(:,2));
boot_2020=bootstrp(B,@mean,testData(:,1));
boot_2021=bootstrp(B,@mean,testData(:,2));
boot_diff = boot_2020 - boot_2021;
boot_diff = sort(boot_diff,1);
CID = [boot_diff(lim(1)); boot_diff(lim(2))];

if CID(1)>0 || CID(2)<0 
   h = 1;   
else   
    h = 0;
end

if h==1
    fprintf('[Bootstrap Analysis] The null Hypothesis is rejected \n')
else
    fprintf('[Bootstrap Analysis] The null Hypothesis is accepted \n')
end
%% Compare for Other Countries

for i=2:5
    
    % Find the positivity rate for W42-50 for the desired neighbor country 
    for j=1:2
        testData(:,j) = Group58Exe4Fun1(year(j),country(i),rawEU,ECDC);
    end
    
    % plot data
    figure()
    hold on;
    plot(1:length(testData(:,1)),testData(:,1));
    plot(1:length(testData(:,2)),testData(:,2));
    hold off;
    legend('2020 data','2021 data');
    title(country(1,i) + ' positivity rate');
    ylabel('Positivity Rate');
    
    fprintf('\nFor %s: \n', country(1,i))
        
    % parametric analysis
    [h,p,ci,~] = ttest2(testData(:,1),testData(:,2));
    if h==1
        fprintf('[Parametric Analysis] The null Hypothesis is rejected \n')
        if p<0.05
            fprintf('There is a significant difference with p-value: %f\n',p)
        else
            fprintf('There is not a significant difference with p-value: %f\n',p)
        end
    elseif h==0
        fprintf('[Parametric Analysis] The null Hypothesis is accepted \n')
    end
    
    % bootstrap analysis
    sample_mean = mean(testData(:,1))-mean(testData(:,2));
    boot_2020=bootstrp(B,@mean,testData(:,1));
    boot_2021=bootstrp(B,@mean,testData(:,2));
    boot_diff = boot_2020 - boot_2021;
    boot_diff = sort(boot_diff,1);
    CID = [boot_diff(lim(1)); boot_diff(lim(2))];

    if CID(1)>0 || CID(2)<0 
       h = 1;   
    else   
        h = 0;
    end

    if h==1
        fprintf('[Bootstrap Analysis] The null Hypothesis is rejected \n')
    else
        fprintf('[Bootstrap Analysis] The null Hypothesis is accepted \n')
    end


end


%% Conclusion 
%Opws vlepoume kai apo ta diagrammata, uparxei shmantikh diafora tou 
%evdomadiaiou deikth thetikothtas twn evdomadws 42-50 tou 2020 kai tou 2021
%epomenws h mhdenikh upothesh isothtas meswn timwn tou evdomadiaiou deikth 
%thetikotitas ths prwths kai ths deuterhs periodou aporriptetai.