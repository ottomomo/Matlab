function [C] = lab10function2(A,B)

C=zeros(1000,1000);

    for i=1:1000
        for j=1:1000
          C(i,j)=A(i,j)^B(i,j);
        end
    end
end

