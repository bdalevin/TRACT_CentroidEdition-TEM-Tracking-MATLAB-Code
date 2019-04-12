
function Positions = generatepositions(ZImage, x00, y00, n10, x10, y10, n01, x01, y01, Numx, Numy) 

% This code generates a lattice based on the x and y co-ordinates of atoms
% in an image. 
%
%                             INPUTS
%
%   ZImage, A Z-projected image (used only for plotting) 
%   x00, y00, the x and y co-ordinates of an atom you choose to be the origin, atom (00). 
%   x10, y10, the x and y co-ordinates of an atom you choose along your a
%   axis, atom(10). 
%   n10, the number of atoms between atom (00), and atom (10)
%   x01, y01, the x and y co-ordinates of an atom you choose along your a
%   axis, atom(01). 
%   n01, the number of atoms between atom (00), and atom (01)
%   zbound, and bbound, a boundary factor to generate more lattice points along a and b axes.
%   Leave as 1 if unsure what these will do
%
%   VERY IMPORTANT NOTE
%   Make sure that you choose atoms such that x10-x00, x01-x00, y10-y00,
%   y01-y00, are all positive. Negative values will screw this code up. 
%
%        OUTPUTS AND USER INSTRUCTIONS FOR REFINING DATA
%
%   Lattice, A list of the x and y coordinates of the lattice points.   
%   The code will plot the Lattice points on top of your image.  
%   You should use the interactive plotting tools to delete lattice points
%   outside of your particle, and save a new variable of Refined Lattice
%   points. 
%   The refined lattice data will be used as a starting point to search for
%   peaks to track atomic columns.  
%   If a lattice point is quite far from the position of an atomic column
%   (which may be an issue for unstable surface atoms), then you should edit 
%   this manually in the file to get it to be closer to the actual position 
%   of the atomic column. 
%
%
%
%

% These are settings that worked well for image series 1298. 
% x00 = 1211;
% y00 = 558;
% x10 = 2445;
% y10 = 559;
% x01 = 1838;
% y01 = 2290;
% n10 = 15;
% n01 = 22;

% Defines x and y components of lattice vectors based on user inputs
ax = (x10-x00)/n10;
ay = (y10-y00)/n10;
bx = (x01-x00)/n01;
by = (y01-y00)/n01;
if ay ==0
    ay = 0.000000001;
end

% Does some calculations so that only lattice points that fit into image 
% will be generated

% Calculate all the lattice points on a single axis. 
v1x = [x00-ax*Numx:ax:x00+ax*Numx];
v1y = [y00-ay*Numx:ay:y00+ay*Numx];

% Figure out what the size along the b axis will be
vb = [y00-by*Numy:by:y00+by*Numy];

nx = size(v1x,2);
ny = size(vb,2); 
Positions = zeros(ny*nx, 2);
Positions(1:nx, 1)=v1x';
Positions(1:nx, 2)=v1y';

% Move up and down the image and generate a new row of the lattice each
% time

for i=1:Numy
    v1x = v1x-bx;
    v1y = v1y-by;  
    Positions((i*nx)+1:(i+1)*nx, 1)=v1x';
    Positions((i*nx)+1:(i+1)*nx, 2)=v1y';    
end
numsofar=(i)*nx;
v1x = [x00-ax*Numx:ax:x00+ax*Numx];
v1y = [y00-ay*Numx:ay:y00+ay*Numx];

for j = 1:Numy
    v1x = v1x+bx;
    v1y = v1y+by;
    Positions((numsofar+j*nx)+1:numsofar+(j+1)*nx, 1)=v1x';
    Positions((numsofar+j*nx)+1:numsofar+(j+1)*nx, 2)=v1y';   
end

% Plot the lattice on top of the image so that the user can inspect it and
% make changes. 

% Make a figure to plot on
    h = figure('Name', 'Lattice Overlaid On Image', 'units','normalized','outerposition',[0 0 1 1]); 
    colormap('gray');

    %Display first image
    imagesc( ZImage ); axis image; 
    hold on; % Hold on forces every subsequent plot to be plotted on top of the image
    scatter(Positions(:,1), Positions(:,2),'x','c','linewidth', 1.0);  % Scatter plot the peaks found for the first image on top of the fist image
    brush on;
  
    hold off; % Allow the Figure to change again


end

% for i=1:n
%     plot(v1x(i,:),v1y(i,:),'bo-',v2x(i,:),v2y(i,:),'bo-')
% end