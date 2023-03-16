%Efseveia Nestoropoulou
%Christina Koutsi

function [PR_Day_Gr,PR_Gr,PR_Eu] = Group58Exe3Fun1(week,year,EODY,ECDC,rawEU)
    %% Initialisation
    PR_Day_Gr= zeros(7,1);
    PR_Week_Europe = zeros(25,1);
    l = 1;
    k =1;

    %% Positivity Rate for Greece
    %positivity_rate = (positive tests)/(total tests) x 100%

    if year == 2020
        for i = ((week-1)*7+1):(week*7)
            positive_tests = EODY(i-1,2);

            if isnan(EODY(i-1,45))
                total_tests = EODY(i-1,46)-EODY(i-2,46);
            elseif isnan(EODY(i-1,46))
                 total_tests = EODY(i-1,45)-EODY(i-2,45);
            else
                total_tests = (EODY(i-1,45)-EODY(i-2,45))+(EODY(i-1,46)-EODY(i-2,46));
            end
            PR_Day_Gr(l) = (positive_tests/total_tests)*100;
            l = l+1;
        end
    elseif year == 2021
        for i = ((week-1)*7+288):(week*7+287)
            positive_tests = EODY(i-1,2);

            if isnan(EODY(i-1,45))
                total_tests = EODY(i-1,46)-EODY(i-2,46);
            elseif isnan(EODY(i-1,46))
                total_tests = EODY(i-1,45)-EODY(i-2,45);
            else
                total_tests = (EODY(i-1,45)-EODY(i-2,45))+(EODY(i-1,46)-EODY(i-2,46));
            end
            PR_Day_Gr(l) = (positive_tests/total_tests)*100;
            l = l+1;
        end
    end
    PR_Gr = mean(PR_Day_Gr);


    %% Positivity Rate for Europe
    
    if week<10
       if year == 2020
            date = append('2020-W0',num2str(week));
        elseif year == 2021
            date = append('2021-W0',num2str(week));
        end 
    else
        if year == 2020
            date = append('2020-W',num2str(week));
        elseif year == 2021
            date = append('2021-W',num2str(week));
        end
    end

    for i = 1:length(rawEU)
        if strcmp(rawEU(i,3),date)
            if strcmp(rawEU(i,4),'national')
                PR_Week_Europe(k) = ECDC(i-1,5);
                k=k+1;
            end
        end

    end
    PR_Eu= mean(PR_Week_Europe);

end
