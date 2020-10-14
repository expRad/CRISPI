function [g_shifted] = pre_emphasis (g_input)

G_in = fft_1dim(g_input,1); % FFT to frequency domain

N2 = length(G_in); 

%%%%%%%% Here the example GSTF magnitude / phase / fit is loaded %%%%%%%%%%

%%%%%%%% The fit serves only the purpose of a decaying function %%%%%%%%%
%%%%%%%% for high frequencies of the inverted GSTF magnitude %%%%%%%%%%

load('GSTF_magnitude.mat'); 
load('GSTF_phase.mat'); 
load('fit_magnitude.mat');  

Cut_Off = 500; % point of frequency cut off; 500 corresponds to 12.2 kHz
fit_magnitude(((N2/2)-Cut_Off):((N2/2)+Cut_Off)) = 1./GSTF_magnitude(((N2/2)-Cut_Off):((N2/2)+Cut_Off)); 

%%% dependent on how the GSTF was acquired and calculated (dwell-time etc.), an additional 
%%% global delay identical for all axes could be needed, which e.g. can be implemented at this position
factor = -3.0;
line = linspace(-0.5,0.5,N2).';
AbsPh = line * pi * factor;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

G_in_new = G_in.*fit_magnitude.*exp((-1)*(GSTF_phase + AbsPh) *1i); % Here the pre-emphasis correction takes place

g_in_new = ifft_1dim(G_in_new,1); % iFFT to time domain

g_shifted = real(g_in_new);

end

    
        