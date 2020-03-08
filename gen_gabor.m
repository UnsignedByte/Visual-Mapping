function gabor = gen_gabor(size, num, stdev, contrast, dir)
    stdev = stdev * size;
    x = -size:size;
    y = -size:size;
    [X, Y] = meshgrid(x,y);
    1/(2*pi*stdev^2)*exp(-(X.^2+Y.^2)/(2*stdev^2));
    gaussian = 1/(2*pi*stdev^2)*exp(-(X.^2+Y.^2)/(2*stdev^2)); %gaussian curve
    gaussian = 1/max(gaussian, [], 'all')*gaussian; %max 1
    Z = cos((X*cos(dir)-Y*sin(dir))*2*pi*num/(size*2)).*gaussian;
    gabor = repmat(uint8(Z*128*contrast+128), [1 1 3]);
end