%

relu = @(x) max(0, x);

circconv = @(x, y) real(ifft(fft(x) .* fft(y)));

round2 = @(x) round(x/2)*2;

% s=0;k=0; for j=0:length(x)-1; s+=x(j+1)*y(mod(k-j,length(y))+1); end; s

% for colormaps
addpath('/home/xyy/matcode/color_sci/');

