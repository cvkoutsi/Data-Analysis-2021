%Christina Koutsi 
%Efseveia Nestoropoulou

function [PR_Gr] = Group58Exe6Fun2(EODY)
    week=38;
    l=1;
    j=1;
    PR_Day_Gr=zeros(13);
    PR_Gr=zeros(13,1);
    for i = ((week-1)*7+291):((week+13)*7+283)
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

    for a=1:7:85
        PR_Gr(j,1) = mean(PR_Day_Gr(a:a+6));
        j=j+1;
    end

end

