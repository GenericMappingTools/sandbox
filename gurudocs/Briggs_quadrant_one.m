% $Id$
% Solving for surface's Briggs coefficients for quadrant one.
% P. Wessel, Nov. 2017.
%
% We will do the first quadrant by specifying the data constraint's
% relative location as (uE,vE).
% However, when the aspect ratio is not one then we need to
% use vE = alpha * vE in the expressions.  So we use vE and uE
% to test if we are close to a node (to fix it) but uE, alpha * vE
% in the expressions below.

syms uE vE A rhs alpha
rhs = [0
       0
       2
       0
       2*alpha^2];
% point is in quadrant 1, so use nodes 1 5 9 10
% Point E has coordinates +uE,+vE
% nodes A-E are: NW W1 S1 SE E
A =  [-1 -1  0  1 uE
       1  0 -1 -1 vE
       1  1  0  1 uE^2
      -1  0  0 -1 uE*vE
       1  0  1  1 vE^2];
b = A \ rhs

% Orig notation
syms e n

A =  [-1 -1  0  1 e
       1  0 -1 -1 alpha*n
       1  1  0  1 e^2
      -1  0  0 -1 alpha*e*n
       1  0  1  1 alpha^2*n^2];
borig = A \ rhs

% Now test the b_k for some arbitrary point and aspect ratio

uE = 0.15;  vE = 0.75;  alpha = 0.8;  e = uE;  n = vE;

D = (uE + vE + 1)*(uE + vE);
format long
bnew = [(alpha^2*(uE^2 + 2*uE*vE + uE) - (vE^2 + vE))/D
                                       (2*(vE - alpha^2*uE + 1))*(uE + vE)/D
                                       (2*(alpha^2*uE - vE + alpha^2))*(uE + vE)/D
 (vE^2 + vE + 2*uE*vE - alpha^2*(uE^2 + uE))/D
                                   (2*(alpha^2 + 1))/D]

% Original coefficients given in Geophysics paper seems partly wrong (b2)
b5 = (2*(alpha^2 + 1))/((uE+vE)*(1+uE+vE));
b4 = 1 - 0.5*b5*(uE+uE^2);
b3 = vE*(1+uE)*b5-2*b4;
%b2 = b3 - (uE^2-vE^2)*b5; % <-- this seems correct
%b2paper = vE*(1+uE)*b5-b3 %<-- This is original paper eq but this must be wrong
b2 = (uE+vE)*b5 - b3;  % African guy via email in Oct 2017
b1 = uE*b5 + b4 - b2;
bpaper = [b1; b2; b3; b4; b5]
d = bnew - bpaper;

s = sum(d.^2);
if (s < 1e-18)
    disp ('New Solution and Published are identical')
else
    disp (['New Solution and Published differ! d = ' num2str(s)]);
end

bpaper2 = [
    (alpha^2*e^2 + 2*alpha^2*e*n + alpha^2*e - n^2 - n)/(e^2 + 2*e*n + e + n^2 + n)
                                           (2*(- e*alpha^2 + n + 1))/(e + n + 1)
                                       (2*(alpha^2*e - n + alpha^2))/(e + n + 1)
       (- alpha^2*e^2 - alpha^2*e + 2*e*n + n^2 + n)/(e^2 + 2*e*n + e + n^2 + n)
                                   (2*(alpha^2 + 1))/(e^2 + 2*e*n + e + n^2 + n)
]

d = bnew - bpaper2;
s = sum(d.^2);
if (s < 1e-18)
    disp ('New Solution and Published2 are identical')
else
    disp (['New Solution and Published2 differ! d = ' num2str(s)]);
end
