function [ resp ] = EigenFaces( im, trainingdata )
%EIGENFACES Returns response of image when compared with eigenfaces of
%training data
%   Detailed explanation goes here

[V, D] = eig(trainingdata);

% TODO PCA to find high-variance features


end

