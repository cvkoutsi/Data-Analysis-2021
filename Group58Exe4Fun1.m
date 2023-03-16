%Efseveia Nestoropoulou
%Christina Koutsi

%% Finds the positivity rate for W42-50 for the desired year and country
function [temp] = Group58Exe4Fun1(year1,country,raw,ECDC)
    year = num2str(year1);
    date= append(year,'-W42');
    temp=zeros(9,1);
    for i = 1:length(raw)
       if strcmp(raw(i,4),'national') && strcmp(raw(i,1),country)&& strcmp(raw(i,3),date)
            for j=1:9
              temp(j) = ECDC(i+j-2,5);
            end
        end
    end
end
