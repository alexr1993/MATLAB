function imn = NormaliseImage(im)

mx = max(im(:));
mn = min(im(:));

% adjust so minimum is 0 and maximum is 1
imn = im - mn;
imn = imn / (mx-mn);