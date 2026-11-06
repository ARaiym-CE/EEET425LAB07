%EEET 425 LAB07 q4

s3 = sqrt(3); %shorthand for root 3
gL = (1/(4*sqrt(2))) * [1+s3, 3+s3, 3-s3, 1-s3]; %reconstruction lowpass
gH = (1/(4*sqrt(2))) * [1-s3, -(3-s3), 3+s3, -(1+s3)]; %reconstruction highpass
hL = fliplr(gL); %decomposition lowpass, hL(n) = gL(-n)
hH = fliplr(gH); %decomposition highpass, hH(n) = gH(-n)

load kobe; %loads the kobe earthquake data
x = kobe(:)'; %input signal x(k), forced into a row vector
figure;
plot(x); % kobe earthquake signal

stages = 5; %number of decomposition stages
c = cell(1, stages); %approximation coefficients c1 to c5
d = cell(1, stages); %detail coefficients d1 to d5
len = zeros(1, stages); %input length of each stage, needed for reconstruction
s = x; %input of the first stage is x(k)
for i = 1:stages
    len(i) = length(s); %remember the length of this stage input
    full_c = conv(s, hL); %filter with hL
    full_d = conv(s, hH); %filter with hH
    c{i} = full_c(2:2:end); %downsample by 2, keeps every nonzero output
    d{i} = full_d(2:2:end); %downsample by 2
    s = c{i}; %c_i is the input of the next stage
end

r = c{stages}; %reconstruction starts from c5
for i = stages:-1:1
    up_c = zeros(1, 2 * length(r)); %upsample by 2, c side
    up_c(1:2:end) = r; %zeros between the samples
    up_d = zeros(1, 2 * length(d{i})); %upsample by 2, d side
    up_d(1:2:end) = d{i};
    full_r = conv(up_c, gL) + conv(up_d, gH); %filter with gL and gH, then add
    r = full_r(3:2 + len(i)); %trim back to the length of the stage input
end
y = r; %output signal y(k)

max(abs(x - y)) %check, should be basically zero

figure;
plot(x); %x(k)
for i = 1:stages
    figure;
    plot(c{i}); %c_i(k)
end
for i = 1:stages
    figure;
    plot(d{i}); %d_i(k)
end
figure;
plot(y); %y(k)