% TemplateMatching.m
gnuplot_binary('/usr/local/Cellar/gnuplot/5.0.0/bin/gnuplot')
im = imread('ozil.jpg');
template = im(1:10,1:10,:);

[imRows imCols nBands] = size(im);
dotProd = zeros(imRows, imCols);

for i = 1:nBands
    dotProdi = filter2(template(:,:,i), im(:,:,i),'same');
    dotProd = dotProd + dotProdi;
end;