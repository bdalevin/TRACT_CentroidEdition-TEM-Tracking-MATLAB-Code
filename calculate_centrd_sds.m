function RMSDs=calculate_centrd_sds(TrackedPeaks, ProjPeaksCentrd, scale)
% This function takes as its input a 3 dimensional array (the output of 
% track_centrdPeaks.m), and calculates the standard deviation (rmsd) of  displacement 
% of atomic columns.
% The second input needs to contain the positions of the columns in the Z-projected image
% These are used to calculate the origin of position.
% The final input is the scale of the image (in nm per pixel).

% The output is a 2D array, listing the mean x and y coordinates of atomic 
% columns, stadndard deviation (rmsd), standard deviation in x, and y, (rmsx, rmsy) median displacement (mrsd)
% The 9th column of the output contains ID numbers for the columns. 

sizeP = size(TrackedPeaks);
sizePPC=size(ProjPeaksCentrd);
PPC = zeros(1,sizePPC(2),sizePPC(1));
for m = 1:sizePPC(1)
   PPC(1,:,m)= ProjPeaksCentrd(m,:);
end

% Pre-allocate memory
RMSDs = zeros (sizeP(3),9);
coords = zeros(sizeP(1),2);
for n = 1:sizeP(3)

    % Work out mean coordinates for origin
    coords=TrackedPeaks(:,1:2,n);
    coords( ~any(coords,2), : ) = []; % Remove any zeros 
    meanx = PPC(1,1,n);
    meany = PPC(1,2,n);
    sizecoords = size(coords);
    
    % Work out coordinates relative to mean
    coords0 = zeros(sizecoords(1),3);
    coords0(:,1) = coords(:,1)-meanx;
    coords0(:,2) = coords(:,2)-meany;
    
    % Work out root squared displacement for every atom
    coords0(:,3) = sqrt(coords0(:,1).^2+coords0(:,2).^2);
    
    % Work out rmsd
    rmsd = mean (coords0(:,3));
    rmsx = mean(sqrt(coords0(:,1).^2));
    rmsy = mean(sqrt(coords0(:,2).^2));
    mrsd = median(coords0(:,3));
    
    % Assign values to F
    RMSDs(n,1) = meanx;
    RMSDs(n,2) = meany;
    RMSDs(n,3) = rmsd;
    RMSDs(n,4) = rmsd*scale*1000; % Rmsd in picometers.
    RMSDs(n,5) = rmsx;
    RMSDs(n,6) = rmsx*scale*1000; % Rmsx in picometers.
    RMSDs(n,7) = rmsy;
    RMSDs(n,8) = rmsy*scale*1000; % Rmsy in picometers.
    RMSDs(n,9) = TrackedPeaks(1,5,n);
    RMSDs(n,10)= mrsd*scale*1000; 
    
end

end

