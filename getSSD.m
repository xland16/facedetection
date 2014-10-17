function [SSD] = getSSD(S,T);
[Sm Sn] = size(S);
[Tm Tn] = size(T);

% Flip the template
T = fliplr(flipud(T));

% Create mask of ones of size T and dot multiply it with itself
T1 = ones(Tm, Tn);
T2 = T.*T;

% Calculate the sum of the elements of T squared
sum = 0;
for a = 1:Tm
    for b = 1:Tn
        sum = sum + T2(a,b);
    end
end

if mod(Sm,2) ~= 0
    S = padarray(S,[1 0],0,'post');
end
if mod(Sn,2) ~= 0
    S = padarray(S,[0 1],0,'post');
end
if mod(Tm,2) ~= 0
    T = padarray(T,[1 0],0,'post');
    T1 = padarray(T1,[1 0],0,'post');
end
if mod(Tn,2) ~= 0
    T = padarray(T,[0 1],0,'post');
    T1 = padarray(T1,[0 1],0,'post');
end

% Find the next highest power of 2 to pad the matrices to
m = pow2(nextpow2(Sm+2*Tm));
n = pow2(nextpow2(Sn+2*Tn));

% Find the padlength in one direction for S
i = floor((m-Sm)/2);
j = floor((n-Sn)/2);

% Pad S
S = padarray(S,[i j]);

% Find the padlength in one direction for T and the mask
h = floor((m-Tm)/2);
k = floor((n-Tn)/2);

% Pad T and the mask
T = padarray(T,[h k]);
T1 = padarray(T1,[h k]);

% Fourier transform the matrices
S = fftshift(S);
fS = fft2(S);
fT = fft2(T);
fS2 = fft2(S.*S);
f1 = fft2(T1);

% Perform convolution and inverse Fourier the results
c1 = -2*ifft2(fS.*fT);
c2 = ifft2(fS2.*f1);

% Add convolutions with the sum of T's elements squared to get the SSD's
SSD = c1+c2+sum;

% De-pad the matrix of the SSD's
SSD = SSD(i+1:i+Sm,j+1:j+Sn);

end