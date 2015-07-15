function [rho] = autocorr(x,t_max)

Nx = numel(x);

%fft_x = fft(x(1:(Nx-t_max)));
x_padding = zeros(t_max,1);
fft_x = fft([x;x_padding]);
fft_x = abs(fft_x).^2;
cov_x = ifft(fft_x);

rho = zeros(1,t_max);

for t = 0:t_max
    x1 = 1:Nx-t;
    x2 = t+1:Nx;
    
    x_MW = 1/(Nx-t)*sum(x(x1));
    y_MW = 1/(Nx-t)*sum(x(x2));
    
    var_x = sum((x(x1)-x_MW).^2);
    var_y = sum((x(x2)-y_MW).^2);
    
    %rho(t) = cov_x(t)./(sqrt(var_x*var_y));
    rho(t+1) = (cov_x(t+1)-(Nx-t)*x_MW*y_MW)./(sqrt(var_x*var_y));
     
end

% figure(f)
% semilogy(0:t_max-1,abs(rho),'-b');
% ylim([0 1]);
% xlabel('t');
% ylabel('rho(t)');