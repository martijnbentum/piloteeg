function output = filter_check()

% generate the signal and the corresponding time axis
s = zeros(1,1000); s(500) = 1; s = s - mean(s);
t = 0.001:0.001:1;

str = 'compare different filter orders (Butterworth)';
clear f
f(1,:) = s;
f(2,:) = ft_preproc_lowpassfilter(s, 1000, 50,4,'but');
f(3,:) = ft_preproc_lowpassfilter(s, 1000, 50,2); 
f(4,:) = ft_preproc_lowpassfilter(s, 1000, 50,3);

figure; 
subplot(1,2,1); 
plot(t, f-repmat((0:3)',1,1000)); grid on; set(gca, 'ylim', [-3.5 0.5]); xlabel('time (s)'); ylabel(str);
output = subplot(1,2,2); 
semilogy(abs(fft(f, [], 2).^2)'); grid on; set(gca, 'xlim', [0 500]); xlabel('freq (Hz)'); ylabel(str);

print -dpng fig7.png
