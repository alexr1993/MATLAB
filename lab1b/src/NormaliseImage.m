function imn = NormaliseImage(im)

mx = max(im(:));
mn = min(im(:));

% adjust so minimum is 0 and maximum is 1
imn = im/mx;

for i = 1:numel(im)
    if imn(i) < 0
        imn(i) = 0;
    end
end