% FaceClassify.m

% Configuration
grayscale = 0;
nearestNeighbour = 0;
supportVectorMachine = 1;
svm_params = '-q -s 1 -t 1 -d 3 -c 8 -g 1';

% Globals
names={'barroso','calderon','cameron','erdogan','gillard','harper', ...
    'hollande','jintao','kirchner','merkel','monti','myungbak','noda', ...
    'obama','putin','rompuy','rousseff','singh','yudhoyono','zuma'};
nPeople = 20;   % number of people (rows of dataIm)
nExamples = 32; % number of examples per person (columns of dataIm)
imsz = 64;      % size of face images in dataIm (square)

% Load Viola-Jones detection rectangles and set ground truth
load('../data/vjrects', 'rects');
test_true = {'kirchner', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', ...
    'monti', 'harper', 'barroso', 'hollande', 'rousseff', 'x', ...
    'cameron', 'x', 'noda', 'yudhoyono', 'calderon', 'putin', 'x', ...
    'rompuy', 'merkel', 'x', 'x', 'obama', 'singh', 'jintao', 'zuma', ...
    'myungbak'};

% Load test and training images

% Split data into training and validation sets
nTraining = 24;
nValidation = nExamples - nTraining;
all_data = ReadTrainingData(dataIm, nPeople, nExamples, imsz);
validation_data = all_data(:, nTraining+1:nExamples);
training_data = all_data(:, 1:nTraining);

im = double(imread('../data/g20.jpg'))/255;
dataIm = double(imread('../data/facedata.png'))/255;
if grayscale == 1
    im = mean(im,3);
    dataIm = mean(dataIm, 3);
end;

nRects = size(rects, 1); % This is the size of test_true (31), there are false positives though
nTests = nRects;
nBands = size(dataIm, 3);
imSize = 32 * 32 * nBands;
test_data = zeros(nRects, imSize);

% Read in test data from G20 image
for i = 1:nRects
    rows = rects(i, 1):rects(i, 3);
    cols = rects(i, 2):rects(i, 4);
    imi = im(rows, cols, :);
    
    face = imi;
    face = imresize(face, [32 32]); % downsize
    face = face - mean(face(:));
    face = face / std(face(:));
    test_data(i, :) = face(:); % flatten image data to 1D
end;

% Classify Nearest Neighbour
if nearestNeighbour == 1
    disp(' [ Classifying Using Nearest Neighbour ] ');
    % Nearest Neighhbour Classify
    test_pred = ClassifyNearestNeighbour(training_data, test_data');
    % Evaluate the classification and plot results
EvaluateClassification(test_pred, test_true, names, rects, im);
end;

% Classify SVM
if supportVectorMachine == 1
    disp(' [ Classifying Using SVM ] ');

    % SVM Classify
    % Format training_data for svm
    [training_classes training_vecs] = ...
        FormatTrainingData(training_data, nPeople, nTraining, imSize);
    
    [validation_classes validation_vecs] = ...
        FormatTrainingData(validation_data, nPeople, nValidation, imSize);

%{
    bestcv = 0;
    for log2c = -1:3,
      for log2g = -4:1,
        cmd = ['-q -q -s 1 -t 1 -d 3 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
        cv = svmtrain(trainingclasses, training_vecs, cmd);
        if (cv >= bestcv),
          bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
        end
        fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
      end
    end;
    %}
 
    SVMStruct = svmtrain(training_classes, training_vecs, svm_params);

    % Check accuracy on validation set
    [valid_pred, accuracy, decisionvals] = svmpredict(validation_classes, validation_vecs , SVMStruct);

    % Predict using SVM
    test_label = zeros(nTests, 1);
    test_pred = svmpredict(test_label, test_data, SVMStruct);
    % Evaluate the classification and plot results
    EvaluateClassification(test_pred, test_true, names, rects, im);
end;
