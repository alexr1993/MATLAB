% BoundaryEffects.m

im = imread('glove.jpg');
im = mean(im,3)/255;

padSize = 10;
%im = padarray(im, [padSize padSize], 'replicate');

k = [1 6 15 20 15 6 1]/64;
im = conv2(k, k, im, 'valid');

figure;imshow(im);