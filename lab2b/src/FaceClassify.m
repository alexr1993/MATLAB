% FaceClassify.m

% Load test and training images
im = double(imread('../data/g20.jpg'))/255;
dataIm = double(imread('../data/facedata.png'))/255;
names={'barroso','calderon','cameron','erdogan','gillard','harper', ...
    'hollande','jintao','kirchner','merkel','monti','myungbak','noda', ...
    'obama','putin','rompuy','rousseff','singh','yudhoyono','zuma'};
nPeople=20;   % number of people (rows of dataIm)
nExamples=32; % number of examples per person (columns of dataIm)
imsz=64;      % size of face images in dataIm (square)
training_data = ReadTrainingData(dataIm, nPeople, nExamples, imsz);
% Load Viola-Jones detection rectangles and set ground truth
load('../data/vjrects', 'rects');
test_true = {'kirchner', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', ...
    'monti', 'harper', 'barroso', 'hollande', 'rousseff', 'x', ...
    'cameron', 'x', 'noda', 'yudhoyono', 'calderon', 'putin', 'x', ...
    'rompuy', 'merkel', 'x', 'x', 'obama', 'singh', 'jintao', 'zuma', ...
    'myungbak'};

% Get test data
nRects = size(rects, 1); % This is the size of test_true (31), there are false positives though
imSize = 32 * 32;
test_data = zeros(imSize, nRects);
for i = 1:nRects
    imi = im(rects(i, 1):rects(i, 3), rects(i, 2):rects(i, 4), :);

    imf = mean(imi, 3); % grayscale
    imf = imresize(imf, [32 32]); % downsize
    % subtract mean and divide standard deviation
    imf = imf - mean(imf(:));
    imf = imf / std(imf(:));
    
    test_data(:, i) = (imf(:) - mean(imf(:))) ./ std(imf(:));
end;

% Classify test data
test_pred = zeros(nRects, 1);
for i = 1:nRects
    best_match = -1;
    best_match_strength = -1;
    best_match_example = -1;
    % Find the nearest neighbour to the test image
    for person = 1:nPeople
        for example = 1:nExamples
            match_strength = norm(training_data{person}{example}-test_data(:,i));
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

% Evaluate the classification and plot results
EvaluateClassification(test_pred, test_true, names, rects, im);
