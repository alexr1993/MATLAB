function [ r ] = normcorr( template, imf )
%NORMCORR normalised cross-correlation of image imf with template
%
% Implementation of normalised correlation as seen in lab sheet
%
% r = (x - m_x1)^T (y - m_y1) / |x - m_x1||y - m_y1|
%
x = template(:);
mx = mean(x);
normx = x - mx;
magx = norm(normx);

[temheight, temwidth] = size(template);
[imheight, imwidth] = size(imf);
r = zeros(size(imf));

% Correlate for each cell in matrix
for i = 1 : ((imwidth - temwidth) - 1) % for each column
        for j = 1 : ((imheight - temheight) - 1) % for each row
        y = imf(j:j+temheight-1, i:i+temwidth-1);
        y = y(:);
        
        normy = y - mean(y);
        r(j,i) = normx' * normy / (magx * norm(normy));
    end;
end