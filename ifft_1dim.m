function output = ifft_1dim(input,dimension)

output = ifftshift(ifft(ifftshift(input,dimension),[],dimension),dimension);

end
