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
            if ~isequal(size(gau{i}),size(gau{i+1}))
                disp('Given Pyramid size is too large, image distorted');
                return
            end;
            pyr{i} = NormaliseImage(gau{i} - gau{i+1});
            if show
                figure; imshow(pyr{i});         
            end;
        end;

    end

end

