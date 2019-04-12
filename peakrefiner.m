function [Peaks, RefinedPeaks]=peakrefiner(Series, RefinedLattice, PeakfindRadius, CentroidRadius)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% %%%                                 INPUTS
%
% Series - A time series of images of a set of particles or atoms
% RefinedLattice - A list of lattice points around which you want to look
%                  for atom positions. 
% PeakFindRadius - The radius from each lattice point over which you want
%                  to look for local maxima
% CentroidRadius - The radius over which you want to do a centroid fit
%                  about the local maximum. 
% m and n        - Defines an mxn area over which to median filter the
%                  image to reduce noise when finding local maxima
%
% %%%                              DESCRIPTION 
%
% peakrefiner takes an image series (Series) with dimensions nx,ny,nz.
% It first runs locmax on each image, to find maxima within a given radius
% of a lattice point
% It then runs cntrd twice on each image to refine the position of the atomics
% column with sub-pixel accuracy by fitting a centroid to the data 
% and calculating the center of mass of the centroid. 
%
% %%%                                 OUTPUTs
%
% The first output Peaks, is a 3 dimensional array. with dimensions (number of peaks detected, 5, nz)
% Each 2 - dimensional layer of Peaks contains 6 columns of data related to each image in the series A. 
% In order from 1 to 6, these are the x and y co-ordinates of the center of the atomic column, 
% the integrated intensity of the pixels with at least 2/3 of the max intensity, the integrated intensity of 
% all pixels in the circular window, and the radius of gyration of the centroid fitted to the data, 
% and finally an I.D. number assigned to the column,.
%
% The second output, refined Peaks is a 2 dimensional array with 7 columns.
% This is essentially just a reshaped version of peaks. The first 6 columns
% contain the same information as in Peaks, but for all frames. The 7th
% column lists the frame number for each data point. This second format is
% useful for making certain plots (like the tracks snd rmsds). 
%
% The scripts locmax, and cntrd are from the MATLAB particle tracking package by
% Daniel Blair and Eric Dufresne, which is based on the IDL particle tracking software
% by David Grier, John Crocker, and Eric Weeks. 
%
% References J. C. Crocker, D. G. Grier, Methods of Digital Video 
% Microscopy for Colloidal Studies. J. Colloid Interface Sci.179, 298–310 
% (1996). doi:10.1006/jcis.1996.0217.
% 
% D. Blair, E.Dufresne, (The Matlab Particle Tracking Code Repository, at 
% http://physics.georgetown.edu/matlab/)
%
% By Barnaby Levin, ASU, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Asize=size(Series);
sizeAsize = size(Asize);

if sizeAsize(2)==2
    %MFSeries=medfilt2(Series,[m,n]);
    pk2 = locmax(Series,RefinedLattice,PeakfindRadius);
    cent = cntrd(Series,pk2,CentroidRadius);
    cent2 = cntrd2(Series,cent,CentroidRadius);
    Peaks(:,:) = cent2(:,:);
    sizeP = size(Peaks);
    RefinedPeaks = zeros(sizeP(1), sizeP(2)+1);
    RefinedPeaks(:, 1:sizeP(2))=Peaks(:,:);
    RefinedPeaks(:, sizeP(2)+1)=1;
    
else
    numim = Asize(3);
    Data = zeros(1000,5,numim); 
    prevcentsize=0;

    for n = 1:numim
       pk2 = locmax(Series(:,:,n),RefinedLattice,PeakfindRadius);
       cent = cntrd(Series(:,:,n),pk2,CentroidRadius);
       cent2 = cntrd2(Series(:,:,n),cent,CentroidRadius);
       centsize = size(cent2);
       Data(1:centsize(1),:,n)= cent2(:,:);
        if centsize(1) > prevcentsize
            prevcentsize=centsize(1);
        end
    end

    Peaks = Data(1:prevcentsize, :, :);
    sizeP = size(Peaks);
    RefinedPeaks = zeros(sizeP(1)*numim, sizeP(2)+1);
    for m = 1:numim
        RefinedPeaks(1+sizeP(1)*(m-1):sizeP(1)*m, 1:sizeP(2))=Peaks(:,:,m);
        RefinedPeaks(1+sizeP(1)*(m-1):sizeP(1)*m, sizeP(2)+1)=m;
    end
        
end
end