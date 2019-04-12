function plot_rmsds(series, rmsds)
%   plot_tracks lets you view an image series with the rmsds of atomic columns 
%   The rmsds are plotted on top of the Z-projection of an image series.
%   The rmsds are represented by markers on a colour scale, with different 
%   colours signifyign different magnitudes of displacement.  
%
%   INPUTS
%   
%   series - The image series in which you are tracking atom positions
%   
%   rmsds - The output file from track_rmsds.m, containing a list of 
%   atomic column mean displacements. 
%
%   Written by Barnaby Levin, ASU, 2017

    
    % Calculate Z-Projection of the image series for best signal to noise
    sizestack=size(series);
    Image(:,:)=series(:,:,1);
    for n = 2:sizestack(3)
        Image(:,:) = Image(:,:) + series(:,:,n);
    end
    
    %Display Z-projected image
    ax1 = axes;
    imagesc(ax1, Image); axis image; axis off;
    frame_h = get(handle(gcf),'JavaFrame');
    set(frame_h,'Maximized',1);
    set(gcf,'color','w');
    
    ax2 = axes;
    % Plot the rmsds on top of the data for every atom 
    scatter(ax2, rmsds(:,1), rmsds(:,2), [], rmsds(:,4), 'LineWidth',1.5, 'SizeData', 49); 
    % LineWidth controls thickness of the circle. 
    % SizeData controls the area covered by the circle. I'm unclear on what the units of SizeData are.  
    
    % Comment/Uncomment this to fix the colourbar to a specified range
    caxis ([4 24]);
    
%     % Comment/Uncomment this to see the ID numbers next to the peaks (this
%     % will make diagnosis of bad peaks easier).
%     b = num2str(rmsds(:,9)); c = cellstr(b);
%     dx = 3; dy = 3;
%     text(rmsds(:,1)+dx, rmsds(:,2)+dy,c, 'Fontsize', 7, 'Color', 'w');
% %    
    
    set(ax2, 'YDir', 'reverse'); % Ensure data plotted the right way up
    daspect([1 1 1]); % Ensure data plotted with correct aspect ratio
    xlim([0 sizestack(2)]); % Ensure x axes of scatter plot and image are the same
    ylim([0 sizestack(1)]); % Ensure y axes of scatter plot and image are the same
    linkaxes([ax1,ax2]) % Overlay the axes.
    ax2.Visible = 'off'; % Ensure image visible below scatter plot
    ax2.XTick = [];
    ax2.YTick = [];
    colormap(ax1,'gray') % Set colourmap for image to grayscale
    colormap(ax2,'jet') % Set colourmap for scatter plot to parula
    
    set([ax1,ax2],'Position',[.10 .11 .685 .815]); % Fix positions of the axes
    % These positions are in units of fractions of the canvas size. The
    % numbers are: Left of graph, Bottom of graph, width, and height. 
    % The width and heigh variables will be ineffective because of commands
    % from earlier in the code. 

    cb2 = colorbar(ax2,'Position',[.78 .32 .0375 .4]); % Fix position of colourbar. 
    Ctitle = ylabel(cb2, 'Standard Deviation (pm)'); % Give colorbar a title

    % These positions are in units of fractions of the canvas size. The
    % numbers are: Left of colourbar, Bottom of colourbar, width, and height. 


    
end