function A=loadImages
% Loads a stack of tif images (e.g. a time series, or a tomographic series).
% Written by Barnaby Levin, ASU, 2017
 


% This line of code allows the user to choose an image file to open 
[fname, user_canceled] = imgetfile; 

% This line of code pulls out info about the image(s) in the file from the
% metadata

info = imfinfo(fname);
num_images = numel(info);

% The following lines read images into the array. 
% Pre-allocate array for faster processing.
k=1;
im1 = imread(fname, k, 'Info', info);
[nx,ny] = size(im1);
A=zeros(nx,ny,num_images);

A(:,:,1) = im1;

for k = 2:num_images
    A(:,:,k) = imread(fname, k, 'Info', info);
end

