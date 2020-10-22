function [C] = lab10function(A,B)

    for i=1:1000
        for j=1:1000
         C(i,j)=A(i,j)^B(i,j);
        end
    end
end

