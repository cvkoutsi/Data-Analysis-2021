%Christina Koutsi 
%Efseveia Nestoropoulou

function [temp] = Group58Exe6Fun1(country,raw,ECDC)

    temp=zeros(13,1);
    
    for i = 1:length(raw)
       if strcmp(raw(i,4),'national') && strcmp(raw(i,1),country) && strcmp(raw(i,3),'2021-W38')
           for j=1:13
              temp(j) = ECDC(i+j-2,5);
            end
        end
    end

end