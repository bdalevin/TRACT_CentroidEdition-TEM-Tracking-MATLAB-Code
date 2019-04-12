function plot_initialpositions(Lattice, ZImage)
% Plot the lattice on top of the image so that the user can inspect it and
% make changes. 

% Make a figure to plot on
    h = figure('Name', 'Lattice Overlaid On Image', 'units','normalized','outerposition',[0 0 1 1]); 
    colormap('gray');

    %Display first image
    imagesc( ZImage ); axis image; 
    hold on; % Hold on forces every subsequent plot to be plotted on top of the image
    scatter(Lattice(:,1), Lattice(:,2),'x','c','linewidth', 1.0);  % Scatter plot the peaks found for the first image on top of the fist image
    brush on;
  
    hold off; % Allow the Figure to change again
end