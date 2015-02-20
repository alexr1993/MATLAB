function [ im ] = ReconstructImage( pyr, show )
%RECONSTRUCTIMAGE Summary of this function goes here
%   Detailed explanation goes here
%   Combines images from laplacian pyramid to form original image
    im = zeros(size(pyr{1}));
    for i = 1:numel(pyr)
        im = im + pyr{i};
    end;
    im = im ./ numel(pyr); % normalise
    if show
        figure;imshow(im);
    end;
end

