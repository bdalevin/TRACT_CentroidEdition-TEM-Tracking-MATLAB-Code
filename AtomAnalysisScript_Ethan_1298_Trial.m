%%%%%%% Particle Tracking Live Script %%%%%%%

% Written by Barnaby Levin, ASU, 2017

% A live script is a MATLAB script that can be run section by section. Each
% section begins with two percentage signs, followed by a bold green title.
% Run each section with the "Run Section" command in the toolbar.

%% 1) Load raw image and adaptive threshold image
% This section of code lets you choose an image series to load 
% A Z-projected images is generated from the image series.
% The user should enter the scale of the image in nm per pixel.

Image=loadImages;
% Image=RemoveOutliers(Image,25); Optional script to remove outliers.
sizestack=size(Image);
ZImage(:,:)=Image(:,:,1);
for n = 2:sizestack(3)
    ZImage(:,:) = ZImage(:,:) + Image(:,:,n);
end

Scale = 0.00396596858;

%% 2) Generate initial guesses for atomic column positions
% This code generates a periodic set of positions based on the x and y 
% co-ordinates of three user-selected atoms in an image. 
% For complex unit cells, the user can define multiple arrays of positions 
% and then merge them into a single array in the next section. 
% IF YOU HAVE A SMALL DATASET (< 20 atomic columns), it's probably easier
% to enter positions manually. 
%
%                             INPUTS
%   Code should read: Positions = generatepositions(ZImage, x00, y00, n10, x10, y10, n01, x01, y01, Na,Nb);
%   Where inputs are defined as follows:
%   ZImage, A Z-projected image (used only for plotting) 
%   x00, y00, the x and y co-ordinates of an atom you choose to be the origin, atom (00). 
%   x10, y10, the x and y co-ordinates of an atom you choose along your a
%   axis, atom(10). 
%   n10, the number of atoms between atom (00), and atom (10)
%   %   x10, y10, the x and y co-ordinates of an atom you choose along your a
%   axis, atom(10).
%   n01, the number of atoms between atom (00), and atom (01)
%   x01, y01, the x and y co-ordinates of an atom you choose along your a
%   axis, atom(01). 
%   Na, how far you want the code to repeat the array in the 'a' axis 
%   Nb, how far you want the code to repeat the array in the 'b' axis
%
Positions = generatepositions(ZImage, 2177, 953, 7, 2752, 957, 6, 2003, 480,22,18);

% A figure will appear with the array of points overlaid onto the
% Z-projected image. 
% Delete unwanted points using MATLAB's plotting tool, and save the 
% remaining positions as a new array.    
% VERY IMPORTANT NOTE: DELETE ALL LATTICE POINTS CLOSE TO EDGE OF IMAGE.
% THESE CAN SCREW WITH THE TRACKING CODE. 

% If you have multiple arrays of positions, use the line of code below to
% merge the arrays into a single file: 
% Positions = cat(1,Positions1, Positions2); 

%% 2.5) Index the column positions
% This code will assign an I.D. number to each column position. This will be
% used to ensure that columns can be easily tracked in the particle tracking
% code. 
RefinedPositions = ColumnID(Positions);
% You should now have a 3 column file. The first two columns will give
% coordinates for column positions, and the third will give the column ID
% number

% plot_lattice(RefinedLattice,ZImage); % Optional. Uncomment this code to plot initial column positions and check that they are reasonable

%% 3) Find Atomic Column Positions in the Z-Projected Image
% This section of the code fits elliptical Gaussians to columns in the Z-projected Image and calculates column positions and integrated intensities. 

% Firstly, the user needs to input initial Guesses, and upper and lower
% bounds for 6 fit parameters for the Gaussian. 
% These are: 1) Amplitude, 2) x-coordinate (relative to initial positions from
% previous section), 3) standard deviation in x, 4) y-coordinate (relative to initial positions from
% previous section), 5) standard deviation in y, and 6) angle of rotation
% relative to image axis. 
% Reasonable guesses initial guesses can be made as follows: 
% 1) Initial Guess for Amplitude - Difference intensity on column and in vacuum  
% 2) and 4) Initial Guess for positions - 0. 
% 3) and 5) Initial guess for Gaussian standard deviations: About a quarter
% of the full width of the atomic column in pixels on the image. 
% 6) Initial Guess for Angle of rotation - 0. 
Guess1 = [            6,   0,  5,   0,  5,     0,  5];
lb1 = [               0, -10,  3, -10,  3, -pi/4, -5];
ub1 = [max(max(ZImage)),  10, 12,  10, 12,  pi/4, 10];

% Secondly, the user should enter a noise level and a "Rose Criterion" 
% The noise level is used to determine the error bars on integrated intensity. 
% You can estimate noise by drawing a box in an area of vacuum in ImageJ,
% then calculating the standard deviation. 
Noise1=0.299;
% The "Rose Criterion" is a threshold that you choose. If the amplitude of
% the Gaussian fitted to an atomic column is less than this threshold
% multiplied by the noise, then the code will register that there is no
% detectable atom present in the column. 
RoseCriterion1 = 2;

% Now for the calculation. 
% Code should read: [ProjPeaksGauss, RefinedProjPeaksGauss] = ColumnFinderProjected(ZImage, RefinedPositions, W1, W2, W3, Guess, lb, ub, Noise, RoseCriterion);
% Where Inputs and Outputs are defined as follows. 

%                      INPUTS
% %   ZImage: A Z-projected image 
% %   RefinedPositions: 3 column file with coordinates in 1st 2 columns, and ID numbers in 3rd column
% %   W1, W2, W3: Window diameters for a local max search, a centroid fit, and finally, the 2D Gaussian fit. 
% %   Guess, lb, ub: The initial guesses and upper and lower bounds for the Guassian fit as described above.
% %   Noise, RoseCriterion: The noise level and threshold described above. 

%                      OUTPUTS    
% % 1) ProjPeaksGauss: A 9 column file. 
% %    1st column: Fitted Amplitudes
% %    2nd column: Fitted x coordinate
% %    3rd column: Fitted x standard deviation
% %    4th column: Fitted y coordinate
% %    5th column: Fitted y standard deviation
% %    6th column: Fitted Angle of rotation
% %    7th column: Calculated Intensity
% %    8th column: Calculated error on intensity
% %    9th column: Column ID number

% % 2) RefinedProjPeaksGauss: A 10 column file. Same as above but includes
% an extra column for frame number. 

[ProjPeaksGauss, RefinedProjPeaksGauss] = ColumnFinderProjected(ZImage, RefinedPositions, 10, 10, 50, Guess1, lb1, ub1, Noise1, RoseCriterion1);

% %  These codes plot fitted positions and calculated intensities of the atomic columns on the Z-projected image
plot_gausspositions(ZImage, RefinedProjPeaksGauss);
% plot_gaussintensity(ZImage, RefinedProjPeaksGauss); 


% This is an alternate version for finding peak positions that uses
% centroid fitting. 
[ProjPeaksCentrd, RefinedProjPeaksCentrd] = peakrefiner(ZImage, RefinedLattice, 10, 25);
plot_centrdpositions(ZImage, RefinedProjPeaksCentrd);


%% 4) Find Atomic Column Positions in the Image Time Series
% This section of the code uses fits from Z-projected Image as input, 
% and calculates column positions and integrated intensities in each frame 
% of the image series. 

% Initial Guesses, lower bounds, and upper bounds for Gaussian fit. (See
% previous section for details, as these should be somewhat similar). Note
% that the background level, and the amplitude of the Gaussians in
% individual frames should be smaller than for summed image. 
Guess2 = [                  0.6,   0,  5,   0,  5,     0,  0.5];
lb2 = [                       0, -10,  3, -10,  3, -pi/4, -0.5];
ub2 = [max(max((Image(:,:,1)))),  10, 12,  10, 12,  pi/4,  1.5];

% Noise level and Rose Criterion. See above for details. 
Noise2=0.095; % Measured as standard deviation in vacuum for an individual frame. 
RoseCriterion2 = 3;

% Now for the calculation. 
% Code should read: [PeaksGauss, RefinedPeaksGauss] = ColumnFinderSeries(Image, ProjPeaksGauss, W1, Guess, lb, ub, Noise, RoseCriterion); 
% Where Inputs and Outputs are defined as follows. 

%                      INPUTS
% %   Image: An Image Series 
% %   ProjPeaksGauss: 9 column file with coordinates in 2nd and 4th columns, and ID numbers in 9th column
% %   W, Window diameter for the 2D Gaussian fit. 
% %   Guess, lb, ub: The initial guesses and upper and lower bounds for the Guassian fit as described above.
% %   Noise, RoseCriterion: The noise level and threshold described above. 

%                      OUTPUTS    
% % 1) PeaksGauss: A 3D, array.
% %    For every frame in the image series, there are 9 columns in the array, containing: 
% %    1st column: Fitted Amplitudes
% %    2nd column: Fitted x coordinate
% %    3rd column: Fitted x standard deviation
% %    4th column: Fitted y coordinate
% %    5th column: Fitted y standard deviation
% %    6th column: Fitted Angle of rotation
% %    7th column: Calculated Intensity
% %    8th column: Calculated error on intensity
% %    9th column: Column ID number

% % 2) RefinedProjPeaksGauss: A 10 column file. The 3D array PeaksGauss is
% %    reshaped so that data from all frames appear in a 2D array. The
% %    additional 10th column contains the frame number associated with each
% %    data point. 

[PeaksGauss, RefinedPeaksGauss] = ColumnFinderSeries(Image, ProjPeaksGauss, 50, Guess2, lb2, ub2, Noise2, RoseCriterion2); 
% plot_gaussintensity(Image(:,:,3),PeaksGauss(:,:,3));

% This is an alternate version for finding peak positions that uses
% centroid fitting. 
InitialPosnsCentrd = ProjPeaksCentrd(:,[1 2 5 3 4]); % This just rearranges data to a convenient format
[PeaksCentrd, RefinedPeaksCentrd] = peakrefiner(Image, InitialPosnsCentrd(:,1:3), 10, 25);


%% 5) Calculate root mean squared displacement (standard deviation) and make plot

% Now Run script to track motion of atom columns
% First, the script track_gaussPeaks sorts the data so that peaks from 
% different frames are grouped together based on their ID numbers. 
TrackedPeaksGauss=track_gaussPeaks(RefinedPeaksGauss,10);
TrackedPeaksCentrd=track_centrdPeaks(RefinedPeaksCentrd,10);

% Next, the script track_gaussrmsd2 calculates the standard deviation of
% the column positions in the image series, measured relative to the 
% positions in the Z-projected image. 
GaussRMSDs= calculate_gauss_sds(TrackedPeaksGauss, ProjPeaksGauss, Scale);

% Now we can plot the results. The script plot_rmsds overlays the image 
% with a ring around each atomic column. The rings are plotted according 
% to a colour map, with colour indicating standard deviation.
figure(1);
plot_rmsds(Image,GaussRMSDs);


% Alternative for Centroid Fitting
CentrdRMSDs = calculate_centrd_sds(TrackedPeaksCentrd, ProjPeaksCentrd, Scale);
figure(2);
plot_rmsds(Image,CentrdRMSDs);
% The annoying thing about the plotting script is that it really struggles with
% colourbar placement, so if you want to change the colorbar, you have to edit it manually in the code (file plot_rmsds.m). 





%% 5.5) Detailed Check For Errors

% The script plot_gausstracks draws lines that trace out the motion of 
% atomic columns that the code has found over the top of the projected
% image. 
% This script is very useful for spotting errors. 
% If you see errors like tracks extending to neighbouring atomic
% columns, then you need to adjust the window fitting sizes in Section 5.
% plot_tracks(Image,TrackedPeaks);
figure(1); 
plot_gausstracks(ZImage,TrackedPeaksGauss);

% If you spotted an error in the outputs above, you can use this script to
% check each individual frame for errors. 
figure(2);
plot_gausspeaks(Image, PeaksGauss,100,100,100);

% Inputs:
% 1) Image: An Image Series
% 2) PeaksGauss: 9 column, 3D array output from iterative Gaussian fitting
% 3) and 4) x and y coordinates for a column you want to inspect
% 5) Size (in pixels) of the area that you want to zoom to when inspecting the data. 

% Controls: 
% Press "p" for next image, 
% Press "o" for previous image, 
% Press "q" to quit. 

% Alternative for centroid fits
plot_centrdpeaks(Image, PeaksCentrd,100,100,100);

%% 6) Calculate How Many Times There is a Jump Above a certain threshold, and estimate Activation Energy
% Calculate jump frequency above user specified threshold in picometers
[TrackedJumpsGauss, JumpsGauss] = track_gaussjumps(TrackedPeaksGauss, Scale,10);

% Plot number of jumps
figure(2);
plot_jumps(Image, JumpsGauss);

%figure(5);
% % plot estimated activation energies
% plot_Ea(Image, JumpsGauss);

%% Calculate Column Intensities To Compare To Lookup Table
% 
% IntensityPeaksGauss = IntensityTimeSeries(RefinedPeaksGauss2,Scale);
% IntensityProjPeaksGauss = IntensityTimeSeries(RefinedProjPeaksGauss,Scale);
% 
% % Pos1Intensity=ExtractIntensities(IntensityPeaksGauss,1);
% % Pos2Intensity=ExtractIntensities(IntensityPeaksGauss,2);
% % Pos3Intensity=ExtractIntensities(IntensityPeaksGauss,3);
% % Pos4Intensity=ExtractIntensities(IntensityPeaksGauss,4);
% 
% %NormFactor = 104266.611088/1.64;
% 
% % figure(1);
% % plot(Pos1Intensity(:,7),Pos1Intensity(:,8),'ro',Pos2Intensity(:,7),Pos2Intensity(:,8),'bo',Pos3Intensity(:,7),Pos3Intensity(:,8),'go',Pos4Intensity(:,7),Pos4Intensity(:,8),'ko');
% figure(2);
% %plot(Pos1Intensity(:,7)/2,Pos1Intensity(:,8)/NormFactor,'ro',Pos2Intensity(:,7)/2,Pos2Intensity(:,8)/NormFactor,'bo',Pos3Intensity(:,7)/2,Pos3Intensity(:,8)/NormFactor,'go',Pos4Intensity(:,7)/2,Pos4Intensity(:,8)/NormFactor,'ko');
% plot_gaussintensity2(ZImage, IntensityProjPeaksGauss, 1);
% 
% 

%% 10) Calculate Displacements from Lattice Positions
% Displacements=Displacement(Posns3, Posns8);
% figure(1);
% plot_GaussvsGauss(TImage, Posns3, Posns8)
% % plot_LatticevsGauss(ZImage, NewRefinedLattice, RefinedProjPeaksGauss); % This script works, but the lattice isn't quite good enough to give quantitative information. 
% figure(2);
% plot_displacementquiver(ZImage, Posns3, Displacements,0.3);








