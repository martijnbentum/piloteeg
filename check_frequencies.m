function [freqs,periodogram] = check_frequencies(Sr,sig)
% creates a periodogram based on explanation in the advanced math matlab lecture notes

N = length(sig);
if mod(N,2) == 1%make sure n is of even number of samples lenth
	N = N - 1;
end

fftoutnorm = fft(sig)/N;
n_pos_freq = N/2+1; 
fft_onpf = fftoutnorm(1:n_pos_freq);
periodogram = fft_onpf.*conj(fft_onpf);
Nyq = Sr/2;
duration = N/Sr;
freqs = 0:(1/duration):Nyq;
%plot(freqs,periodogram);

