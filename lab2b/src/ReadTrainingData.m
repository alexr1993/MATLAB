function [ training_data ] = ReadTrainingData( dataIm, nPeople, nExamples, imsz, k )
%READTRAININGDATA Summary of this function goes here
%   Detailed explanation goes here
    training_data = cell(nPeople, nExamples);
    target_size = 32; % 32x32
    [height width bands] = size(dataIm);
    
    for person = 1:nPeople
        for example = 1:nExamples
            % Select image patch
            start_row = ((person-1) * imsz) + 1;
            end_row = (person * imsz);
            start_col = ((example-1) * imsz) + 1;
            end_col = (example * imsz);
            patch = dataIm(start_row:end_row, start_col:end_col,:);
            
            for band = 1:bands
                patchband = patch(:,:,band);
                %patchband = conv2(k, k, patchband); % blur before downsize
                
                % Resize
                patchband = imresize(patchband, [target_size target_size]);
                if person == 1 || person == nPeople
                    %figure;imshow(patch);
                end
            
                training_data{person}{example}(:,:,band) = ...
                    (patchband(:) - mean(patchband(:))) ./ std(patchband(:));
            end;
        end
    end
end

