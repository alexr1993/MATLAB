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

if tembands ~= imbands
    disp('Template and image have differing numbers of bands, aborting correlation');
end;

normx = zeros(temheight*temwidth, tembands);
for i = 1:tembands
    x = template(:,:,i);
    x = x(:);
    mx = mean(x);
    normx(:,i) = x - mx;
end;

r = zeros(imheight, imwidth);

halfheight = floor(temheight/2);
halfwidth = floor(temwidth/2);

% Correlate for each cell in matrix
for band = 1 : imbands
    for i = 1 : ((imwidth - temwidth) - 1) % for each column
        for j = 1 : ((imheight - temheight) - 1) % for each row
            y = im(j:j+temheight-1, i:i+temwidth-1, band);
            y = y(:);

            % Set value of pixel, for the one in the centre of the template
            normy = y - mean(y);
            r(j+halfheight,i+halfwidth) ...
                = r(j+halfheight, i+halfwidth) + (normx(:,band)' * normy) ...
                    / (norm(normx(:,band)) * norm(normy));
        end;
    end;
end;