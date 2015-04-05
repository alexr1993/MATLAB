% FaceClassify.m

% Load test and training images
k = [1 4 1]/10; 
grayscale = 0;

im = double(imread('../data/g20.jpg'))/255;
dataIm = double(imread('../data/facedata.png'))/255;
if grayscale == 1
    im = mean(im,3);
    dataIm = mean(dataIm, 3);
end;

names={'barroso','calderon','cameron','erdogan','gillard','harper', ...
    'hollande','jintao','kirchner','merkel','monti','myungbak','noda', ...
    'obama','putin','rompuy','rousseff','singh','yudhoyono','zuma'};
nPeople=20;   % number of people (rows of dataIm)
nExamples=32; % number of examples per person (columns of dataIm)
imsz=64;      % size of face images in dataIm (square)

% Split data into training and validation sets
nTraining=24;
training_data = ReadTrainingData(dataIm, nPeople, nExamples, imsz, k);
validation_data = training_data(:, nTraining+1:32);
training_data = training_data(:, 1:nTraining);

% Load Viola-Jones detection rectangles and set ground truth
load('../data/vjrects', 'rects');
test_true = {'kirchner', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', ...
    'monti', 'harper', 'barroso', 'hollande', 'rousseff', 'x', ...
    'cameron', 'x', 'noda', 'yudhoyono', 'calderon', 'putin', 'x', ...
    'rompuy', 'merkel', 'x', 'x', 'obama', 'singh', 'jintao', 'zuma', ...
    'myungbak'};
[imheight imwidth nbands] = size(im);
% Get test data
nRects = size(rects, 1); % This is the size of test_true (31), there are false positives though
imSize = 32 * 32 * nbands;
test_data = zeros(nRects, imSize);

% Read in test data from G20 image
for i = 1:nRects
    rows = rects(i, 1):rects(i, 3);
    cols = rects(i, 2):rects(i, 4);
    imi = im(rows, cols, :);
    
    face = imi;
    %face = conv2(k, k, face); % blur before downsizing (doesn't seem
    %to help)
    face = imresize(face, [32 32]); % downsize
    test_data(i, :) = FeatureScale(face(:)); % flatten image data to 1D
end;

% Classify test data
test_pred = ClassifyNearestNeighbour(training_data, test_data');


% Evaluate the classification and plot results
EvaluateClassification(test_pred, test_true, names, rects, im);
