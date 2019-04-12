function plot_centrdtracks(Image, Data)
%   plot_tracks lets you view an image series with the tracks made by the motion of atomic columns 
%   The tracks are plotted on top of the Z-projection of an image series.
%
%   INPUTS
%   
%   series - The image series in which you are tracking atom positions
%   
%   data - The output file from track_descrambler.m. I.e. a 3D array, with each 2D layer containing a list of 
%   atomic column co-ordinates in each frame for each atomic column. 
%
%   Written by Barnaby Levin, ASU, 2017

    
    % Calculate Z-Projection of the image series for best signal to noise

    % Make a figure to plot tracks on
    ht = figure('Name', 'View Image With Particle Tracks'); 
    colormap('gray');
    
    %Display Z-projected image
    imagesc(Image); axis image; hold on;
    sizeDat = size(Data);
    % Plot the tracks on top of the data for every atom 
    for  m = 1:sizeDat(3)   
        X(:) = Data(:,1,m);
        Y(:) = Data(:,2,m);
        X(X==0)=NaN;
        Y(Y==0)=NaN;
        plot(X,Y,'c');
    end
    

end
