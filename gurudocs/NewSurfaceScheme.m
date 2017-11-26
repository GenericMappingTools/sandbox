% Possibly new approach in surface:
% Fit a 9-term polynomial to the
% 8 nodes surrounding our central node PLUS the
% data constraint (u,v,w):
%
% z(u,v) = c1 + c2*u + c3*v + c4*u*v + c5*u^2 + c6*v^2 + c7*u^2*v + c8*v^2*u + c9*u^2*v^2
%
% What we really want is the Lapacian of z for u = v = 0 which is
% C(0,0) = 2*(c5 + c6)
% so we let Matlab solve for this expression

syms u v z1 z2 z3 z4 z5 z6 z7 z8 w;

A = [1 -1  1 -1  1  1  1 -1  1
     1  0  1  0  0  1  0  0  0
     1  1  1  1  1  1  1  1  1
     1 -1  0  0  1  0  0  0  0
     1  1  0  0  1  0  0  0  0
     1 -1 -1  1  1  1 -1 -1  1
     1  0 -1  0  0  1  0  0  0
     1  1 -1 -1  1  1 -1  1  1
     1  u  v u*v u^2 v^2 u^2*v v^2*u u^2*v^2 ];
r = [z1; z2; z3; z4; z5; z6; z7; z8; w];
c = A \ r
curv = 2*(c(5) + c(6))
C = simplify(curv)
% This gives
%C = (z2 + z4 + z5 + z7 - 4*w - 2*u*z4 + 2*u*z5 + 2*v*z2 - 2*v*z7 - u^2*z2 
%    + u^2*z4 + u^2*z5 - u^2*z7 + v^2*z2 - v^2*z4 - v^2*z5 + v^2*z7 
%    - u*v^2*z1 + u^2*v*z1 - 2*u^2*v*z2 + u*v^2*z3 + u^2*v*z3 + 2*u*v^2*z4 
%    - 2*u*v^2*z5 - u*v^2*z6 - u^2*v*z6 + 2*u^2*v*z7 + u*v^2*z8 - u^2*v*z8 
%    + u^2*v^2*z1 - u^2*v^2*z2 + u^2*v^2*z3 - u^2*v^2*z4 - u^2*v^2*z5 
%    + u^2*v^2*z6 - u^2*v^2*z7 + u^2*v^2*z8 - u*v*z1 + u*v*z3 + u*v*z6 
%    - u*v*z8)/(2*(u^2 - 1)*(v^2 - 1))

