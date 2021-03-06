function [ test_pred ] = ClassifyNearestNeighbour( training_data, test_data )
% CLASSIFYNEARESTNEIGHBOUR Classify test data using nearest neighbour in
%                          training data
%
% Single band nearest neighbour classification, multiband images are
% flattened.


    [nPeople, nTraining] = size(training_data);
    nTest = size(test_data, 2);
    
    test_pred = zeros(nTest, 1);
    for i = 1:nTest
        best_match = -1;
        best_match_strength = -1;
        best_match_example = -1;
        
        % Find the nearest neighbour to the test image
        for person = 1:nPeople
            for example = 1:nTraining
                image = training_data{person,example};
                match_strength = norm(image(:) - test_data(:,i,:));
                % Replace best match if closer fit
                if match_strength < best_match_strength || best_match_strength == -1
                    best_match = person;
                    best_match_example = example;
                    best_match_strength = match_strength;
                end;
            end;
        end;
        fprintf('Best match for %d is %d at image %d (strength: %.3f)\n',...
            i, best_match, best_match_example, best_match_strength);

        % Random classification for now
        test_pred(i) = best_match;
    end;
end

