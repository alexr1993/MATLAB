function [ faces, mu ] = EigenFaces( im, training_vecs )
%EIGENFACES Returns response of image when compared with eigenfaces of
%training data
%   training_vecs must be an nPerson x nPixels matrix

[nPerson, nPixels] = size(training_vecs);

% Subtract mean of images
mu = mean(training_vecs, 1);
training_vecs = training_vecs - repmat(mu, nPerson, 1);

coeff = pca(training_vecs, 'NumComponents', 15);
faces = coeff';
disp('[ Constructed Eigenfaces ]');
end

