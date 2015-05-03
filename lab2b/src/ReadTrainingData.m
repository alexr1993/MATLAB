function [ training_data ] = ReadTrainingData( dataIm, nPeople, nExamples, imsz )
%READTRAININGDATA Summary of this function goes here
%   Detailed explanation goes here
    training_data = cell(nPeople, nExamples);
    target_size = 32; % 32x32
    
    for person = 1:nPeople
        for example = 1:nExamples
            % Select image patch
            start_row = ((person-1) * imsz) + 1;
            end_row = (person * imsz);
            start_col = ((example-1) * imsz) + 1;
            end_col = (example * imsz);
            patch = dataIm(start_row:end_row, start_col:end_col,:);
            
            %patch = conv2(k, k, patch); % blur before downsize

            % Resize
            patch = imresize(patch, [target_size target_size]);
            if person == 1 && 0
                figure;imshow(patch);
            end
            patch = patch - mean(patch(:));
            patch = patch / std(patch(:));
            training_data{person,example} = patch;
        end
    end
end

