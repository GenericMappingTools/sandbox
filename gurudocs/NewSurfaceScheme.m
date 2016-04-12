% New approach: Fit a 9-term polynomial to the
% 8 nodes surrounding our central node PLUS the
% data constraint.

syms x y z1 z2 z3 z4 z5 z6 z7 z8 u;

A = [1 -1  1 -1  1  1  1 -1  1
     1  0  1  0  0  1  0  0  0
     1  1  1  1  1  1  1  1  1
     1 -1  0  0  1  0  0  0  0
     1  1  0  0  1  0  0  0  0
     1 -1 -1  1  1  1 -1 -1  1
     1  0 -1  0  0  1  0  0  0
     1  1 -1 -1  1  1 -1  1  1
     1  x  y x*y x^2 y^2 x^2*y y^2*x x^2*y^2 ];
r = [z1; z2; z3; z4; z5; z6; z7; z8; u];
c = A \ r
C = simplify(c(5) + c(6))
% This gives
%C = (z2 + z4 + z5 + z7 - 4*u - 2*x*z4 + 2*x*z5 + 2*y*z2 - 2*y*z7 - x^2*z2 
%    + x^2*z4 + x^2*z5 - x^2*z7 + y^2*z2 - y^2*z4 - y^2*z5 + y^2*z7 
%    - x*y^2*z1 + x^2*y*z1 - 2*x^2*y*z2 + x*y^2*z3 + x^2*y*z3 + 2*x*y^2*z4 
%    - 2*x*y^2*z5 - x*y^2*z6 - x^2*y*z6 + 2*x^2*y*z7 + x*y^2*z8 - x^2*y*z8 
%    + x^2*y^2*z1 - x^2*y^2*z2 + x^2*y^2*z3 - x^2*y^2*z4 - x^2*y^2*z5 
%    + x^2*y^2*z6 - x^2*y^2*z7 + x^2*y^2*z8 - x*y*z1 + x*y*z3 + x*y*z6 
%    - x*y*z8)/(2*(x^2 - 1)*(y^2 - 1))

