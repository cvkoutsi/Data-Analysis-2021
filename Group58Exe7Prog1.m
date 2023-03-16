%Efseveia Nestoropoulou
%Christina Koutsi

%% Prosoxh!!! 
% Ta arxeia excel einai tropopoihmena epomenws tha prepei na fortwthoun kai
% auta gia thn ektelesh twn programmatwn
%% Clear workspace and load data
clear;
clc;
close all; 
[ECDC,txt1,raw] = xlsread('ECDC-7Days-Testing.xlsx');

%% First period 21/02/2021- 06/06/2021 
% Second period 5/09/2021- 19/12/2021

%21/02/2021->8th week of 2021
%06/06/2021->23th week of 2021

%5/09/2021->36th week of 2021
%19/12/2021->51th week of 2021

deaths = zeros(16,2);
deaths(:,1) = [115 127 119 125 91 80 101 98 99 66 51 45 34 11 9 13];
deaths(:,2) = [1 2 2 4 15 11 22 12 23 41 60 59 77 102 94 120];
starting_week = [8 36];
n = length(deaths);
for j = 1:2
    for i = 1:5
        figure();
        hold on;
        posRate = Group58Exe7Fun1(starting_week(j)-i,'Slovakia',raw,ECDC);
        scatter(posRate,deaths(:,j));

        x = posRate;
        y = deaths(:,j);
        mu_x = mean(x);
        mu_y = mean(y);

        %b0 ->1h sthlh, b1 ->2h sthlh
        bi(:) = regress(y,[ones(n,1) x]);
        b0 = bi(1);
        b1 = bi(2);
        ybar = b0 + b1*x;
        plot(x,ybar);

        covar = cov(x,y);
        s_xy = covar(1,2);
        s_x_2 = covar(1,1);
        s_y_2 = covar(2,2);
        s_xx = s_x_2 * (n-1);

        s_e = sqrt((n-1)*(s_y_2 - b1^2*s_x_2)/(n-2));
        s = s_e*sqrt(1 + (1/n) + ((x-mu_x).^2)/s_xx);

        alpha = 0.05;
        t = tinv(1-alpha/2,n-2);
        CI_Ylow = ybar-t*s;
        CI_Yup = ybar+t*s;
        plot(x,CI_Ylow);
        plot(x,CI_Yup);

        e = y - ybar;
        R2 = 1-(sum(e.^2))/(sum((y-mu_y).^2));
        adjR2 =1-((n-1)/(n-2))*(sum(e.^2))/(sum((y-mu_y).^2));

        dim = [.6 .01 .3 .3];
        str1 = 'Rsq = ' + string(R2);
        str2 = ' adjRsq = ' + string(adjR2);
        str = strcat(str1,str2);
        annotation('textbox',dim, 'String',str,'FitBoxToText','on');

        hold off;
        grid on;

        xlabel('Positivity Rate')
        ylabel('Deaths per millions');
        legend('Scatter Plot','Estimated linear model','Weekly Deaths CI- Lower Limit','Weekly Deaths CI- Upper Limit');
        
        if j==1
            title(['[1st Period] Linear model of deaths per millions - positivity rate of ' num2str(i) ' weeks before']);
        else 
            title(['[2nd Period] Linear model of deaths per millions - positivity rate of ' num2str(i) ' weeks before']);

        end
    end
end

%% Conclusions
%Opws parathroume kai apo ta diagrammata, kalutero adjRsq petuxainoume gia thn
%prwth periodo sto grammiko montelo thanatwn-deikth thetikothtas 4
%evdomadwn prin, enw gia thn deuterh periodo kalutero adjRsq petuxainoume gia
%grammiko montelo thanatwn-deikth thetikothtas 5 evdomadwn prin. Kai gia
%tis duo periodous fainetai na exoume kaluterh prosarmogh grammikou
%montelou gia megaluterh usterhsh evdomadas tou deikth thetikothtas.