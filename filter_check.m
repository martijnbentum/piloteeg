function output = filter_check()

output = [];
% generate the signal and the corresponding time axis
s = zeros(1,1000); s(500) = 1; s = s - mean(s);
t = 0.001:0.001:1;

str = 'compare dif filters and orders (Butterworth firws)';
clear f
%f(1,:) = s;
f(1,:) = ft_preproc_lowpassfilter(s, 1000, 1,[],'but');
f(2,:) = ft_preproc_lowpassfilter(s, 1000, 0.05,4,'but');
f(3,:) = ft_preproc_lowpassfilter(s, 1000, 0.1,4); 
f(4,:) = ft_preproc_lowpassfilter(s, 1000, 0.5,4,'but');
f(5,:) = ft_preproc_lowpassfilter(s, 1000, 0.1,[],'firws');

figure; 
%subplot(1,2,1); 
%plot(t, f-repmat((0:3)',1,1000)); grid on; set(gca, 'ylim', [-3.5 0.5]); xlabel('time (s)'); ylabel(str);
%subplot(1,2,2); 
output.h = semilogy(abs(fft(f, [], 2).^2)'); grid on; set(gca, 'xlim', [0 9]); xlabel('freq (Hz)'); ylabel(str);
legend('1hz default but','0.05hz order4 but','0.1hz order4 but','0.5hz order4 but','0.1hz dfault firws');
print -dpng filter_comparison.png
output.f = f;
output.t =t;
output.s =s;
