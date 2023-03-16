%Efseveia Nestoropoulou
%Christina Koutsi

function [temp] = Group58Exe7Fun1(week,country,raw,ECDC)

    if week<10
        week = append('0',num2str(week));
    else
        week = num2str(week);
    end
    date = append('2021-W',week);
    temp=zeros(16,1);
    for i = 1:length(raw)
       if strcmp(raw(i,4),'national') && strcmp(raw(i,1),country)&& strcmp(raw(i,3),date)
            for j=1:16
              temp(j) = ECDC(i+j-2,5);
            end
        end
    end
end
