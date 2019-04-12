function plot_centrdpeaks(series, cent, xtarget, ytarget, window)
%   plot_peaks lets you view an image series with the peaks found by pkloop
%   plotted on top. 
%   Press 'p' to see the next image, and 'o' to see the previous image.
%   Press 'q' to quit.
%   Written by Barnaby Levin, ASU, 2017
%   This code was based on code used in the eTomo suite, by Robert Hovden
% 
    
    % Make a figure to plot on
    fprintf('Begin viewing the Image series\n');
    h = figure('Name', 'View Image Series With Particle Positions', 'units','normalized','outerposition',[0 0 1 1]); 
    colormap('gray');
    
    imnum = 1;  %Start series at first image

    %Display first image
    imagesc( series(:,:,imnum) ); axis image; axis off; set(gcf, 'color', [1 1 1]);
    hold on; % Hold on forces every subsequent plot to be plotted on top of the image
    scatter(cent(:,1,imnum),cent(:,2,imnum),500,'x','c', 'LineWidth',2);  % Scatter plot the peaks found for the first image on top of the fist image
    brush on;
    
  
    hold off; % Allow the Figure to change again
    title( ['Image Number: ' num2str(imnum)] );
    
    
    key = 'default';
        while( key ~= 'q' )
            w = waitforbuttonpress;
            if w == 0
                disp('Button click');
                key = 'default';
            else
                key = get(h,'CurrentCharacter');
            end
            
            if key == 'p'
                fprintf('Next\n'); 
                figure(h); 
                limreached = seriesnum(series,imnum+1);
                imnum = imnum + ~limreached; 
                axis image; axis off; colormap('gray'); set(gcf, 'color', [1 1 1]); hold on;
                scatter(cent(:,1,imnum),cent(:,2,imnum),500,'x','b', 'LineWidth',2);
                brush on;
         
                hold off;
            elseif key == 'o'
                fprintf('Previous\n');axis image;
                figure(h); 
                limreached = seriesnum(series,imnum-1);
                imnum = imnum - ~limreached;
                axis image;  axis off; colormap('gray'); set(gcf, 'color', [1 1 1]); hold on;
                scatter(cent(:,1,imnum),cent(:,2,imnum),500,'x','r', 'LineWidth',2);
                brush on;
                            
                hold off;
            elseif key == 'q'
                fprintf('Quit\n')
                close(h);
            else
                fprintf('Null\n');
            end
        end

    

end

function [limitreached] = seriesnum(series, imnum)
    if imnum <= size(series,3)  && imnum >= 1
        imagesc( series(:,:,imnum) );
        title( ['Image Number: ' num2str(imnum)] ); 
        limitreached = 0;
    elseif imnum > size(series,3) || imnum < 1
        fprintf('Image number limit reached\n');
        limitreached = 1;
    end
end




