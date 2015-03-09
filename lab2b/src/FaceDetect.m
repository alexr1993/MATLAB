% FaceDetect.m

% Read source image 
disp('[ Reading source image ]');
imc = double(imread('../data/g20.jpg'))/255;

% Extract features from image
disp('[ Extracting features ]');
imf = mean(imc, 3); % greyscale image for now

% Select a region for template matching
selectRegion = 0;
disp('[ Selecting template region ]');
if (selectRegion)
    fh = figure; imshow(imc);
    rect = floor(getrect);
    templatec = imf(rect(2):(rect(2)+rect(4)-1), rect(1):(rect(1)+rect(3)-1), :);
    %imwrite(templatec, 'template.png'); % store patch as template
    template = templatec - mean(templatec(:));
    close(fh);
else
% use fixed image
    imt = double(imread('../data/template.png'))/255;
    template = imt;
    %imt = imresize(imt, [33 33]);
    %template = mean(imt, 3); % greyscale image for now
    %template = template - mean(template(:));
end;


% Compute normalised correlation of template with image
disp('[ Filtering with template ]');

resp = NormCorr(imf, template);
%resp = NormalisedFilter(imf, template);
figure;imshow(resp);
figure, surf(resp), shading flat

% Find local maxima with non-max suppression  
disp('[ Find local maxima ]');
suppDst = 10;
[maxVal, maxPos] = FindLocalMaxima(resp, suppDst);

% Display and evaluate detections
disp('[ Evaluate detections ]');
numDetections = 50; % viola-jones picks up 31 faces
EvaluateDetections(imc, template, maxPos, numDetections);
