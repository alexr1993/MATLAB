function [ resp ] = CorrelateEigenFaces( im, faces, mu )
%CORRELATEEIGENFACES Maps image patches into eigenspace and checks response
%   Detailed explanation goes here
patch_size = 32; % 32 x 32
half_size = patch_size/2;
[height, width, bands] = size(im);
resp = zeros(height, width);

% Mean normalise image
%k = ones(patch_size) / (patch_size*patch_size);
%mean_im = filter2(k, im, 'same');
%im = im - mean_im;

i = 1;
while i <= ((width - patch_size) - 1) % for each column
    j = 1;
    while j <= ((height - patch_size) - 1) % for each row
        y = im(j:j+patch_size-1, i:i+patch_size-1);
        y = y(:);

        % Mean normalise
        y = y - mu';

        % Calc y in eigenspace
        %projection = faces * y; % gives nfaces x ncomponents vec
        
        projected_face = zeros(patch_size*patch_size, 1)';
        weights = faces * y;
        for ki = 1:size(faces,1)
            projected_face = projected_face + weights(ki,:) * faces(ki,:);
        end;
        resp(j+half_size,i+half_size) = 1 - norm(y - projected_face');
        j = j + 1;
    end;
    i = i + 1;
end;

resp = resp - min(resp(:));
resp = resp ./ max(resp(:));

disp('[ Calculated Response to Eigenfaces ]');

