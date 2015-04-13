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

% Calculate mean normalised image and it's norm (over patches the size of the template)
disp('[ Performing Normalised Cross-Correlation ]');
sumtemplate = ones(temheight, temwidth);
meantemplate = sumtemplate ./ (temheight * temwidth);

for band = 1 : imbands
    % Calculate template norm and mean-norm
    x = template(:,:,band);
    mx = mean(x(:));
    templatenormalised = x - mx;
    templatedenom = norm(templatenormalised(:));
    
    % Find the mean of each template patch in the image
    imagemean = filter2(meantemplate, im(:,:,band), 'same');
    meannormalised = im(:,:,band) - imagemean;
    
    % Find norm over all image patches with square filter then root
    sumofsquares = filter2(sumtemplate, meannormalised .^ 2, 'same');
    imagedenom = sqrt(sumofsquares);
    
    resp = filter2(templatenormalised, meannormalised, 'same');
    resp = resp ./ (templatedenom .* imagedenom);
    r = r + resp;
end;