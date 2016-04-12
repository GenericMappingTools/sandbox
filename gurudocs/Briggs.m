% $Id$
% Solving for surface's Briggs coefficients for the 4 quadrants.
% P. Wessel, April 2016.
%
% We will do the 4 quadrants by specifying the data constraint's
% relative location as x,y but include the signs given the quadrant.
% I.e., for quadrant 2 the point is (-x, +y).  In other words,
% x and y are the absolute values of the offsets.
% However, when the aspect ratio is not one then we need to
% use y = alpha * y in the expressions.  So we use y and x
% to test if we are close to a node (to fix it) but x, alpha * y
% in the expressions below.

syms x y A rhs alpha
rhs = [0
       0
       2
       0
       2*alpha^2];
% point is in quadrant 1, so use nodes 1 5 9 10
% Point E has coordinates +x,+y
%node: 1  5  9 10  E
A =  [-1 -1  0  1 x
       1  0 -1 -1 y
       1  1  0  1 x^2
      -1  0  0 -1 x*y
       1  0  1  1 y^2];
bq1 = A \ rhs
% point is in quadrant 2, so use nodes 3 6 9 8
% Point E has coordinates -x,+y
%node: 3  6  9  8  E
A = [  1  1  0 -1 -x
       1  0 -1 -1  y
       1  1  0  1  x^2
       1  0  0  1 -x*y
       1  0  1  1  y^2];
bq2 = A \ rhs
% point is in quadrant 3, so use nodes 1 2 6 10
% Point E has coordinates -x,-y
%node: 1  2  6 10  E
A = [ -1  0  1  1 -x
       1  1  0 -1 -y
       1  0  1  1  x^2
      -1  0  0 -1  x*y
       1  1  0  1  y^2];
bq3 = A \ rhs
% point is in quadrant 4, so use nodes 3 2 5 8
% Point E has coordinates +x,-y
%node: 3  2  5  8  E
A = [  1  0 -1 -1  x
       1  1  0 -1 -y
       1  0  1  1  x^2
       1  0  0  1 -x*y
       1  1  0  1  y^2];
bq4 = A \ rhs

% Compare 1st and 2nd and find they are identical
simplify(bq2-bq1)
% Compare 3rd and 4th and find they are identical
simplify(bq4-bq3)
% Compare 1st and 3rd and find they differ
simplify(bq3-bq1)
% Compare 2nd and 4th and find they differ
simplify(bq4-bq2)
