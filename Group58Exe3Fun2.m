%Efseveia Nestoropoulou
%Christina Koutsi

%% Finds the Difference of Positivity Rates Of Europe and Greece
function [conf_Gr,diff] = Group58Exe3Fun2(PR_Day_Gr,PR_Eu)

    B=1000;
    conf_Gr = bootci(B,@mean,PR_Day_Gr);
    %  lower_limit=conf_Gr(1,1)
    %  upper_limit=conf_Gr(2,1)

    if PR_Eu < conf_Gr(1,1)
        fprintf('The Difference of P_R of Europe and P_R of Greece is significant \n')
        diff = PR_Eu - conf_Gr(1,1);
        fprintf('PosRate of Europe is smaller than PosRate of Greece by: %f \n \n',diff)
    elseif  PR_Eu > conf_Gr(2,1)
        fprintf('The Difference of P_R of Europe and P_R of Greece is significant \n')
        diff = PR_Eu - conf_Gr(2,1);
        fprintf('PosRate of Europe is greater than PosRate of Greece by: %f \n \n',diff)
    else
        fprintf('The Difference of P_R of Europe - P_R of Greece is not significant \n')
         diff = PR_Eu - conf_Gr(2,1);
         fprintf('Positivity Rate of Europe differs from Positivity Rate of Greece by: %f \n \n',diff)
    end

end


