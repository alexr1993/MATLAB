function [ r ] = NormCorr( im, template )
%NORMCORR normalised cross-correlation of image imf with template
%
% Implementation of normalised correlation as seen in lab sheet
%
% r = (x - m_x1)^T (y - m_y1) / |x - m_x1||y - m_y1|
% dot product is essentially correlation
% aim for about 50% overlap
% the mean to subtract is the mean from the image patch, not the whole img

% reimplement this with a mean filter
[temheight, temwidth, tembands] = size(template);
[imheight, imwidth, imbands] = size(im);
r = zeros(imheight, imwidth);

if tembands ~= imbands
    disp('Template and image have differing numbers of bands, aborting correlation');
    return;
end;

disp('Calculating template mean and norm');
% Calculate mean normalised template and its norm
templatenormalised = zeros(temheight, temwidth, tembands);
for i = 1:tembands
    x = template(:,:,i);
    mx = mean(x(:));
    templatenormalised(:,:,i) = x - mx;
end;
templatedenom = norm(sqrt(sum(templatenormalised(:) .^ 2)));

% Calculate mean normalised image and it's norm (over patches the size of the template)
disp('Calculating image mean and norm');
sumtemplate = ones(imheight, imwidth);
meantemplate = sumtemplate ./ numel(template(:,:,1));

for band = 1 : imbands
    % Find the mean of each template patch in the image
    imagemean = filter2(meantemplate, im(:,:,band), 'same');

    meannormalised = im(:,:,band) - imagemean;

    sumofsquares = filter2(sumtemplate, im(:,:,band) .^ 2, 'same');
    imagedenom = sqrt(sumofsquares);

    r = r + filter2((template(:,:,band) ./ templatedenom)', meannormalised ./ imagedenom, 'same');

end;