function [y] = einh(x,x_0)

y = zeros(1,size(x,2));

for i=1:size(x,2)
    
    if x(i)<-x_0
        y(i) = x_0/(4*x(i)^2);

    elseif x(i)>x_0
        y(i) = x_0/(4*x(i)^2);

    else
        y(i) = 1/(4*x_0);
    end

end