function [ vector] = MinMaxNorm( vector )
%MINMAXNORM Summary of this function goes here
%   Detailed explanation goes here
minimum = min(vector);
vector = vector - minimum;
maximum = max(vector);
vector ./ maximum;

end

