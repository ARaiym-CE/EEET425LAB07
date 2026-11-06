%EEET 425 LAB07 q10

close all;

s3 = sqrt(3); %shorthand for root 3
gL = (1/(4*sqrt(2))) * [1+s3, 3+s3, 3-s3, 1-s3]; %reconstruction lowpass
gH = (1/(4*sqrt(2))) * [1-s3, -(3-s3), 3+s3, -(1+s3)]; %reconstruction highpass
hL = fliplr(gL); %decomposition lowpass, hL(n) = gL(-n)
hH = fliplr(gH); %decomposition highpass, hH(n) = gH(-n)

load kobe; %loads the kobe earthquake data
x = kobe(:)'; %input signal x(k), forced into a row vector

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

N1 = length(d{1}); %N, length of d1
T = sqrt(2 * log(N1)) * median(abs(d{1})) / 0.6745 %threshold from d1
d_hard = cell(1, stages); %hard thresholded details
for i = 1:stages
    d_hard{i} = zeros(1, length(d{i})); %preallocate output for this stage
    for k = 1:length(d{i})
        if d{i}(k) > T
            d_hard{i}(k) = d{i}(k); %keep d if d>T
        elseif d{i}(k) < -T
            d_hard{i}(k) = d{i}(k); %keep d if d<-T
        else
            d_hard{i}(k) = 0; %0 else
        end
    end
end

r = c{stages}; %reconstruction starts from c5, c is not thresholded

for i = stages:-1:1
    up_c = zeros(1, 2 * length(r)); %upsample by 2, c side
    up_c(1:2:end) = r; %zeros between the samples
    up_d = zeros(1, 2 * length(d_hard{i})); %upsample by 2, d side
    up_d(1:2:end) = d_hard{i};
    full_r = conv(up_c, gL) + conv(up_d, gH); %filter with gL and gH, then add
    r = full_r(3:2 + len(i)); %trim back to the length of the stage input
end

y_compression = r; %part 10, compressed output
figure;
plot(y_compression); %part 10, hard thresholded output