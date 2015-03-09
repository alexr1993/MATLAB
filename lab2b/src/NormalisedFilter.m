% NormalisedFilter.m

function resp = NormalisedFilter(im, template)

% computes dot product of template with image at each position
% normalising by the norm of the image under the template

% Note that im and template must have the same number of bands

doNormalise = 1;

[imRows, imCols, nBands] = size(im);
[tRows, tCols, nBands] = size(template);

% compute dot product of template and image
dotProd = zeros(imRows, imCols);
for i = 1:nBands
    dotProdi = filter2(template(:, :, i), im(:, :, i), 'same');
    dotProd = dotProd + dotProdi;
end;

if (~doNormalise)
    resp = dotProd;
else    
    ksum = ones(tRows, tCols);
    
    % compute sum(im.^2) over template
    imsq = im.^2;
    imsumsq = zeros(imRows, imCols);
    for i = 1:nBands
        imsumsqi = filter2(ksum, imsq(:, :, i), 'same');
        imsumsq = imsumsq + imsumsqi;
    end;
    
    % compute sum(im) over template
    imsum = zeros(imRows, imCols);
    for i = 1:nBands
        imsumi = filter2(ksum, im(:, :, i), 'same');
        imsum = imsum + imsumi;
    end;
    
    % compute normalised correlation
    n = tRows*tCols*nBands;
    small = 0.0001;
    tempnorm = sqrt(max(small, sum(template(:).^2)));
    imnorm = sqrt(max(small, imsumsq - (imsum.^2)/n));
    
    denom = max(0.5*tempnorm, imnorm); % suppress responses in textureless areas
    resp = dotProd ./ denom;    
end;