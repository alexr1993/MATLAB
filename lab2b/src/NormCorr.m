function [ r ] = NormCorr( imf, template )
%NORMCORR normalised cross-correlation of image imf with template
%
% Implementation of normalised correlation as seen in lab sheet
%
% r = (x - m_x1)^T (y - m_y1) / |x - m_x1||y - m_y1|
% dot product is essentially correlation
% aim for about 50% overlap
% the mean to subtract is the mean from the image patch, not the whole img
x = template(:);
mx = mean(x);
normx = x - mx;
magx = sqrt(sum(normx .^ 2));
% reimplement this with a mean filter
[temheight, temwidth] = size(template);
[imheight, imwidth] = size(imf);
r = zeros(size(imf));

halfheight = floor(temheight/2);
halfwidth = floor(temwidth/2);

% Correlate for each cell in matrix
for i = 1 : ((imwidth - temwidth) - 1) % for each column
    for j = 1 : ((imheight - temheight) - 1) % for each row
        y = imf(j:j+temheight-1, i:i+temwidth-1);
        y = y(:);
        
        % Set value of pixel, for the one in the centre of the template
        normy = y - mean(y);
        magy = sqrt(sum(normy .^2));
        r(j+halfheight,i+halfwidth) = (normx' * normy) / (magx * magy);
    end;
end