function TrackedPeaks=track_centrdPeaks(RefinedPeaks, num_frames)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This code takes a 3D file of peaks found in an image seires, RefinedPeaks, and 
%   sorts them by peak ID number
%
%   %%%                          INPUTS    
%
%   RefinedPeaks: A 2 dimensional array, with 6 columns where each row 
%   contains data corresponding to a peak. The 5th column should contain an ID number 
%
%   num_frames: Number of images in your series. 
%
%
%   %%%                          OUTPUTS
%
%   A 3-dimensional array with the same number of columns as RefinedPeaks, 
%   but now the data is grouped by ID number.
%
%   By Barnaby Levin, ASU, 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% The code works out the size of the input file, and works out the number
% of peaks from the maximum of the 6th column of the input (which should be
% the ID number column). 
sizeP = size(RefinedPeaks);
num_peaks = sizeP(1)/num_frames;

% Introduce a dummy variable that sorts RefinedPeaks by ID number 
B = sortrows(RefinedPeaks,5);
B = B';
C = reshape(B,sizeP(2), num_frames, num_peaks);
    TrackedPeaks = permute(C,[2,1,3]);
    sizeD = size(TrackedPeaks);
    for r = 1:sizeD(3)
        TrackedPeaks(:,:,r) = sortrows(TrackedPeaks(:,:,r),6);
    end
end


