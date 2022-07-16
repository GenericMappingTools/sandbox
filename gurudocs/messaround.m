function messaround
% Checks that the solution for a fixed u0 gives a certain
% phi and if we then use phi to solve for u0 we get the
% same value and hence volume.
% This relates to grdseamount -S

r1 = 46.785714285714285; h1 = 500;
r2 = 11.428571428571427;    h2 = 6000;
rc = 46.785714285714285;  hc = 500;
r0 = 50;    h0 = 7000;
rd = 143.74100126219344;
a1 = -20;   a2 = 130; theta = (a2 - a1)/360
f = 0.1;
u0 = 0.05;
s = 1;
phi_0 = 24.181912425748234
V0 = pi * r0 * r0 * h0 * (1 - f^3)/(3*(1-f))
% COmpute flank volume
u1 = r1/r0; u2 = r2/r0;
K = u1 - u2 - 0.5 * (u1^2 - u2^2)
uf = (3 * (u1^2 - u2^2) - 2.0 * (u1^3 - u2^3))/(6*K)
Af = h0 * r0 * K / (1 - f)
rf = r0 * uf
Vf = 2 * pi * Af * rf
% Aql
dr = r1 - r2;   dh = h2 - h1;
rql = 0.5 * (r1 + r2)
Aql = dr * h1
% Aqu
Aqu = dh * dr * u0 * ((1 + u0) * log ((1 + u0)/u0) - 1)
uqu = ((1 + u0)* (1 - u0 * log ((1 + u0)/u0)) - 0.5) / ((1 + u0) * log((1 + u0)/u0) - 1)
rqu = r2 + dr * uqu
Vq = 2 * pi * (Aql * rql + Aqu * rqu)
Vs_0 = (Vf - Vq) * theta
phi = 100 * Vs_0 / V0

% Now use this phi to solve for u0 etc.

Vs = phi * V0 / (100*theta)    % Desired volume of slide scaled to 360
rhs = ((Vf - Vs)/(pi*dr) - h1 * (r1 + r2))/(2*dh)
u0 = solve_for_u0 (r1, r2, h1, h2, rhs)
