% Efseveia Nestoropoulou
% Christina Koutsi
% Corresponding country: Slovakia

%% Finds the day of maximum Positivity Rate for Slovakia

function [date_20,date_21] = Group58Exe1Fun1(ECDC,raw)
    
    max_PR=0; %initianize the maximum positivity rate in 2020 to 0
    max_PR2=0; %initianize the maximum positivity rate in 2021 to 0
    date_20=' '; %initialize tha date that the positivity rate is maximum for 2020
    date_21=' '; %initialize tha date that the positivity rate is maximum for 2021
    
    for i = 1:length(raw)
        %search data from national level testing for Slovakia in the last 6
        %weeks of 2020 and find the maximum positivity rate for those weeks
        if strcmp(raw(i,4),'national') && strcmp(raw(i,1),'Slovakia')&& strcmp(raw(i,3),'2020-W45')
            for j=1:6
                temp = ECDC(i+j-2,5);
                if temp > max_PR
                    max_PR= temp;
                    week=44+j;
                    date_20 = append('2020-W',num2str(week));
                end
            end
        end
         %search data from national level testing for Slovakia the last 6
         %weeks of 2021  and find the maximum positivity rate for those weeks
         if strcmp(raw(i,4),'national') && strcmp(raw(i,1),'Slovakia')&& strcmp(raw(i,3),'2021-W45')
            for j=1:6
                temp = ECDC(i+j-2,5);
                if temp > max_PR2
                    max_PR2= temp;
                    week=44+j;
                    date_21 = append('2021-W',num2str(week));
                end
            end
         end
    end

end

