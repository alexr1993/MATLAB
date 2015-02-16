%% General Process (from http://graphics.cs.cmu.edu/courses/15-463/2005_fall/www/Lectures/Pyramids.pdf)
%{
1. Build Laplacian pyramids LA and LB from images A and B
2. Build a Gaussian pyramid GR from selected region R
3. Form a combined pyramid LS from LA and LB using nodes
of GR as weights: LS(i,j) = GR(I,j,)*LA(I,j) + (1-GR(I,j))*LB(I,j)
4. Collapse the LS pyramid to get the final blended image
%}

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
LA = LaplacianPyramid(im1, pyrHeight, false);
LB = LaplacianPyramid(im2, pyrHeight, false);
GR = GaussianPyramid(mean(mask,3), pyrHeight, false);
% Blend images

[nRows, nCols, nBands] = size(im1);

imc = zeros(nRows, nCols, nBands);

output = zeros(nRows, nCols, nBands);
% for each level of the pyramid, combine the convoluted images (lecture3)
for i = 1:pyrHeight
    for j = 1:nBands
        imc = LA{i} .* GR{i} + LB{i} .* (1-GR{i});
    end;
    figure; imshow(imc);
    output = output + imc;
end;

% Output result
output=output/4;
figure; imshow(output);
