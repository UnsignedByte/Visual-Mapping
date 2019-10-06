function gabor = gen_gabor(size, num, contrast, dir)
    x = -size:size;
    y = -size:size;
    [X, Y] = meshgrid(x,y);
    Z = cos((X*cos(dir)-Y*sin(dir))*2*pi*num/(size*2)).*max(0, size-abs(complex(X, Y)))/size;
    gabor = repmat(uint8(Z*128*contrast+128), [1 1 3]);
end