% Efseveia Nestoropoulou
% Christina Koutsi

%% Clear workspace and load data
clear;
clc;
close all; 
[ECDC,txt,raw] = xlsread('ECDC-7Days-Testing.xlsx');

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

%%  Fit to Distributions

% 2020 Data

% Exponential Distribution
figure();
h = histogram(testData(:,1));
h.Normalization = 'pdf';
h.BinMethod = 'fd';
h.FaceColor = [0 0.5 0.5];
h.LineStyle = '--';
h.FaceAlpha = 0.7;
hold on;
pd  = fitdist(testData(:,1),'Exponential');
x = linspace(0,40,25);
y = pdf(pd,x);
plot(x,y,'LineWidth',2);
hold off;
title('Fit Exponential Distribution to 2020 Data');
xlabel('2020 Data');
ylabel('Probability Density Function (PDF)');
legend('2020 Data','Data fitted to Exponential Distribution');


% Normal Distribution
figure();
h = histogram(testData(:,1));
h.Normalization = 'pdf';
h.BinMethod = 'fd';
h.FaceColor = [0 0.5 0.5];
h.LineStyle = '--';
h.FaceAlpha = 0.7;
hold on;
pd  = fitdist(testData(:,1),'Normal');
x = linspace(0,40,25);
y = pdf(pd,x);
plot(x,y,'LineWidth',2);
hold off;
title('Fit Normal Distribution to 2020 Data');
xlabel('2020 Data');
ylabel('Probability Density Function (PDF)');
legend('2020 Data','Data fitted to Normal Distribution');

% Uniform Distribution
figure()
h = histogram(testData(:,1));
h.Normalization = 'pdf';
h.BinMethod = 'fd';
h.FaceColor = [0 0.5 0.5];
h.LineStyle = '--';
h.FaceAlpha = 0.7;
a = min(testData(:,1));
b = max(testData(:,1));
y = 1/(b-a);
hold on;
line([a b], [y y],'LineWidth',2,'Color', 'r');
hold off;
title('Fit Uniform Distribution to 2020 Data');
xlabel('2020 Data');
ylabel('Probability Density Function (PDF)');
legend('2020 Data','Data fitted to Uniform Distribution');


% 2021 Data
% Exponential Distribution
figure();
h = histogram(testData(:,2));
h.Normalization = 'pdf';
h.BinMethod = 'fd';
h.FaceColor = [0 0.5 0.5];
h.LineStyle = '--';
h.FaceAlpha = 0.7;
hold on;
pd  = fitdist(testData(:,2),'Exponential');
x = linspace(0,40,25);
y = pdf(pd,x);
plot(x,y,'LineWidth',2);
hold off;
title('Fit Exponential Distribution to 2021 Data');
xlabel('2021 Data');
ylabel('Probability Density Function (PDF)');
legend('2021 Data','Data fitted to Exponential Distribution');


% Normal Distribution
figure();
h = histogram(testData(:,2));
h.Normalization = 'pdf';
h.BinMethod = 'fd';
h.FaceColor = [0 0.5 0.5];
h.LineStyle = '--';
h.FaceAlpha = 0.7;
hold on;
pd  = fitdist(testData(:,2),'Normal');
x = linspace(0,40,25);
y = pdf(pd,x);
plot(x,y,'LineWidth',2);
hold off;
title('Fit Normal Distribution to 2021 Data');
xlabel('2021 Data');
ylabel('Probability Density Function (PDF)');
legend('2021 Data','Data fitted to Normal Distribution');

% Uniform Distribution
figure()
h = histogram(testData(:,2));
h.Normalization = 'pdf';
h.BinMethod = 'fd';
h.FaceColor = [0 0.5 0.5];
h.LineStyle = '--';
h.FaceAlpha = 0.7;
a = min(testData(:,2));
b = max(testData(:,2));
y = 1/(b-a);
hold on;
line([a b], [y y],'LineWidth',2,'Color', 'r');
hold off;
title('Fit Uniform Distribution to 2021 Data');
xlabel('2021 Data');
ylabel('Probability Density Function (PDF)');
legend('2021 Data','Data fitted to Uniform Distribution');

%% Conclusion

% From the plots of the fitted data to distributions it is aparent that the
% positivity rate of the European countries for the desired date of 2020 fits
% better to the exponential distribution and the 2021 data fit better to
% the normal distribution.