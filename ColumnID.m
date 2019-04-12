function IDedPositions=ColumnID(RawPositions)

% This code takes in a 2 column file consisting of X and Y co-ordinates that
% correspond to the positions of lattice points that you want to use for particle tracking. 
% The code will assign a unique I.D. number to each lattice point, which
% will allow the motion of the atomic column near the lattice point to be
% tracked. 
% The output is a 3 column file with X and Y coordinates, and I.D. number. 
%
% Barnaby Levin ASU 2017

% Work out size of input file
sizeL = size(RawPositions);

% Pre allocate memory for IDed Lattice File
IDedPositions = zeros(sizeL(1),3);

% Fill first two columns of new file with X and Y co-ordinates
IDedPositions(:,1:2) = RawPositions(:,:);

% Fill third column of new file with I.D. numbers
for n = 1:sizeL(1)
   IDedPositions(n,3)=n; 
end

end