% define the training sets (clusters)
% -----------------------------------
%These training set regions need to be selected manually based on direct
%visualisation 
%
% Each region is defined by two corner points following the coordinate
% format as below.
% UL=[x y z0] : the upper left corner
% DR=[x+w y+h z1] : the lower right corner


Tsets = [];

% voids
UL = [50 20 60];
DR = [50+30 20+20 70];
Tsets = [Tsets;UL,DR];

% matrix
UL = [70 80 20];
DR = [70+30 80+30 90];
Tsets = [Tsets;UL,DR];

% yarns in direction 1
UL = [40 70 20];
DR = [40+40 70+20 30];
Tsets = [Tsets;UL,DR];

% yarns in direction 2
UL = [10 20 10];
DR = [10+30 20+18 30];
Tsets = [Tsets;UL,DR];

