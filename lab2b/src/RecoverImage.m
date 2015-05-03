function [ image ] = RecoverImage( vector )
%RECOVERIMAGE Recovers square grayscale image from flattened vector
%   Detailed explanation goes here

width = sqrt(numel(vector));

image = zeros(width);

elem = 1;
for j = 1:width
    for i = 1:width
        image(i,j) = vector(elem);
        elem = elem + 1;
    end;
end;

end

