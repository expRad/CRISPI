function output = fft_1dim(input,dimension)

output = fftshift(fft(fftshift(input,dimension),[],dimension),dimension);

end