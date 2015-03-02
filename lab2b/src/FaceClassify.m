% FaceClassify.m

% Load test and training images
im = double(imread('../data/g20.jpg'))/255;
dataIm = double(imread('../data/facedata.png'))/255;
names={'barroso','calderon','cameron','erdogan','gillard','harper','hollande','jintao','kirchner','merkel'...
    ,'monti','myungbak','noda','obama','putin','rompuy','rousseff','singh','yudhoyono','zuma'};
nPeople=20;   % number of people (rows of dataIm)
nExamples=32; % number of examples per person (columns of dataIm)
imsz=64;      % size of face images in dataIm (square)

% Load Viola-Jones detection rectangles and set ground truth
load('../data/vjrects', 'rects');
test_true = {'kirchner', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'monti', 'harper', 'barroso', 'hollande', 'rousseff', 'x', 'cameron', ...
    'x', 'noda', 'yudhoyono', 'calderon', 'putin', 'x', 'rompuy', 'merkel', 'x', 'x', 'obama', 'singh', 'jintao', 'zuma','myungbak'};

% Get test data
nRects = size(rects, 1);
test_data = [];
for i = 1:nRects
    imi = im(rects(i, 1):rects(i, 3), rects(i, 2):rects(i, 4), :);
    
    imf = mean(imi, 3);
    imf = imresize(imf, [32 32]);
    
    imf = imf - mean(imf(:)); % subtract mean and divide standard deviation
    imf = imf / std(imf(:));
    
    test_data(:, i) = imf(:);
end;

% Classify test data
test_pred = zeros(nRects, 1);
for i = 1:nRects
    % Random classification for now
    test_pred(i) = randi(20);
end;

% Evaluate the classification and plot results
EvaluateClassification(test_pred, test_true, names, rects, im);
