function pyr = LaplacianPyramid( im, height, show )
%LAPLACIANPYRAMID Summary of this function goes here
%   Detailed explanation goes here
    
    % Create gaussian pyramid
    gau = GaussianPyramid(im, height, false);
    pyr = cell(size(gau));
    
    len = length(gau(:));
    % Subtract images
    for i = 1:len
        % last image is not subtracted
        if i == len
            pyr{len} = gau{len};
            if show
                figure; imshow(pyr{len});
            end;
        else
            pyr{i} = NormaliseImage(gau{i+1} - gau{i});
            if show
                figure; imshow(pyr{i});
            end;
        end;

    end

end

