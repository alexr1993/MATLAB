function pyr = GaussianPyramid(im, num, show)
imx = im;
k = [1 4 6 4 1]/16;


pyr = cell(1,num);

for i = 1:num
    scale = 2^(i-1);
    imscale = imresize(imx, scale); % scale back up to original size
    pyr{i} = imscale;

    if show
        figure; imshow(imscale);
    end
    
    imx = conv2(imx, k, 'same');
    imx = conv2(imx, k', 'same');

    % downsize
    imx = imresize(imx, 1/2, 'nearest');    
end;

% To read in an image, then convert it to grayscale
% imc = double(imread('tst.jpg'))/255;
% im = mean(imc, 3);
% figure; imshow(imc);
