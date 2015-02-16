% Load images

im1 = double(imread('../data/polarbear.jpg'))/255;
im2 = double(imread('../data/penguins.jpg'))/255;
im1 = mean(im1,3);
im2 = mean(im2,3);

%im1 = double(imread('../data/andy.jpg'))/255;
%im2 = double(imread('../data/kajiya.jpg'))/255;

% Set blending masks

figure; imshow(im1);
mask = roipoly;
close;

pyrHeight = 4;
pyr1 = LaplacianPyramid(im1, pyrHeight, false);
pyr2 = LaplacianPyramid(im2, pyrHeight, false);

% Blend images

[nRows, nCols, nBands] = size(im1);

imc = zeros(nRows, nCols, nBands);

output = zeros(nRows, nCols, nBands);
% for each level of the pyramid, combine the convoluted images (lecture3)
for i = 1:pyrHeight
    im1 = pyr1{1};
    im2 = pyr2{2};
    for i = 1:nBands
        imc(:, :, i) = im1(:, :, i) .* mask + im2(:, :, i) .* (1-mask);
    end;
    output = output + imc;
end;
% Output result

figure; imshow(imc);
