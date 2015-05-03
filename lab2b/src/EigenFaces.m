function [ faces, mu ] = EigenFaces( im, training_vecs )
%EIGENFACES Returns response of image when compared with eigenfaces of
%training data
%   training_vecs must be an nPerson x nPixels matrix

[nPerson, nPixels] = size(training_vecs);

% Subtract mean of images
mu = mean(training_vecs, 1);
training_vecs = training_vecs - repmat(mu, nPerson, 1);

% Find covariance
covariance = cov(training_vecs);

% Find Eigenvalues and EigenVectors
[V, D] = eig(covariance);

% Take best 10 EigenFaces
faces = V(nPixels-10:nPixels,:);
end

