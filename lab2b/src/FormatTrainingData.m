function [ classes, vectors ] = FormatTrainingData( data, nPeople, nSamples, imSize )
%FORMATTRAININGDATA Convert data from person x example cell array, to a
% vector of true classes and a matrix of feature vectors of the images
%   Detailed explanation goes here

    classes = zeros(nPeople * nSamples, 1);
    for i = 1:nPeople
        for j = 1:nSamples
            classes(( (i-1) * nSamples) + j) = i;
        end;
    end;

    vectors = zeros(nPeople * nSamples, imSize);
    for i = 1:nPeople
        for j = 1:nSamples
            vectors(( (i-1) * nSamples) + j, :) = data{i,j}(:);
        end;
    end;

end