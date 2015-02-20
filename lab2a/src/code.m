%{
In order to build classifiers we need to compute the distances between
images
e.g. the sum of squared distances between I(x,y,b) and J(x,y,b) could be
computed as

sumx sumy sumb (I(x,y,b) - J(x,y,b)) ^2

Requiring three loops
%}
I = imread('hand.jpg');
J = imread('glovelight.jpg');

% [nRows nCols nBands] = size(I);
% tic;
% sumsq = 0;
% for x = 1:nRows
%     for y = 1:nCols
%         for b = 1:nBands
%             diff = I(x,y,b) - J(x,y,b);
%             sumsq = sumsq + diff*diff;
%         end;
%     end;
% end;
% toc;

% It is much quicker to convert the image into a single vector and compute
% the distance over it

% tic;
% sumsq = sum((I(:)-J(:)) .^ 2)
% toc;

nData = 400;
nDims = 400;
data = rand(nDims, nData);

D = zeros(nData,nData);

%for loop
tic;
for i = 1:nData
    for j = 1:nData
        diff = data(:,i) - data(:,j);
        sumsqdiff = sum(diff.^2);
        D(i,j) = sumsqdiff;
    end;
end;
toc;

D2 = zeros(nData, nData);

% repmat
tic;
for i = 1:nData
    % subtract datum i from all vectors
    diff = data - repmat(data(:,i), 1, nData);
    % square and store the difference
    sumsqdiff = sum(diff .^2);
    D2(i,:) = sumsqdiff;
end;
toc;

sum(sum(D-D2));









