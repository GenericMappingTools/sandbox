% Evaluation of intergrals needed in grdseamount

% 1. Slide area and centroid

syms hs h0 r0 h1 h2 u0 u u1 u2 As us dr dh f g r1 r2 r h

g = u0 * ((1 + u0)/(u + u0) - 1)
As = dh * dr * int (g, u)
us = int (g * u, u)

% 2. Cone area and centroid
% h = h0/(r0*(1-f)) * (r0 - r) = A * (r0 - r)/r0 = A * (1 - r/r0) = A * (1 - u)
h = 1 - u
Ac = int (h, u, u2, u1)
rc = int (h*(1-u),u, u2, u1)/Ac
