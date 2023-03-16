% Efseveia Nestoropoulou
% Christina Koutsi

%% Clear workspace and load data
clear;
clc;
close all; 
[ECDC,txt,raw] = xlsread('ECDC-7Days-Testing.xlsx');

% variables and limits for the random permutation test
alpha = 0.05;
B = 1000;
lim = [floor((B+1)*alpha/2),floor((B+1)*(1-alpha/2))];

%% Select data for testing

% load the desired dates of testing for 2020 and 2021
[date_20,date_21] = Group58Exe1Fun1(ECDC,raw);
k=1;
m=1;

testData = zeros(25,2);

for i = 1:length(raw)
    %include data from national level testing in the desired week of 2020
    if strcmp(raw(i,4),'national') && strcmp(raw(i,3),date_20)
         testData(k,1)=ECDC(i-1,5);
         k=k+1;
    end
    %include data from national level testing in the desired week of 2021
    if strcmp(raw(i,4),'national') && strcmp(raw(i,3),date_21)
        testData(m,2)=ECDC(i-1,5);
        m=m+1;
    end
end

%% Sort and plot data
testData = sort(testData,1);
figure();
hold on;
plot(testData(:,1),1:length(testData));
plot(testData(:,2),1:length(testData));
hold off;
legend('2020 Data','2021 Data')

%% Test for the null hypothesis that 2020 and 2021 data come from the same  distribution with the Kolmogorov- Smirnov statistic

% declare and calculate the CDF for each sample 
nY = length(testData);
nX = nY-3;
fx = zeros(nX,1);
fy = zeros(nY,1);

% cdf for data of 2020
for i = 1:nX
    fx(i) = i/nX;
end

% cdf for data of 2020
for i = 1:nY
    fy(i) = i/nY;
end

% Random Permutation Test
D_ks = zeros(B+1,1);
h = 0;
joined = [fx' fy'];

for i=1:B
    rand_num = randperm(length(joined));
    rand_joined = joined(rand_num);
    fx_rand = rand_joined(1:nX);
    fy_rand = rand_joined(nX+1:nX+nY);
    D_ks(i) = max(abs(fx_rand - fy_rand(1:numel(fx_rand))));
end
D_ks(B+1) = max(abs(fx - fy(1:numel(fx))));
D_ks = sort(D_ks,1);
k = find(D_ks(:) == max(abs(fx - fy(1:numel(fx)))));
if k<lim(1) || k>lim(2)
   h = 1;
   fprintf('Ôhe null hypothesis that the two samples came from the same distribution is rejeced\n');
else 
   fprintf('Ôhe null hypothesis that the two samples came from the same distribution is accepted\n');
end


