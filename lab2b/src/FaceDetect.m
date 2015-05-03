% FaceDetect.m

% Configuration
templateMatching = 0; % 0 for eigenfaces, 1 for templatematching
selectRegion = 0;
grayscale = 0;
storedTemplate = '../data/templatec.png';

% Read source image 
disp('[ Reading source image ]');
imc = double(imread('../data/g20.jpg'))/255;

% Extract features from image
disp('[ Extracting features ]');

% Select a region for template matching
disp('[ Selecting template region ]');
if (selectRegion)
    fh = figure; imshow(imc);
    rect = floor(getrect);
    template = imc(rect(2):(rect(2)+rect(4)-1), rect(1):(rect(1)+rect(3)-1), :);
    %imwrite(template, 'templatec.png'); % store patch as template
    close(fh);
else
    template = double(imread(storedTemplate))/255;
end;

if (grayscale == 1) 
    template = mean(template, 3);
    im = mean(imc, 3);
else
    im = imc;
end;

% Compute normalised correlation of template with image
disp('[ Filtering with template ]');

if templateMatching == 1 
    resp = NormCorr(im, template);
else
    % Read Training Data
    nPeople = 20;   % number of people (rows of dataIm)
    nExamples = 32; % number of examples per person (columns of dataIm)
    imsz = 64;      % size of face images in dataIm (square)
    
    % Split data into training and validation sets
    nTraining = 24;
    nValidation = nExamples - nTraining;
    all_data = ReadTrainingData(dataIm, nPeople, nExamples, imsz);
    validation_data = all_data(:, nTraining+1:nExamples);
    training_data = all_data(:, 1:nTraining);
    
    resp = EigenFaces(im, training_data);
end;

% Find local maxima with non-max suppression  
disp('[ Find local maxima ]');
suppDst = 10;
[maxVal, maxPos] = FindLocalMaxima(resp, suppDst);

% Display and evaluate detections
disp('[ Evaluate detections ]');
numDetections = 50; % viola-jones picks up 31 faces
EvaluateDetections(imc, template, maxPos, numDetections);
