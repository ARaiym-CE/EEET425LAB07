%EEET 425 LAB07
s3 = sqrt(3); %shorthand for root 3
gL = (1/(4*sqrt(2))) * [1+s3, 3+s3, 3-s3, 1-s3]; %reconstruction lowpass, q1
gH = (1/(4*sqrt(2))) * [1-s3, -(3-s3), 3+s3, -(1+s3)]; %reconstruction highpass, q1
hL = fliplr(gL); %decomposition lowpass, hL(n) = gL(-n)
hH = fliplr(gH); %decomposition highpass, hH(n) = gH(-n)

[HL, w] = freqz(hL, 1, 512); %frequency response of hL, w from 0 to pi
HH = freqz(hH, 1, 512); %frequency response of hH
GL = freqz(gL, 1, 512); %frequency response of gL
GH = freqz(gH, 1, 512); %frequency response of gH

S_hL = abs(HL).^2; %energy spectrum of hL
S_hH = abs(HH).^2; %energy spectrum of hH
S_gL = abs(GL).^2; %energy spectrum of gL
S_gH = abs(GH).^2; %energy spectrum of gH

figure;
plot(w/pi, S_hL); %part 2, energy spectrum of hL

figure;
plot(w/pi, S_hH); %part 2, energy spectrum of hH

figure;
plot(w/pi, S_gL); %part 2, energy spectrum of gL

figure;
plot(w/pi, S_gH); %part 2, energy spectrum of gH

figure;
plot(w/pi, S_hL + S_hH); %part 3, sum of decomposition spectra


figure;
plot(w/pi, S_gL + S_gH); %part 3, sum of reconstruction spectra
