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

% Now test the b_k for some arbitrary point and aspect ratio

uE = 0.45;  vE = 0.05;  alpha = 1;
D = (uE + vE + 1)*(uE + vE);
bnew = [(alpha^2*(uE^2 + 2*uE*vE + uE) - (vE^2 + vE))/D
                                       (2*(vE - alpha^2*uE + 1))*(uE + vE)/D
                                       (2*(alpha^2*uE - vE + alpha^2))*(uE + vE)/D
 (vE^2 + vE + 2*uE*vE - alpha^2*(uE^2 + uE))/D
                                   (2*(alpha^2 + 1))/D]

% Original coefficients given in Geophysics paper seems partly wrong (b2)
b5 = (2*(alpha^2 + 1))/((uE+vE)*(1+uE+vE));
b4 = 1 - 0.5*b5*(uE+uE^2);
b3 = vE*(1+uE)*b5-2*b4;
b2 = b3 - (uE^2-vE^2)*b5; % <-- this seems correct
%b2 = vE*(1+uE)*b5-b3; <-- This is original paper eq but this must be wrong
b1 = uE*b5 + b4 - b2;
bpaper = [b1; b2; b3; b4; b5]
