function output = frequency_analysis(cfg)
%maybe I need function to check whether filters have worked
%work in progress
cfg = [];
cfg.method = ‘mtmfft’; 
cfg.output = ‘pow’; 
cfg.foi = [1:30];

%matlab frequency plot
%----------------
Fs = 100;                      % samples per second
dt = 1/Fs;                     % seconds per sample
StopTime = 1;                  % seconds
t = (0:dt:StopTime-dt)';
N = size(t,1);
%% Sine wave:
Fc = 12;                       % hertz
x = cos(2*pi*Fc*t);
%% Fourier Transform:
X = fftshift(fft(x));
%% Frequency specifications:
dF = Fs/N;                      % hertz
f = -Fs/2:dF:Fs/2-dF;           % hertz
%% Plot the spectrum:
figure;
plot(f,abs(X)/N);
xlabel('Frequency (in hertz)');
title('Magnitude Response');
%----------------
