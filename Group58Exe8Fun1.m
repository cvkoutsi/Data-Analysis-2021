%Efseveia Nestoropoulou
%Christina Koutsi
%% Returns Positivity Rate of Greece per day and per week
    %positivity_rate = (positive tests)/(total tests) x 100%
    
function [PR_Day_Gr] = Group58Exe8Fun1(index,year,EODY)

    i=index+1;
    
    if year == 2020
        positive_tests = EODY(i,2);

        if isnan(EODY(i,45))
            total_tests = EODY(i,46)-EODY(i-1,46);
        elseif isnan(EODY(i-1,46))
             total_tests = EODY(i,45)-EODY(i-1,45);
        else
            total_tests = (EODY(i,45)-EODY(i-1,45))+(EODY(i,46)-EODY(i-1,46));
        end
        PR_Day_Gr = (positive_tests/total_tests)*100;
        l=1;
    elseif year == 2021
        positive_tests = EODY(i-1,2);

        if isnan(EODY(i-1,45))
            total_tests = EODY(i-1,46)-EODY(i-2,46);
        elseif isnan(EODY(i-1,46))
            total_tests = EODY(i-1,45)-EODY(i-2,45);
        else
            total_tests = (EODY(i-1,45)-EODY(i-2,45))+(EODY(i-1,46)-EODY(i-2,46));
        end
        PR_Day_Gr = (positive_tests/total_tests)*100;
        
    end
end