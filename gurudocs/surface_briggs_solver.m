% Solving for surface Briggs coefficients for the 4 quadrants.
% P. Wessel, APril 2016.
%
% We will do the 4 quadrants by specifying the data constraint's
% relative location as uE,vE but include the signs given the quadrant.
% I.e., for quadrant 2 the point is -uE, +vE.  In other words,
% uE and vE are the absolute values of the offsets.

syms uE vE A b rhs
rhs = [0
       0
       2
       0
       2];
% point is in quadrant 1, so use nodes 1 5 9 10
% Point E has coordinates +uE,+vE
%node: 1  5  9 10  E
A =  [-1 -1  0  1 uE
       1  0 -1 -1 vE
       1  1  0  1 uE^2
      -1  0  0 -1 uE*vE
       1  0  1  1 vE^2];
bq1 = A \ rhs
% point is in quadrant 2, so use nodes 3 6 9 8
% Point E has coordinates -uE,+vE
%node: 3  6  9  8  E
A = [  1  1  0 -1 -uE
       1  0 -1 -1  vE
       1  1  0  1  uE^2
       1  0  0  1 -uE*vE
       1  0  1  1  vE^2];
bq2 = A \ rhs
% point is in quadrant 3, so use nodes 1 2 6 10
% Point E has coordinates -uE,-vE
%node: 1  2  6 10  E
A = [ -1  0  1  1 -uE
       1  1  0 -1 -vE
       1  0  1  1  uE^2
      -1  0  0 -1  uE*vE
       1  1  0  1  vE^2];
bq3 = A \ rhs
% point is in quadrant 4, so use nodes 3 2 5 8
% Point E has coordinates +uE,-vE
%node: 3  2  5  8  E
A = [  1  0 -1 -1  uE
       1  1  0 -1 -vE
       1  0  1  1  uE^2
       1  0  0  1 -uE*vE
       1  1  0  1  vE^2];
bq4 = A \ rhs

% Compare 1st and 2nd
simplify(bq2-bq1)
% Compare 3rd and 4th
simplify(bq4-bq3)
% Compare 1st and 3rd
simplify(bq3-bq1)
