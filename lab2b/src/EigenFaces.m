function [ resp ] = EigenFaces( im, training_data )
%EIGENFACES Returns response of image when compared with eigenfaces of
%training data
%   trainingdata must be an nPerson x nExample cell array containing 
[nPerson, nExample] = size(training_data);
[V, D] = eig(training_data);

% TODO PCA to find high-variance features

resp = im; % TODO, implement
end

