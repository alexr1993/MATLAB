function [ training_data ] = ReadTrainingData( dataIm, nPeople, nExamples, imsz )
%READTRAININGDATA Summary of this function goes here
%   Detailed explanation goes here
    training_data = cell(nPeople, nExamples);
    target_size = 32; % 32x32
    
    img = mean(dataIm, 3);
    for person = 1:nPeople
        for example = 1:nExamples
            % Select image patch
            start_row = ((person-1) * imsz) + 1;
            end_row = (person * imsz);
            start_col = ((example-1) * imsz) + 1;
            end_col = (example * imsz);
            patch = img(start_row:end_row, start_col:end_col);
            % Resize
            patch = imresize(patch, [target_size target_size]);
            if person == 1 || person == nPeople
                figure;imshow(patch);
            end
            training_data{person}{example} = patch(:);
        end
    end
end

